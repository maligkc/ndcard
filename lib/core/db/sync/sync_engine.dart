import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../app_database.dart';

typedef SyncPushHandler = Future<void> Function(
  String operation,
  Map<String, dynamic> payload,
);

/// Offline-first senkronizasyon iskeleti.
///
/// Yazma işlemleri repository katmanında önce [AppDatabase]'e ve
/// `pending_sync_queue`'ya yazılır; bağlantı geldiğinde burada kayıtlı
/// [SyncPushHandler]'lar sırayla çağrılarak uzak backend'e push edilir.
/// Çakışma çözümü `updated_at` bazlı last-write-wins, repository
/// implementasyonlarında uygulanır. Her repository, kendi tablosu için
/// [registerHandler] ile bir push fonksiyonu kaydeder.
class SyncEngine {
  SyncEngine(this._db);

  final AppDatabase _db;
  final Map<String, SyncPushHandler> _handlers = {};
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSyncing = false;

  void registerHandler(String entityTable, SyncPushHandler handler) {
    _handlers[entityTable] = handler;
  }

  void start() {
    // Uygulama açılışında bekleyen işlemleri hemen gönder.
    syncNow();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        syncNow();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Kuyruktaki bekleyen işlemleri sırayla uzak backend'e gönderir.
  /// Bir öğe başarısız olursa sıradaki senkronizasyona bırakılır (sıra korunur).
  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final items = await _db.pendingSyncItems();
      for (final item in items) {
        final handler = _handlers[item.entityTable];
        if (handler == null) continue;
        try {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          await handler(item.operation, payload);
          await _db.removeSyncItem(item.id);
        } catch (_) {
          break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
