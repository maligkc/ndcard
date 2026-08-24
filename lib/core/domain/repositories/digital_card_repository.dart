import '../entities/digital_card.dart';

abstract interface class DigitalCardRepository {
  /// Lokal (drift) önce, arka planda uzak veriyle senkronize edilen akış.
  Stream<List<DigitalCard>> watchCards(String userId);

  Future<DigitalCard?> getCard(String id);

  /// QR/paylaşım linkiyle taranan, başka bir kullanıcıya ait olabilecek
  /// kartı okur (bkz. 0002_public_card_sharing.sql — herkese açık RLS).
  Future<DigitalCard?> getCardByShareSlug(String slug);

  /// Kart + deneyimler + ek bilgiler + alanları tek seferde upsert eder.
  Future<DigitalCard> saveCard(DigitalCard card);

  /// Kartı geri dönüşüm kutusuna taşır (soft-delete).
  Future<void> deleteCard(String id);

  /// Geri dönüşüm kutusundaki dijital kartları izler.
  Stream<List<DigitalCard>> watchDeletedCards(String userId);

  /// Kartı geri dönüşüm kutusundan geri yükler.
  Future<void> restoreCard(String id);

  /// Kartı kalıcı olarak siler.
  Future<void> permanentlyDeleteCard(String id);

  Future<void> setDefaultCard({required String userId, required String cardId});
}
