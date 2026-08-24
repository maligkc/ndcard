import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/domain/entities/scanned_card.dart';

// Google Cloud Console'da People API'nin aktif ve OAuth consent screen'de
// contacts scope'unun eklenmiş olması gerekiyor.
const _contactsScope = 'https://www.googleapis.com/auth/contacts';

final _googleSignIn = GoogleSignIn(
  clientId: '764813904481-2c7epik7u47seqvknnc3m1ulcue8kjpg.apps.googleusercontent.com',
  scopes: [_contactsScope],
);

/// Mevcut Google oturumunun aktif olup olmadığını kontrol eder.
/// signInSilently() çağrısı yapar; UI göstermez.
Future<bool> isGoogleSignedIn() async {
  try {
    if (_googleSignIn.currentUser != null) return true;
    final account = await _googleSignIn.signInSilently();
    return account != null;
  } catch (_) {
    return false;
  }
}

/// Gerekirse etkileşimli giriş ekranı göstererek contacts scope'lu
/// bir Google oturumu açar. Başarılı olursa true döner.
Future<bool> ensureGoogleSignedIn() async {
  try {
    if (_googleSignIn.currentUser != null) return true;
    var account = await _googleSignIn.signInSilently();
    if (account != null) return true;
    // İlk kez ya da scope eksik — stale oturumu temizle, taze giriş yap.
    await _googleSignIn.signOut();
    account = await _googleSignIn.signIn();
    return account != null;
  } catch (e) {
    debugPrint('[GoogleContacts] ensureGoogleSignedIn hatası: $e');
    return false;
  }
}

/// Contacts scope'lu access token alır.
/// Bu instance'ın currentUser'ı varsa sessizce yeniler.
/// Yoksa (veya token'ın scope'u yetersizse) taze giriş yapar.
Future<String?> _getAccessToken() async {
  try {
    // Bu contacts instance'ından daha önce giriş yapılmışsa token'ı yenile.
    var account = _googleSignIn.currentUser;
    if (account != null) {
      final auth = await account.authentication;
      if (auth.accessToken != null) {
        debugPrint('[GoogleContacts] mevcut token kullanıldı');
        return auth.accessToken;
      }
    }

    // Mevcut oturum yok ya da token alınamadı.
    // signOut() ile iOS GIDSignIn'ın contacts scope'suz önbelleği temizlenir,
    // ardından signIn() ile contacts scope dahil taze OAuth akışı başlar.
    await _googleSignIn.signOut();
    account = await _googleSignIn.signIn();

    if (account == null) {
      debugPrint('[GoogleContacts] kullanıcı giriş yapmadı / iptal etti');
      return null;
    }

    final auth = await account.authentication;
    debugPrint('[GoogleContacts] taze token alındı');
    return auth.accessToken;
  } catch (e) {
    debugPrint('[GoogleContacts] _getAccessToken hatası: $e');
    return null;
  }
}

Map<String, dynamic> _buildPersonBody(ScannedCard card) {
  final person = <String, dynamic>{};

  if (card.fullName != null && card.fullName!.isNotEmpty) {
    final parts = card.fullName!.trim().split(' ');
    person['names'] = [
      {
        'givenName': parts.first,
        'familyName': parts.length > 1 ? parts.skip(1).join(' ') : '',
      }
    ];
  }

  if ((card.company != null && card.company!.isNotEmpty) ||
      card.jobTitle != null ||
      card.department != null) {
    person['organizations'] = [
      {
        'name': card.company ?? '',
        'department': card.department ?? '',
        'title': card.jobTitle ?? '',
        'type': 'work',
      }
    ];
  }

  final phones = card.fields
      .where((f) => f.fieldType == 'mobile' || f.fieldType == 'phone' || f.fieldType == 'fax')
      .toList();
  if (phones.isNotEmpty) {
    person['phoneNumbers'] = phones
        .map((f) => {
              'value': f.value,
              'type': f.fieldType == 'mobile'
                  ? 'mobile'
                  : f.fieldType == 'fax'
                      ? 'fax'
                      : 'work',
            })
        .toList();
  }

  final emails = card.fields.where((f) => f.fieldType == 'email').toList();
  if (emails.isNotEmpty) {
    person['emailAddresses'] =
        emails.map((f) => {'value': f.value, 'type': 'work'}).toList();
  }

  final addresses = card.fields.where((f) => f.fieldType == 'address').toList();
  if (addresses.isNotEmpty) {
    person['addresses'] =
        addresses.map((f) => {'formattedValue': f.value, 'type': 'work'}).toList();
  }

  final urls = card.fields.where((f) => f.fieldType == 'url').toList();
  if (urls.isNotEmpty) {
    person['urls'] = urls.map((f) => {'value': f.value, 'type': 'work'}).toList();
  }

  return person;
}

/// null → başarılı, String → hata mesajı
Future<String?> _postJson(String accessToken, String url, Map<String, dynamic> body) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'Bearer $accessToken')
      ..set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
    request.add(utf8.encode(jsonEncode(body)));
    final response = await request.close();
    final statusCode = response.statusCode;
    if (statusCode != 200 && statusCode != 201) {
      final responseBody = await response.transform(utf8.decoder).join();
      debugPrint('[GoogleContacts] API hatası $statusCode: $responseBody');
      client.close();
      return 'API $statusCode hatası: $responseBody';
    }
    client.close();
    return null;
  } catch (e) {
    debugPrint('[GoogleContacts] _postJson hatası: $e');
    client.close();
    return '_postJson hatası: $e';
  }
}

/// Kişi oluşturur ve oluşturulan kişinin resourceName'ini döner.
/// null → hata
Future<String?> _createContactAndGetResourceName(
    String accessToken, Map<String, dynamic> body) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse('https://people.googleapis.com/v1/people:createContact'),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'Bearer $accessToken')
      ..set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
    request.add(utf8.encode(jsonEncode(body)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('[GoogleContacts] createContact hatası ${response.statusCode}: $responseBody');
      client.close();
      return null;
    }
    client.close();
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return json['resourceName'] as String?;
  } catch (e) {
    debugPrint('[GoogleContacts] _createContactAndGetResourceName hatası: $e');
    client.close();
    return null;
  }
}

/// Verilen URL'den görsel indirir ve base64'e çevirir.
Future<String?> _imageUrlToBase64(String imageUrl) async {
  final client = HttpClient();
  try {
    debugPrint('[GoogleContacts] fotoğraf indiriliyor: $imageUrl');
    final request = await client.getUrl(Uri.parse(imageUrl));
    final response = await request.close();
    debugPrint('[GoogleContacts] fotoğraf HTTP ${response.statusCode}');
    if (response.statusCode != 200) {
      client.close();
      return null;
    }
    final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
    client.close();
    debugPrint('[GoogleContacts] fotoğraf base64 hazır, boyut: ${bytes.length} byte');
    return base64Encode(bytes);
  } catch (e) {
    debugPrint('[GoogleContacts] _imageUrlToBase64 hatası: $e');
    client.close();
    return null;
  }
}

/// Kişiye fotoğraf yükler.
Future<void> _updateContactPhoto(
    String accessToken, String resourceName, String photoBase64) async {
  final client = HttpClient();
  try {
    // resourceName = "people/c123456789" — doğrudan URL'e eklenir, encode edilmez.
    final request = await client.openUrl(
      'PATCH',
      Uri.parse(
          'https://people.googleapis.com/v1/$resourceName:updateContactPhoto'),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'Bearer $accessToken')
      ..set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
    request.add(utf8.encode(jsonEncode({'photoBytes': photoBase64})));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    debugPrint('[GoogleContacts] fotoğraf yanıtı ${response.statusCode}: $body');
    client.close();
  } catch (e) {
    debugPrint('[GoogleContacts] _updateContactPhoto hatası: $e');
    client.close();
  }
}

/// Tek kartı Google Contacts'a ekler (fotoğraf dahil).
/// null → başarılı, String → hata nedeni
Future<String?> addCardToGoogleContacts(ScannedCard card) async {
  final body = _buildPersonBody(card);

  var token = await _getAccessToken();
  if (token == null) return 'Google hesabına giriş yapılamadı veya iptal edildi';

  var resourceName = await _createContactAndGetResourceName(token, body);

  // Scope yetersizse → taze giriş yap ve tekrar dene.
  if (resourceName == null) {
    debugPrint('[GoogleContacts] kişi oluşturulamadı, taze sign-in deneniyor...');
    await _googleSignIn.signOut();
    token = await _getAccessToken();
    if (token == null) return 'Google hesabına giriş yapılamadı veya iptal edildi';
    resourceName = await _createContactAndGetResourceName(token, body);
  }

  if (resourceName == null) return 'Kişi Google Contacts\'a eklenemedi';

  // Fotoğraf yükle: önce profil fotoğrafı, yoksa kartvizit ön yüzü.
  final photoUrl = card.profileImageUrl ?? card.frontImageUrl;
  if (photoUrl != null && photoUrl.isNotEmpty) {
    final photoBase64 = await _imageUrlToBase64(photoUrl);
    if (photoBase64 != null) {
      await _updateContactPhoto(token, resourceName, photoBase64);
    }
  }

  return null;
}

/// Birden fazla kartı Google Contacts'a toplu ekler (batchCreateContacts).
/// Döndürülen değer: kaç kart eklendi (-1 = kullanıcı oturum açmadı).
Future<int> addCardsToGoogleContacts(List<ScannedCard> cards) async {
  if (cards.isEmpty) return 0;
  final token = await _getAccessToken();
  if (token == null) return -1;

  // People API batchCreateContacts: en fazla 200 kişi tek istekte
  const batchSize = 200;
  var saved = 0;

  for (var i = 0; i < cards.length; i += batchSize) {
    final chunk = cards.sublist(i, (i + batchSize).clamp(0, cards.length));
    final err = await _postJson(
      token,
      'https://people.googleapis.com/v1/people:batchCreateContacts',
      {
        'contacts': chunk.map((c) => {'contactPerson': _buildPersonBody(c)}).toList(),
        'readMask': 'names',
      },
    );
    if (err == null) saved += chunk.length;
  }

  return saved;
}
