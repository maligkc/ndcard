import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_note.dart';
import '../../../core/domain/repositories/storage_repository.dart';
import '../../../core/widgets/error_dialog.dart';
import '../application/card_notes_provider.dart';
import 'widgets/memo_toolbar.dart';

class NormalMemoPage extends HookConsumerWidget {
  const NormalMemoPage({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final imagePaths = useState<List<String>>([]);
    final isRecording = useState(false);
    final audioPath = useState<String?>(null);
    final isSaving = useState(false);
    final recorder = useMemoized(AudioRecorder.new);

    useEffect(() {
      return () async {
        await recorder.dispose();
      };
    }, const []);

    Future<void> pickFromGallery() async {
      final images = await ImagePicker().pickMultiImage();
      if (images.isNotEmpty) {
        imagePaths.value = [...imagePaths.value, ...images.map((x) => x.path)];
      }
    }

    Future<void> takePhoto() async {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        imagePaths.value = [...imagePaths.value, image.path];
      }
    }

    Future<void> toggleRecording() async {
      if (isRecording.value) {
        final path = await recorder.stop();
        audioPath.value = path;
        isRecording.value = false;
      } else {
        final hasPermission = await recorder.hasPermission();
        if (!hasPermission) return;
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/memo_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await recorder.start(const RecordConfig(), path: path);
        isRecording.value = true;
      }
    }

    Future<void> save() async {
      final text = controller.text.trim();
      if (text.isEmpty && imagePaths.value.isEmpty && audioPath.value == null) {
        return;
      }
      final userId = ref.read(authStateChangesProvider).value?.id;
      if (userId == null) return;

      isSaving.value = true;
      try {
        // Görselleri yükle
        final imageUrls = <String>[];
        for (final path in imagePaths.value) {
          final url = await ref.read(storageRepositoryProvider).uploadFile(
                bucket: StorageBucket.cardImages,
                userId: userId,
                file: File(path),
                fileName: 'note-img-${DateTime.now().millisecondsSinceEpoch}.jpg',
              );
          imageUrls.add(url);
        }

        // Ses kaydını yükle
        String? audioUrl;
        if (audioPath.value != null) {
          audioUrl = await ref.read(storageRepositoryProvider).uploadFile(
                bucket: StorageBucket.cardImages,
                userId: userId,
                file: File(audioPath.value!),
                fileName: 'note-audio-${DateTime.now().millisecondsSinceEpoch}.m4a',
              );
        }

        final content = encodeMemoContent(
          text: text,
          imageUrls: imageUrls,
          audioUrl: audioUrl,
        );

        await ref.read(noteRepositoryProvider).addNote(CardNote(
              id: '',
              userId: userId,
              cardId: cardId,
              content: content,
              noteType: CardNoteType.note,
            ));
        ref.invalidate(cardNotesProvider(cardId));
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isSaving.value = false;
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        middle: const Text('Normal Memo'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSaving.value ? null : save,
          child: isSaving.value
              ? const CupertinoActivityIndicator()
              : const Text(
                  'Save',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CupertinoTextField(
                      controller: controller,
                      placeholder: 'Please fill out the memo',
                      maxLines: null,
                      minLines: 8,
                      textAlignVertical: TextAlignVertical.top,
                      padding: const EdgeInsets.all(14),
                      decoration: null,
                    ),
                  ),
                  MemoImageStrip(
                    files: imagePaths.value,
                    onRemove: (i) {
                      final list = [...imagePaths.value];
                      list.removeAt(i);
                      imagePaths.value = list;
                    },
                  ),
                  if (audioPath.value != null)
                    MemoAudioCard(
                      audioPath: audioPath.value!,
                      onRemove: () => audioPath.value = null,
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            MemoBottomToolbar(
              isRecording: isRecording.value,
              onMic: toggleRecording,
              onGallery: pickFromGallery,
              onCamera: takePhoto,
            ),
          ],
        ),
      ),
    );
  }
}
