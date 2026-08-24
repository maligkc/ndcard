import '../domain/entities/ocr_result.dart';
import '../domain/failures.dart';
import '../domain/repositories/ocr_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

/// `scan-card` Edge Function'ını çağırır (bkz. supabase/functions/scan-card).
/// ANTHROPIC_API_KEY yalnızca edge function ortamında kalır; istemci hiçbir
/// zaman doğrudan Anthropic API'sine erişmez.
class SupabaseOcrRepository implements OcrRepository {
  @override
  Future<OcrResult> scanCard({required String imageBase64, String language = 'tr'}) async {
    try {
      final response = await supabaseClient.functions.invoke(
        'scan-card',
        body: {'image_base64': imageBase64, 'language': language},
      );
      if (response.status != 200) {
        throw ValidationException(
          'Kartvizit okunamadı (kod ${response.status}). Lütfen tekrar deneyin.',
        );
      }
      return ocrResultFromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Kartvizit taranırken bir sorun oluştu.');
    }
  }
}
