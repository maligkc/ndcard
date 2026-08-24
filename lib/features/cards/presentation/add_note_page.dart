import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_note.dart';
import '../../../core/widgets/error_dialog.dart';
import '../application/card_notes_provider.dart';
import 'contact_log_page.dart';
import 'normal_memo_page.dart';
import 'widgets/memo_toolbar.dart';

class AddNotePage extends ConsumerWidget {
  const AddNotePage({super.key, required this.cardId, this.cardName});

  final String cardId;
  final String? cardName;

  void _showTypePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => _NoteTypePicker(
        onSelectNormalMemo: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (_) => NormalMemoPage(cardId: cardId),
            ),
          );
        },
        onSelectContactLog: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (_) => ContactLogPage(
                cardId: cardId,
                cardName: cardName ?? '',
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(cardNotesProvider(cardId));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Memos'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: notesAsync.when(
                loading: () =>
                    const Center(child: CupertinoActivityIndicator()),
                error: (_, __) => const Center(child: Text('Error loading notes')),
                data: (notes) {
                  if (notes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No memos yet',
                        style: TextStyle(color: CupertinoColors.secondaryLabel),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notes.length,
                    separatorBuilder: (ctx, __) => Container(
                      height: 0.5,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: CupertinoColors.systemGrey4.resolveFrom(ctx),
                    ),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return _NoteTile(note: note, cardId: cardId);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: CupertinoButton.filled(
                onPressed: () => _showTypePicker(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.plus, size: 18),
                    SizedBox(width: 8),
                    Text('Create new memo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteTile extends ConsumerWidget {
  const _NoteTile({required this.note, required this.cardId});

  final CardNote note;
  final String cardId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Notu Sil'),
        content: const Text('Bu not kalıcı olarak silinecek. Emin misiniz?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('İptal'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Sil'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(noteRepositoryProvider).deleteNote(note.id);
      ref.invalidate(cardNotesProvider(cardId));
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisitLog = note.noteType == CardNoteType.visitLog;
    final date = note.contactDate ?? note.createdAt;
    final dateStr = date != null
        ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
        : '';

    final plainText = memoPlainText(note.content);
    final imageUrls = memoImageUrls(note.content);
    final audioUrl = memoAudioUrl(note.content);

    final displayText = isVisitLog
        ? (note.contactContent?.isNotEmpty == true
            ? note.contactContent!
            : plainText)
        : plainText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tür badge + tarih + sil butonu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isVisitLog
                      ? CupertinoColors.systemBlue.withOpacity(0.15)
                      : CupertinoColors.systemTeal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isVisitLog ? 'Contact Log' : 'Memo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isVisitLog
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemTeal,
                  ),
                ),
              ),
              const Spacer(),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: 8),
                minSize: 0,
                onPressed: () async {
                  final action = await showCupertinoModalPopup<String>(
                    context: context,
                    builder: (ctx) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(ctx).pop('delete'),
                          child: const Text('Sil'),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('İptal'),
                      ),
                    ),
                  );
                  if (action == 'delete' && context.mounted) {
                    await _confirmDelete(context, ref);
                  }
                },
                child: const Icon(
                  CupertinoIcons.ellipsis,
                  size: 18,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Contact log: iletişim yöntemi
          if (isVisitLog && note.wayOfContact != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                note.wayOfContact!,
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
          // Metin içeriği
          if (displayText.isNotEmpty)
            Text(
              displayText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          // Görsel thumbnails
          if (imageUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrls[i],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: CupertinoColors.systemGrey5.resolveFrom(context),
                      child: const Icon(CupertinoIcons.photo, size: 24),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Ses kaydı oynatıcısı
          if (audioUrl != null) ...[
            const SizedBox(height: 8),
            MemoAudioCard(audioPath: audioUrl),
          ],
        ],
      ),
    );
  }
}

class _NoteTypePicker extends StatelessWidget {
  const _NoteTypePicker({
    required this.onSelectNormalMemo,
    required this.onSelectContactLog,
  });

  final VoidCallback onSelectNormalMemo;
  final VoidCallback onSelectContactLog;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CupertinoColors.black.withOpacity(0.5),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onSelectNormalMemo,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              CupertinoIcons.doc_text,
                              size: 40,
                              color: CupertinoColors.systemTeal,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Normal Memo',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemTeal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Write a free-form note',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel
                                    .resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onSelectContactLog,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              CupertinoIcons.person_2,
                              size: 40,
                              color: CupertinoColors.systemBlue,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Contact Log',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Log a contact interaction',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel
                                    .resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: CupertinoColors.label,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
