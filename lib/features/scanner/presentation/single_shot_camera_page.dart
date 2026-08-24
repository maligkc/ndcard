import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// "Yeniden Çek" / "Arka Yüz Ekle" gibi tekil fotoğraf çekimleri için
/// [ScannerPage]'den bağımsız, OCR tetiklemeyen minimal kamera ekranı.
class SingleShotCameraPage extends StatefulWidget {
  const SingleShotCameraPage({super.key});

  @override
  State<SingleShotCameraPage> createState() => _SingleShotCameraPageState();
}

class _SingleShotCameraPageState extends State<SingleShotCameraPage> {
  CameraController? _controller;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    final controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    await controller.initialize();
    if (!mounted) return;
    setState(() => _controller = controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      final picture = await controller.takePicture();
      if (mounted) context.pop(File(picture.path));
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!)
          else
            const Center(child: CupertinoActivityIndicator(color: CupertinoColors.white)),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: CupertinoButton(
                onPressed: () => context.pop(),
                child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: GestureDetector(
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
                      decoration:
                          const BoxDecoration(shape: BoxShape.circle, color: CupertinoColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
