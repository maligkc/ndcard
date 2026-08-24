import '../entities/ocr_result.dart';

abstract interface class OcrRepository {
  /// [imageBase64]: taranan kartvizit görüntüsü. [language]: OCR yanıt dili.
  /// scan-card Edge Function'ını çağırır; hatalıysa AppException fırlatır.
  Future<OcrResult> scanCard({required String imageBase64, String language = 'tr'});
}
