import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import 'scan_flow.dart';

enum ScanQueueStatus { pending, scanning, done, error }

class ScanQueueItem {
  ScanQueueItem({
    required this.id,
    required this.imageFile,
    this.status = ScanQueueStatus.pending,
    this.result,
    this.errorMessage,
  });

  final String id;
  final File imageFile;
  final ScanQueueStatus status;
  final ScannedCard? result;
  final String? errorMessage;

  ScanQueueItem copyWith({ScanQueueStatus? status, ScannedCard? result, String? errorMessage}) {
    return ScanQueueItem(
      id: id,
      imageFile: imageFile,
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Çoklu tarama (art arda çekim) ve albümden içe aktarma için ortak kuyruk.
/// Öğeler sırayla (bir anda tek istek) arka planda taranır.
class ScanQueueController extends Notifier<List<ScanQueueItem>> {
  bool _isProcessing = false;

  @override
  List<ScanQueueItem> build() => [];

  void addFiles(List<File> files) {
    final newItems = files.map((f) => ScanQueueItem(id: const Uuid().v4(), imageFile: f));
    state = [...state, ...newItems];
    _processNext();
  }

  void clear() => state = [];

  Future<void> _processNext() async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      while (true) {
        final index = state.indexWhere((i) => i.status == ScanQueueStatus.pending);
        if (index == -1) break;
        final item = state[index];
        _updateItem(item.id, item.copyWith(status: ScanQueueStatus.scanning));
        final userId = ref.read(authStateChangesProvider).value?.id;
        if (userId == null) {
          _updateItem(item.id,
              item.copyWith(status: ScanQueueStatus.error, errorMessage: 'no-user'));
          continue;
        }
        try {
          final result = await runScanFlow(
            storageRepository: ref.read(storageRepositoryProvider),
            ocrRepository: ref.read(ocrRepositoryProvider),
            userId: userId,
            croppedImage: item.imageFile,
          );
          _updateItem(
              item.id, item.copyWith(status: ScanQueueStatus.done, result: result));
        } catch (e) {
          _updateItem(item.id,
              item.copyWith(status: ScanQueueStatus.error, errorMessage: e.toString()));
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  void _updateItem(String id, ScanQueueItem updated) {
    state = [for (final i in state) i.id == id ? updated : i];
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }
}

final scanQueueProvider = NotifierProvider<ScanQueueController, List<ScanQueueItem>>(
  ScanQueueController.new,
);
