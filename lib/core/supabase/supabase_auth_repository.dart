import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../domain/entities/auth_user.dart';
import '../domain/failures.dart';
import '../domain/repositories/auth_repository.dart';
import 'supabase_client_provider.dart';

class SupabaseAuthRepository implements AuthRepository {
  sb.SupabaseClient get _client => supabaseClient;

  AuthUser? _toAuthUser(sb.User? user) {
    if (user == null) return null;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  AuthUser? get currentUser => _toAuthUser(_client.auth.currentUser);

  @override
  Stream<AuthUser?> get authStateChanges => _client.auth.onAuthStateChange
      .map((state) => _toAuthUser(state.session?.user));

  @override
  Future<AuthUser> signUp({required String email, required String password}) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null) throw const AuthException('Kayıt oluşturulamadı.');
      return AuthUser(id: user.id, email: user.email);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) async {
    try {
      final res =
          await _client.auth.signInWithPassword(email: email, password: password);
      final user = res.user;
      if (user == null) throw const AuthException('Giriş başarısız.');
      return AuthUser(id: user.id, email: user.email);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _client.functions.invoke('delete-account');
      await _client.auth.signOut();
    } catch (_) {
      throw const UnknownException('Hesap silinemedi.');
    }
  }

  @override
  List<({String id, String provider})> get linkedIdentities {
    final identities = _client.auth.currentUser?.identities ?? [];
    return identities.map((i) => (id: i.id, provider: i.provider)).toList();
  }

  @override
  Future<void> linkOAuthProvider(String provider) async {
    try {
      await _client.auth.linkIdentity(
        _toOAuthProvider(provider),
        redirectTo: 'com.ndgroup.ndcard://login-callback',
      );
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (_) {
      throw const AuthException('Hesap bağlanamadı.');
    }
  }

  @override
  Future<void> unlinkIdentity(String identityId) async {
    try {
      final identities = _client.auth.currentUser?.identities ?? [];
      final identity = identities.firstWhere((i) => i.id == identityId);
      await _client.auth.unlinkIdentity(identity);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (_) {
      throw const AuthException('Bağlantı kaldırılamadı.');
    }
  }

  @override
  Future<void> sendPhoneLinkOtp(String phone) async {
    try {
      await _client.auth.updateUser(sb.UserAttributes(phone: phone));
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> verifyPhoneLinkOtp({required String phone, required String token}) async {
    try {
      await _client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: sb.OtpType.phoneChange,
      );
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> linkEmail({required String email, required String password}) async {
    try {
      await _client.auth.updateUser(sb.UserAttributes(email: email, password: password));
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> refreshSession() async {
    await _client.auth.refreshSession();
  }

  sb.OAuthProvider _toOAuthProvider(String name) {
    switch (name) {
      case 'google':
        return sb.OAuthProvider.google;
      case 'linkedin_oidc':
        return sb.OAuthProvider.linkedinOidc;
      default:
        throw ArgumentError('Bilinmeyen provider: $name');
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(
        clientId: '764813904481-2c7epik7u47seqvknnc3m1ulcue8kjpg.apps.googleusercontent.com',
        serverClientId: '764813904481-c5c4aqj520m3nn2tbvq4m7ifqq0nn9kp.apps.googleusercontent.com',
      ).signIn();
      if (googleUser == null) throw const AuthException('Google ile giriş iptal edildi.');

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw const AuthException('Google kimlik bilgisi alınamadı.');

      final res = await _client.auth.signInWithIdToken(
        provider: sb.OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      final user = res.user;
      if (user == null) throw const AuthException('Google ile giriş başarısız.');
      return AuthUser(id: user.id, email: user.email);
    } on AuthException {
      rethrow;
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (_) {
      throw const AuthException('Google ile giriş sırasında hata oluştu.');
    }
  }
}
