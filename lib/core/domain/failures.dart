/// Backend'den bağımsız uygulama hata hiyerarşisi.
/// UI katmanı bu tipleri yakalayıp Türkçe, kullanıcı dostu mesajlar gösterir.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'İnternet bağlantısı yok.']);
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Kayıt bulunamadı.']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Beklenmeyen bir hata oluştu.']);
}
