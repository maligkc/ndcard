import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;

/// Not içeriğine medya URL'lerini encode eder.
/// Format: "metin\n\n---MEDIA---\nimage:url\naudio:url"
String encodeMemoContent({
  required String text,
  required List<String> imageUrls,
  String? audioUrl,
}) {
  if (imageUrls.isEmpty && audioUrl == null) return text;
  final buf = StringBuffer(text.trimRight());
  buf.write('\n\n---MEDIA---\n');
  for (final url in imageUrls) {
    buf.write('image:$url\n');
  }
  if (audioUrl != null) buf.write('audio:$audioUrl\n');
  return buf.toString();
}

/// Plain text kısmını döndürür (---MEDIA--- öncesi).
String memoPlainText(String content) {
  final idx = content.indexOf('\n\n---MEDIA---\n');
  return idx < 0 ? content : content.substring(0, idx);
}

/// İçerikteki image URL'lerini döndürür.
List<String> memoImageUrls(String content) {
  final idx = content.indexOf('\n\n---MEDIA---\n');
  if (idx < 0) return [];
  final media = content.substring(idx + '\n\n---MEDIA---\n'.length);
  return media
      .split('\n')
      .where((l) => l.startsWith('image:'))
      .map((l) => l.substring(6))
      .where((u) => u.isNotEmpty)
      .toList();
}

/// İçerikteki audio URL'sini döndürür.
String? memoAudioUrl(String content) {
  final idx = content.indexOf('\n\n---MEDIA---\n');
  if (idx < 0) return null;
  final media = content.substring(idx + '\n\n---MEDIA---\n'.length);
  for (final line in media.split('\n')) {
    if (line.startsWith('audio:')) return line.substring(6);
  }
  return null;
}

/// Alt toolbar: mikrofon, galeri, kamera butonları.
class MemoBottomToolbar extends StatefulWidget {
  const MemoBottomToolbar({
    super.key,
    required this.isRecording,
    required this.onMic,
    required this.onGallery,
    required this.onCamera,
  });

  final bool isRecording;
  final VoidCallback onMic;
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  @override
  State<MemoBottomToolbar> createState() => _MemoBottomToolbarState();
}

class _MemoBottomToolbarState extends State<MemoBottomToolbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(MemoBottomToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _seconds = 0;
      _pulseController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
      _timer?.cancel();
      _timer = null;
      _seconds = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey4.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isRecording)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _pulseAnim,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kayıt yapılıyor  ${_formatTime(_seconds)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.destructiveRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: widget.onMic,
                  child: Icon(
                    widget.isRecording
                        ? CupertinoIcons.stop_circle_fill
                        : CupertinoIcons.mic,
                    color: widget.isRecording
                        ? CupertinoColors.destructiveRed
                        : null,
                  ),
                ),
                CupertinoButton(
                  onPressed: widget.isRecording ? null : widget.onGallery,
                  child: Icon(
                    CupertinoIcons.photo,
                    color: widget.isRecording
                        ? CupertinoColors.systemGrey3
                        : null,
                  ),
                ),
                CupertinoButton(
                  onPressed: widget.isRecording ? null : widget.onCamera,
                  child: Icon(
                    CupertinoIcons.camera,
                    color: widget.isRecording
                        ? CupertinoColors.systemGrey3
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Seçili görseller için yatay thumbnail şeridi.
class MemoImageStrip extends StatelessWidget {
  const MemoImageStrip({
    super.key,
    required this.files,
    required this.onRemove,
  });

  final List<String> files; // dosya yolları
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: files.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          // ignore: avoid_dynamic_calls
          final isNetwork = files[i].startsWith('http');
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isNetwork
                    ? Image.network(files[i], width: 80, height: 80, fit: BoxFit.cover)
                    : Image.file(File(files[i]), width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fileThumbnail(context, files[i])),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => onRemove(i),
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 20,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _fileThumbnail(BuildContext context, String path) {
    return Container(
      width: 80,
      height: 80,
      color: CupertinoColors.systemGrey5.resolveFrom(context),
      child: const Icon(CupertinoIcons.photo, size: 32),
    );
  }
}

/// Ses kaydı tamamlandığında gösterilen oynatıcı kart.
/// [audioPath] local dosya yolu veya uzak URL olabilir.
class MemoAudioCard extends StatefulWidget {
  const MemoAudioCard({
    super.key,
    required this.audioPath,
    this.onRemove,
  });

  final String audioPath;
  /// null geçilirse silme butonu gösterilmez (sadece oynatma modu).
  final VoidCallback? onRemove;

  @override
  State<MemoAudioCard> createState() => _MemoAudioCardState();
}

class _MemoAudioCardState extends State<MemoAudioCard> {
  late final AudioPlayer _player;
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _state = s);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _position = Duration.zero);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == PlayerState.playing) {
      await _player.pause();
    } else {
      final path = widget.audioPath;
      if (path.startsWith('http')) {
        await _player.play(UrlSource(path));
      } else {
        await _player.play(DeviceFileSource(path));
      }
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _state == PlayerState.playing;
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _toggle,
                  child: Icon(
                    isPlaying
                        ? CupertinoIcons.pause_circle_fill
                        : CupertinoIcons.play_circle_fill,
                    size: 36,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor:
                              CupertinoColors.systemGrey4.resolveFrom(context),
                          color: CupertinoColors.activeBlue,
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_fmt(_position)} / ${_fmt(_duration)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onRemove != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.onRemove,
                    child: const Icon(
                      CupertinoIcons.xmark_circle,
                      size: 20,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
