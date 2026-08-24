import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/storage_repository.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../digital_card/application/photo_picker_helper.dart';
import '../../scanner/presentation/single_shot_camera_page.dart';
import '../application/image_edit_helper.dart';

/// Kart fotoğrafı düzenleme: Yeniden Çek, Döndür, Sil, Kırp, Görseli Paylaş.
/// [isBack] true ise arka yüz görseli düzenlenir/eklenir.
class PhotoEditPage extends ConsumerStatefulWidget {
  const PhotoEditPage({super.key, required this.card, this.isBack = false});

  final ScannedCard card;
  final bool isBack;

  @override
  ConsumerState<PhotoEditPage> createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends ConsumerState<PhotoEditPage> {
  late ScannedCard _card = widget.card;
  bool _isBusy = false;

  String? get _currentUrl => widget.isBack ? _card.backImageUrl : _card.frontImageUrl;

  void _setUrl(String? url) {
    setState(() {
      _card = ScannedCard(
        id: _card.id,
        userId: _card.userId,
        profileImageUrl: _card.profileImageUrl,
        frontImageUrl: widget.isBack ? _card.frontImageUrl : url,
        backImageUrl: widget.isBack ? url : _card.backImageUrl,
        fullName: _card.fullName,
        company: _card.company,
        department: _card.department,
        jobTitle: _card.jobTitle,
        sortByCompany: _card.sortByCompany,
        rawOcr: _card.rawOcr,
        lastViewedAt: _card.lastViewedAt,
        deletedAt: _card.deletedAt,
        fields: _card.fields,
      );
    });
  }

  Future<String> _upload(File file) async {
    final suffix = widget.isBack ? 'back' : 'front';
    return ref.read(storageRepositoryProvider).uploadFile(
          bucket: StorageBucket.cardImages,
          userId: _card.userId,
          file: file,
          fileName: '${_card.id}-$suffix-${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _isBusy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) await showErrorDialog(context, e);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _retake() async {
    await _run(() async {
      final file = await Navigator.of(context).push<File>(
        CupertinoPageRoute(builder: (_) => const SingleShotCameraPage()),
      );
      if (file == null) return;
      final url = await _upload(file);
      _setUrl(url);
    });
  }

  Future<void> _pickFromGallery() async {
    await _run(() async {
      final file = await pickImage();
      if (file == null) return;
      final url = await _upload(file);
      _setUrl(url);
    });
  }

  Future<void> _rotate() async {
    final url = _currentUrl;
    if (url == null) return;
    await _run(() async {
      final local = await downloadToTempFile(url, 'to_rotate.jpg');
      final rotated = await rotateImage(local);
      final newUrl = await _upload(rotated);
      _setUrl(newUrl);
    });
  }

  Future<void> _crop() async {
    final url = _currentUrl;
    if (url == null) return;
    await _run(() async {
      final local = await downloadToTempFile(url, 'to_crop.jpg');
      final cropped = await ImageCropper().cropImage(
        sourcePath: local.path,
        uiSettings: [
          IOSUiSettings(title: 'Kırp'),
          AndroidUiSettings(lockAspectRatio: false),
        ],
      );
      if (cropped == null) return;
      final newUrl = await _upload(File(cropped.path));
      _setUrl(newUrl);
    });
  }

  void _delete() {
    _setUrl(null);
  }

  Future<void> _share() async {
    final url = _currentUrl;
    if (url == null) return;
    await _run(() async {
      final bytes = await downloadBytes(url);
      final file = XFile.fromData(bytes, name: 'kartvizit.jpg', mimeType: 'image/jpeg');
      await SharePlus.instance.share(ShareParams(files: [file]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final url = _currentUrl;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.isBack ? l10n.scanAddBackSide : l10n.commonEdit),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _isBusy
                    ? const CupertinoActivityIndicator()
                    : url != null
                        ? Image.network(url, fit: BoxFit.contain)
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.photo, size: 48),
                              const SizedBox(height: 12),
                              CupertinoButton(
                                onPressed: _retake,
                                child: Text(l10n.photoRetake),
                              ),
                              CupertinoButton(
                                onPressed: _pickFromGallery,
                                child: Text(l10n.photoPickFromGallery),
                              ),
                            ],
                          ),
              ),
            ),
            if (url != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    CupertinoButton(onPressed: _isBusy ? null : _retake, child: Text(l10n.photoRetake)),
                    CupertinoButton(onPressed: _isBusy ? null : _rotate, child: Text(l10n.photoRotate)),
                    CupertinoButton(onPressed: _isBusy ? null : _crop, child: Text(l10n.photoCrop)),
                    CupertinoButton(
                      onPressed: _isBusy ? null : _delete,
                      child: Text(l10n.commonDelete, style: const TextStyle(color: CupertinoColors.destructiveRed)),
                    ),
                    CupertinoButton(onPressed: _isBusy ? null : _share, child: Text(l10n.photoShare)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CupertinoButton.filled(
                onPressed: () => context.pop(_card),
                child: Text(l10n.commonSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
