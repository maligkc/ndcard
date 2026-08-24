import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/backend_providers.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/qr_handler.dart';
import '../application/scan_flow.dart';
import '../application/scan_queue_controller.dart';
import 'scan_queue_page.dart';

enum _ScanMode { card, qr }

/// Tam ekran tarama akışı:
/// - Kartvizit modu: çek → kırp → scan-card Edge Function → düzenleme ekranı.
///   "Çoklu" açıkken çekimler kırpılmadan kuyruğa eklenir, arka planda
///   sırayla taranır (bkz. [ScanQueuePage]).
/// - QR modu: NDCard paylaşım linki içe aktarılır, vCard ayrıştırılır,
///   düz URL açmak için onay istenir.
/// - Albüm: galeriden çoklu görsel seçilip kuyruğa eklenir.
class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  CameraController? _controller;
  MobileScannerController? _qrController;
  _ScanMode _mode = _ScanMode.card;
  bool _isFlashOn = false;
  bool _isBusy = false;
  bool _multiMode = false;
  bool _qrProcessing = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _initError = 'no_camera');
        return;
      }
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) setState(() => _initError = 'error');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _qrController?.dispose();
    super.dispose();
  }

  void _switchMode(_ScanMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
    if (mode == _ScanMode.qr) {
      _qrController ??= MobileScannerController();
      _qrController!.start();
    } else {
      _qrController?.stop();
    }
  }

  Future<void> _toggleFlash() async {
    if (_mode == _ScanMode.qr) {
      await _qrController?.toggleTorch();
      return;
    }
    final controller = _controller;
    if (controller == null) return;
    _isFlashOn = !_isFlashOn;
    await controller.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    if (mounted) setState(() {});
  }

  Future<void> _capture() async {
    final controller = _controller;
    final userId = ref.read(authStateChangesProvider).value?.id;
    if (controller == null || _isBusy || userId == null) return;

    setState(() => _isBusy = true);
    try {
      final picture = await controller.takePicture();
      if (!mounted) return;

      if (_multiMode) {
        ref.read(scanQueueProvider.notifier).addFiles([File(picture.path)]);
        return;
      }

      // Otomatik kırp: kart çerçevesini image koordinatlarına çevir.
      final screenSize = MediaQuery.sizeOf(context);
      final guideRect = _cardGuideRect(screenSize);
      final croppedFile = await _autoCropToGuide(
        imagePath: picture.path,
        guideRect: guideRect,
        screenSize: screenSize,
        cameraPreviewSize: controller.value.previewSize ?? const Size(1920, 1080),
      );

      final draft = await runScanFlow(
        storageRepository: ref.read(storageRepositoryProvider),
        ocrRepository: ref.read(ocrRepositoryProvider),
        userId: userId,
        croppedImage: croppedFile,
      );
      if (!mounted) return;
      context.pushReplacement('/scanned-card/edit', extra: draft);
    } catch (e) {
      if (mounted) await showErrorDialog(context, e);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  /// Ekrandaki kart kılavuz dikdörtgenini hesaplar.
  static Rect _cardGuideRect(Size screen) {
    const horizFraction = 0.88;
    const cardRatio = 85.6 / 54.0; // standart kartvizit oranı
    final w = screen.width * horizFraction;
    final h = w / cardRatio;
    final l = (screen.width - w) / 2;
    // Dikey merkezi ekranın %42'sine koy (butonlardan yukarıda)
    final t = screen.height * 0.42 - h / 2;
    return Rect.fromLTWH(l, t, w, h);
  }

  /// Fotoğrafı kılavuz dikdörtgenine göre kırpar.
  Future<File> _autoCropToGuide({
    required String imagePath,
    required Rect guideRect,
    required Size screenSize,
    required Size cameraPreviewSize,
  }) async {
    // previewSize kameranın native (landscape) boyutu; portre için flip yap.
    final isLandscape = cameraPreviewSize.width > cameraPreviewSize.height;
    final imgW = isLandscape ? cameraPreviewSize.height : cameraPreviewSize.width;
    final imgH = isLandscape ? cameraPreviewSize.width : cameraPreviewSize.height;

    // Preview'in ekrandaki gerçek pozisyonu (letterbox hesabı).
    final previewAspect = imgW / imgH;
    final screenAspect = screenSize.width / screenSize.height;
    double previewDisplayW, previewDisplayH, previewLeft, previewTop;
    if (screenAspect < previewAspect) {
      previewDisplayW = screenSize.width;
      previewDisplayH = screenSize.width / previewAspect;
      previewLeft = 0;
      previewTop = (screenSize.height - previewDisplayH) / 2;
    } else {
      previewDisplayH = screenSize.height;
      previewDisplayW = screenSize.height * previewAspect;
      previewLeft = (screenSize.width - previewDisplayW) / 2;
      previewTop = 0;
    }

    // Kılavuz → image koordinatları.
    final xFrac = (guideRect.left - previewLeft) / previewDisplayW;
    final yFrac = (guideRect.top - previewTop) / previewDisplayH;
    final wFrac = guideRect.width / previewDisplayW;
    final hFrac = guideRect.height / previewDisplayH;

    final cropX = (xFrac * imgW).round().clamp(0, imgW.round() - 1);
    final cropY = (yFrac * imgH).round().clamp(0, imgH.round() - 1);
    final cropW = (wFrac * imgW).round().clamp(1, imgW.round() - cropX);
    final cropH = (hFrac * imgH).round().clamp(1, imgH.round() - cropY);

    final bytes = await File(imagePath).readAsBytes();
    final croppedBytes = await compute(_cropInIsolate, {
      'bytes': bytes,
      'x': cropX,
      'y': cropY,
      'w': cropW,
      'h': cropH,
    });

    final tmpDir = await getTemporaryDirectory();
    final out = File('${tmpDir.path}/card_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await out.writeAsBytes(croppedBytes);
    return out;
  }

  Future<void> _pickFromAlbum() async {
    final files = await ImagePicker().pickMultiImage(imageQuality: 90);
    if (files.isEmpty || !mounted) return;
    ref.read(scanQueueProvider.notifier).addFiles(files.map((f) => File(f.path)).toList());
    if (mounted) {
      Navigator.of(context).push(
        CupertinoPageRoute<void>(builder: (_) => const ScanQueuePage()),
      );
    }
  }

  void _openQueue() {
    Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => const ScanQueuePage()));
  }

  Future<void> _onQrDetect(BarcodeCapture capture) async {
    if (_qrProcessing) return;
    final raw = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (raw == null || raw.isEmpty) return;

    _qrProcessing = true;
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.read(authStateChangesProvider).value?.id;

    try {
      switch (classifyQrContent(raw)) {
        case QrContentType.ndcardShare:
          final draft = await importDigitalCardByShareUrl(ref, raw);
          if (!mounted) return;
          if (draft == null) {
            await showErrorDialog(context, StateError(l10n.qrCardNotFound));
            break;
          }
          context.pushReplacement('/scanned-card/edit', extra: draft);
          return;
        case QrContentType.vcard:
          if (userId == null) return;
          final draft = buildScannedCardFromVCardText(userId, raw);
          if (!mounted) return;
          context.pushReplacement('/scanned-card/edit', extra: draft);
          return;
        case QrContentType.url:
          if (!mounted) return;
          final shouldOpen = await showCupertinoDialog<bool>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.qrUrlDetected),
              content: Text(raw),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.commonCancel),
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
                CupertinoDialogAction(
                  child: Text(l10n.qrOpenLink),
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ],
            ),
          );
          if (shouldOpen == true) {
            await launchUrlString(raw, mode: LaunchMode.externalApplication);
          }
          break;
        case QrContentType.unknown:
          if (!mounted) return;
          await showCupertinoDialog<void>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              content: Text(raw),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.commonOk),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
          break;
      }
    } catch (e) {
      if (mounted) await showErrorDialog(context, e);
    } finally {
      _qrProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queueCount = ref.watch(scanQueueProvider).length;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_mode == _ScanMode.qr)
            MobileScanner(controller: _qrController ??= MobileScannerController(), onDetect: _onQrDetect)
          else if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!)
          else if (_initError != null)
            Center(
              child: Text(l10n.commonError, style: const TextStyle(color: CupertinoColors.white)),
            )
          else
            const Center(child: CupertinoActivityIndicator(color: CupertinoColors.white)),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RoundIconButton(icon: CupertinoIcons.xmark, onPressed: () => context.pop()),
                    CupertinoSlidingSegmentedControl<_ScanMode>(
                      groupValue: _mode,
                      backgroundColor: const Color(0x66000000),
                      children: {
                        _ScanMode.card: Text(l10n.tabScan,
                            style: TextStyle(
                              color: _mode == _ScanMode.card
                                  ? CupertinoColors.black
                                  : CupertinoColors.white,
                            )),
                        _ScanMode.qr: Text(l10n.scanQrMode,
                            style: TextStyle(
                              color: _mode == _ScanMode.qr
                                  ? CupertinoColors.black
                                  : CupertinoColors.white,
                            )),
                      },
                      onValueChanged: (v) => _switchMode(v ?? _ScanMode.card),
                    ),
                    _RoundIconButton(
                      icon: _isFlashOn ? CupertinoIcons.bolt_fill : CupertinoIcons.bolt_slash,
                      onPressed: _toggleFlash,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isBusy)
            Container(
              color: const Color(0x88000000),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(color: CupertinoColors.white, radius: 16),
                    const SizedBox(height: 12),
                    Text(l10n.scanLoading, style: const TextStyle(color: CupertinoColors.white)),
                  ],
                ),
              ),
            ),
          // Kart kılavuz çerçevesi
          if (_mode == _ScanMode.card && _controller != null && _controller!.value.isInitialized)
            IgnorePointer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screen = Size(constraints.maxWidth, constraints.maxHeight);
                  final guide = _cardGuideRect(screen);
                  return CustomPaint(
                    size: screen,
                    painter: _CardFramePainter(guide),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: guide.bottom + 12),
                        child: const Text(
                          'Kartı çerçeveye hizalayın',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            shadows: [Shadow(color: Color(0x88000000), blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_mode == _ScanMode.card)
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Column(
                children: [
                  if (queueCount > 0)
                    CupertinoButton(
                      onPressed: _openQueue,
                      child: Text(
                        l10n.scanQueueBadge(queueCount),
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _RoundIconButton(icon: CupertinoIcons.photo_on_rectangle, onPressed: _pickFromAlbum),
                      GestureDetector(
                        onTap: _isBusy ? null : _capture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CupertinoColors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _RoundIconButton(
                        icon: _multiMode
                            ? CupertinoIcons.square_stack_3d_up_fill
                            : CupertinoIcons.square_stack_3d_up,
                        onPressed: () => setState(() => _multiMode = !_multiMode),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Arka planda (isolate) görsel kırpma.
Future<Uint8List> _cropInIsolate(Map<String, Object> args) async {
  final bytes = args['bytes'] as Uint8List;
  final x = args['x'] as int;
  final y = args['y'] as int;
  final w = args['w'] as int;
  final h = args['h'] as int;

  final decoded = img.decodeImage(bytes); // EXIF rotasyonu otomatik uygulanır
  if (decoded == null) return bytes;

  final cX = x.clamp(0, decoded.width - 1);
  final cY = y.clamp(0, decoded.height - 1);
  final cW = w.clamp(1, decoded.width - cX);
  final cH = h.clamp(1, decoded.height - cY);

  final cropped = img.copyCrop(decoded, x: cX, y: cY, width: cW, height: cH);
  return Uint8List.fromList(img.encodeJpg(cropped, quality: 92));
}

/// Kart kılavuz çerçevesi painter: karanlık overlay + şeffaf kesik + köşe parantezler.
class _CardFramePainter extends CustomPainter {
  const _CardFramePainter(this.cardRect);
  final Rect cardRect;

  @override
  void paint(Canvas canvas, Size size) {
    // Karanlık overlay — saveLayer ile BlendMode.clear çalışır.
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0x99000000),
    );
    // Kart alanını şeffaf bırak
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect, const Radius.circular(6)),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // Köşe parantezler
    const bracketLen = 22.0;
    const bracketWidth = 3.0;
    const r = 6.0;
    final p = Paint()
      ..color = CupertinoColors.white
      ..strokeWidth = bracketWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Sol üst
    canvas.drawLine(Offset(cardRect.left + r, cardRect.top), Offset(cardRect.left + r + bracketLen, cardRect.top), p);
    canvas.drawLine(Offset(cardRect.left, cardRect.top + r), Offset(cardRect.left, cardRect.top + r + bracketLen), p);
    // Sağ üst
    canvas.drawLine(Offset(cardRect.right - r, cardRect.top), Offset(cardRect.right - r - bracketLen, cardRect.top), p);
    canvas.drawLine(Offset(cardRect.right, cardRect.top + r), Offset(cardRect.right, cardRect.top + r + bracketLen), p);
    // Sol alt
    canvas.drawLine(Offset(cardRect.left + r, cardRect.bottom), Offset(cardRect.left + r + bracketLen, cardRect.bottom), p);
    canvas.drawLine(Offset(cardRect.left, cardRect.bottom - r), Offset(cardRect.left, cardRect.bottom - r - bracketLen), p);
    // Sağ alt
    canvas.drawLine(Offset(cardRect.right - r, cardRect.bottom), Offset(cardRect.right - r - bracketLen, cardRect.bottom), p);
    canvas.drawLine(Offset(cardRect.right, cardRect.bottom - r), Offset(cardRect.right, cardRect.bottom - r - bracketLen), p);
  }

  @override
  bool shouldRepaint(_CardFramePainter old) => old.cardRect != cardRect;
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Color(0x66000000), shape: BoxShape.circle),
        child: Icon(icon, color: CupertinoColors.white, size: 20),
      ),
    );
  }
}
