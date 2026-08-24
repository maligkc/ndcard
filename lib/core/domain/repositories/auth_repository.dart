import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> signUp({required String email, required String password});

  Future<AuthUser> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<void> deleteAccount();

  Future<AuthUser> signInWithGoogle();

  /// Mevcut kullanıcıya bağlı provider'ları döner. provider alanı:
  /// 'email', 'phone', 'google', 'facebook', 'linkedin_oidc'
  List<({String id, String provider})> get linkedIdentities;

  /// Web OAuth akışıyla provider bağlar. provider: 'google', 'facebook', 'linkedin_oidc'
  Future<void> linkOAuthProvider(String provider);

  Future<void> unlinkIdentity(String identityId);

  Future<void> sendPhoneLinkOtp(String phone);

  Future<void> verifyPhoneLinkOtp({required String phone, required String token});

  Future<void> linkEmail({required String email, required String password});

  Future<void> refreshSession();
}
