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

const _wayOfContactOptions = [
  'In person',
  'Phone call',
  'Chat app',
  'Other',
];

class ContactLogPage extends HookConsumerWidget {
  const ContactLogPage({
    super.key,
    required this.cardId,
    required this.cardName,
  });

  final String cardId;
  final String cardName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactDate = useState(DateTime.now());
    final selectedWay = useState(_wayOfContactOptions.first);
    final contentController = useTextEditingController();
    final resultController = useTextEditingController();
    final reminderController = useTextEditingController();
    final isSaving = useState(false);
    final imagePaths = useState<List<String>>([]);
    final isRecording = useState(false);
    final audioPath = useState<String?>(null);
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
            '${dir.path}/contact_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await recorder.start(const RecordConfig(), path: path);
        isRecording.value = true;
      }
    }

    void _pickDate() {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) => Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: contactDate.value,
                  onDateTimeChanged: (d) => contactDate.value = d,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> save() async {
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

        final baseContent = _buildContent(
          date: _formatDate(contactDate.value),
          target: cardName,
          way: selectedWay.value,
          contactContent: contentController.text.trim(),
          result: resultController.text.trim(),
          reminder: reminderController.text.trim(),
        );

        final content = encodeMemoContent(
          text: baseContent,
          imageUrls: imageUrls,
          audioUrl: audioUrl,
        );

        await ref.read(noteRepositoryProvider).addNote(CardNote(
              id: '',
              userId: userId,
              cardId: cardId,
              content: content,
              noteType: CardNoteType.visitLog,
              contactDate: contactDate.value,
              contactTarget: cardName,
              wayOfContact: selectedWay.value,
              contactContent: contentController.text.trim(),
              contactResult: resultController.text.trim(),
              contactReminder: reminderController.text.trim(),
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
        middle: const Text('Contact Log'),
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
                padding: const EdgeInsets.all(16),
                children: [
                  // Contact Date
                  _SectionRow(
                    label: 'Contact Date',
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Row(
                        children: [
                          Text(
                            _formatDate(contactDate.value),
                            style: const TextStyle(
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.chevron_right,
                            size: 14,
                            color: CupertinoColors.activeBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const _Divider(),

                  // Contact Target
                  _SectionRow(
                    label: 'Contact Target',
                    child: Text(
                      cardName,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                      ),
                    ),
                  ),
                  const _Divider(),

                  // Way of Contact
                  const SizedBox(height: 12),
                  const Text(
                    'Way of Contact',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _wayOfContactOptions.map((option) {
                      final isSelected = selectedWay.value == option;
                      return GestureDetector(
                        onTap: () => selectedWay.value = option,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.systemGrey6
                                    .resolveFrom(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.systemGrey4
                                      .resolveFrom(context),
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? CupertinoColors.white
                                  : CupertinoColors.label.resolveFrom(context),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const _Divider(),

                  // Contact Content
                  const SizedBox(height: 12),
                  const Text(
                    'Contact Content',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: contentController,
                    placeholder: 'Please fill out the visiting content',
                    maxLines: 4,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      border: Border.all(
                        color: CupertinoColors.systemGrey4.resolveFrom(context),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact Result
                  const Text(
                    'Contact Result',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: resultController,
                    placeholder: 'Please fill out the visiting result',
                    maxLines: 4,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      border: Border.all(
                        color: CupertinoColors.systemGrey4.resolveFrom(context),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact Reminder
                  const Text(
                    'Contact Reminder',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: reminderController,
                    placeholder: 'Please set up a return contact time',
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      border: Border.all(
                        color: CupertinoColors.systemGrey4.resolveFrom(context),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
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

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _buildContent({
  required String date,
  required String target,
  required String way,
  required String contactContent,
  required String result,
  required String reminder,
}) {
  final parts = <String>[];
  parts.add('Date: $date');
  if (target.isNotEmpty) parts.add('Target: $target');
  parts.add('Way: $way');
  if (contactContent.isNotEmpty) parts.add('Content: $contactContent');
  if (result.isNotEmpty) parts.add('Result: $result');
  if (reminder.isNotEmpty) parts.add('Reminder: $reminder');
  return parts.join('\n');
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: CupertinoColors.systemGrey4.resolveFrom(context),
    );
  }
}

