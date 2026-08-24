import '../entities/scanned_card.dart';

enum ScannedCardSort { date, name, company }

abstract interface class ScannedCardRepository {
  /// Lokal (drift) önce, arka planda uzak veriyle senkronize edilen akış.
  Stream<List<ScannedCard>> watchCards(
    String userId, {
    ScannedCardSort sort = ScannedCardSort.date,
    bool includeDeleted = false,
  });

  Future<ScannedCard?> getCard(String id);

  /// Tek kartı Drift'ten canlı izler; kart değişince yeni değeri emit eder.
  Stream<ScannedCard?> watchCard(String id);

  Future<ScannedCard> saveCard(ScannedCard card);

  /// Toplu içe aktarma için optimize edilmiş batch kayıt.
  /// Tek transaction + tek ağ isteği, [saveCard]'ı döngüde çağırmaktan çok daha hızlı.
  Future<void> saveCards(List<ScannedCard> cards);

  /// Geri dönüşüm kutusuna taşır (deleted_at set edilir, 30 gün saklanır).
  Future<void> softDeleteCard(String id);

  Future<void> restoreCard(String id);

  Future<void> permanentlyDeleteCard(String id);

  Future<void> markViewed(String id);

  /// Cooldown'u atlayarak uzak veriden hemen çeker.
  Future<void> pullNow(String userId);
}
