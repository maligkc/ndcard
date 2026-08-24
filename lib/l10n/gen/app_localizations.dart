import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// Uygulama adı
  ///
  /// In tr, this message translates to:
  /// **'NDCard'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get tabHome;

  /// No description provided for @tabCards.
  ///
  /// In tr, this message translates to:
  /// **'Kartlar'**
  String get tabCards;

  /// No description provided for @tabScan.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get tabScan;

  /// No description provided for @tabTools.
  ///
  /// In tr, this message translates to:
  /// **'Araçlar'**
  String get tabTools;

  /// No description provided for @tabSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get tabSettings;

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get commonDelete;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get commonOk;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get commonSearch;

  /// No description provided for @commonAdd.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get commonAdd;

  /// No description provided for @commonBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get commonBack;

  /// No description provided for @commonLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get commonError;

  /// No description provided for @commonComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get commonComingSoon;

  /// No description provided for @configMissingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yapılandırma Eksik'**
  String get configMissingTitle;

  /// No description provided for @configMissingMessage.
  ///
  /// In tr, this message translates to:
  /// **'.env dosyasını doldurun. SUPABASE_URL ve SUPABASE_ANON_KEY değerleri gerekli.'**
  String get configMissingMessage;

  /// No description provided for @notificationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bildiriminiz yok'**
  String get notificationsEmpty;

  /// No description provided for @notificationsClearAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Temizle'**
  String get notificationsClearAll;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz dijital kartınız yok'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kendi dijital kartvizitini oluşturarak paylaşmaya başla.'**
  String get homeEmptyMessage;

  /// No description provided for @homeCreateCardButton.
  ///
  /// In tr, this message translates to:
  /// **'Dijital Kart Oluştur'**
  String get homeCreateCardButton;

  /// No description provided for @cardsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz taranmış kartvizit yok'**
  String get cardsEmptyTitle;

  /// No description provided for @cardsEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kamera sekmesinden bir kartvizit tarayarak başla.'**
  String get cardsEmptyMessage;

  /// No description provided for @cardsSearchPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Ad, şirket, unvan ara'**
  String get cardsSearchPlaceholder;

  /// No description provided for @cardsAllCardsCount.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Kartlar ({count})'**
  String cardsAllCardsCount(int count);

  /// No description provided for @cardsGroupsButton.
  ///
  /// In tr, this message translates to:
  /// **'Gruplar'**
  String get cardsGroupsButton;

  /// No description provided for @cardsManageButton.
  ///
  /// In tr, this message translates to:
  /// **'Yönet'**
  String get cardsManageButton;

  /// No description provided for @toolsPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Araçlar yakında'**
  String get toolsPlaceholder;

  /// No description provided for @settingsAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get settingsAccount;

  /// No description provided for @settingsAppSettings.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Ayarları'**
  String get settingsAppSettings;

  /// No description provided for @settingsAccountSync.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ve Senkronizasyon'**
  String get settingsAccountSync;

  /// No description provided for @settingsGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil Ayarı'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Ayarları'**
  String get settingsPrivacy;

  /// No description provided for @settingsSystemPermissions.
  ///
  /// In tr, this message translates to:
  /// **'Sistem İzinleri'**
  String get settingsSystemPermissions;

  /// No description provided for @settingsSignOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get settingsSignOut;

  /// No description provided for @authLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get authRegisterTitle;

  /// No description provided for @authEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get authForgotPassword;

  /// No description provided for @authLoginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authLoginButton;

  /// No description provided for @authRegisterButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get authRegisterButton;

  /// No description provided for @authNoAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın yok mu? Kayıt ol'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı? Giriş yap'**
  String get authHaveAccount;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Sıfırla'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordMessage.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresini gir, sana şifre sıfırlama bağlantısı gönderelim.'**
  String get authResetPasswordMessage;

  /// No description provided for @authResetPasswordButton.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Gönder'**
  String get authResetPasswordButton;

  /// No description provided for @authResetPasswordSent.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısı e-postana gönderildi.'**
  String get authResetPasswordSent;

  /// No description provided for @authInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi gir.'**
  String get authInvalidEmail;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 6 karakter olmalı.'**
  String get authPasswordTooShort;

  /// No description provided for @authGenericError.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu, lütfen tekrar dene.'**
  String get authGenericError;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get authSignInWithGoogle;

  /// No description provided for @homeShareCard.
  ///
  /// In tr, this message translates to:
  /// **'Kartı Paylaş'**
  String get homeShareCard;

  /// No description provided for @editTabInformations.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiler'**
  String get editTabInformations;

  /// No description provided for @editTabFields.
  ///
  /// In tr, this message translates to:
  /// **'Alanlar'**
  String get editTabFields;

  /// No description provided for @editTabDisplay.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get editTabDisplay;

  /// No description provided for @infoPersonal.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Bilgiler'**
  String get infoPersonal;

  /// No description provided for @infoFirstName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get infoFirstName;

  /// No description provided for @infoLastName.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get infoLastName;

  /// No description provided for @infoAffiliation.
  ///
  /// In tr, this message translates to:
  /// **'Kurum Bilgileri'**
  String get infoAffiliation;

  /// No description provided for @infoJobTitle.
  ///
  /// In tr, this message translates to:
  /// **'Unvan'**
  String get infoJobTitle;

  /// No description provided for @infoDepartment.
  ///
  /// In tr, this message translates to:
  /// **'Departman'**
  String get infoDepartment;

  /// No description provided for @infoCompany.
  ///
  /// In tr, this message translates to:
  /// **'Şirket'**
  String get infoCompany;

  /// No description provided for @infoHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get infoHeadline;

  /// No description provided for @infoExperience.
  ///
  /// In tr, this message translates to:
  /// **'Deneyim'**
  String get infoExperience;

  /// No description provided for @experienceAdd.
  ///
  /// In tr, this message translates to:
  /// **'Deneyim Ekle'**
  String get experienceAdd;

  /// No description provided for @experienceCompany.
  ///
  /// In tr, this message translates to:
  /// **'Şirket'**
  String get experienceCompany;

  /// No description provided for @experienceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Unvan'**
  String get experienceTitle;

  /// No description provided for @experienceStartYear.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Yılı'**
  String get experienceStartYear;

  /// No description provided for @experienceEndYear.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş Yılı'**
  String get experienceEndYear;

  /// No description provided for @experienceIsCurrent.
  ///
  /// In tr, this message translates to:
  /// **'Halen çalışıyorum'**
  String get experienceIsCurrent;

  /// No description provided for @extraSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ek Bilgiler'**
  String get extraSectionTitle;

  /// No description provided for @extraAddMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Bilgi Ekle'**
  String get extraAddMore;

  /// No description provided for @extraKindPdf.
  ///
  /// In tr, this message translates to:
  /// **'PDF Eki'**
  String get extraKindPdf;

  /// No description provided for @extraKindEducation.
  ///
  /// In tr, this message translates to:
  /// **'Eğitim'**
  String get extraKindEducation;

  /// No description provided for @extraKindHonorAward.
  ///
  /// In tr, this message translates to:
  /// **'Ödüller'**
  String get extraKindHonorAward;

  /// No description provided for @extraKindOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer Bilgi'**
  String get extraKindOther;

  /// No description provided for @extraKindCardImage.
  ///
  /// In tr, this message translates to:
  /// **'Kart Görseli'**
  String get extraKindCardImage;

  /// No description provided for @extraPdfTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get extraPdfTitle;

  /// No description provided for @extraEducationSchool.
  ///
  /// In tr, this message translates to:
  /// **'Okul'**
  String get extraEducationSchool;

  /// No description provided for @extraEducationDepartment.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm'**
  String get extraEducationDepartment;

  /// No description provided for @extraEducationYear.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get extraEducationYear;

  /// No description provided for @extraHonorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get extraHonorTitle;

  /// No description provided for @extraHonorYear.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get extraHonorYear;

  /// No description provided for @extraHonorDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get extraHonorDescription;

  /// No description provided for @extraOtherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get extraOtherTitle;

  /// No description provided for @extraOtherText.
  ///
  /// In tr, this message translates to:
  /// **'Metin'**
  String get extraOtherText;

  /// No description provided for @fieldAdd.
  ///
  /// In tr, this message translates to:
  /// **'Alan Ekle'**
  String get fieldAdd;

  /// No description provided for @fieldLabel.
  ///
  /// In tr, this message translates to:
  /// **'Etiket (İş, Kişisel, ...)'**
  String get fieldLabel;

  /// No description provided for @fieldEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get fieldEmail;

  /// No description provided for @fieldPhoneMobile.
  ///
  /// In tr, this message translates to:
  /// **'Telefon (mobil)'**
  String get fieldPhoneMobile;

  /// No description provided for @fieldPhoneLandline.
  ///
  /// In tr, this message translates to:
  /// **'Telefon (sabit)'**
  String get fieldPhoneLandline;

  /// No description provided for @fieldAddress.
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get fieldAddress;

  /// No description provided for @fieldWebsite.
  ///
  /// In tr, this message translates to:
  /// **'Web Sitesi'**
  String get fieldWebsite;

  /// No description provided for @fieldLink.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı'**
  String get fieldLink;

  /// No description provided for @fieldFax.
  ///
  /// In tr, this message translates to:
  /// **'Faks'**
  String get fieldFax;

  /// No description provided for @displayThemeGallery.
  ///
  /// In tr, this message translates to:
  /// **'Tema Galerisi'**
  String get displayThemeGallery;

  /// No description provided for @scanLoading.
  ///
  /// In tr, this message translates to:
  /// **'Kartvizit taranıyor…'**
  String get scanLoading;

  /// No description provided for @infoFullName.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get infoFullName;

  /// No description provided for @scanWorkEmail.
  ///
  /// In tr, this message translates to:
  /// **'İş E-postası'**
  String get scanWorkEmail;

  /// No description provided for @scanSortByCompany.
  ///
  /// In tr, this message translates to:
  /// **'Şirkete Göre Sırala'**
  String get scanSortByCompany;

  /// No description provided for @scanAddMoreInfo.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Bilgi Düzenle'**
  String get scanAddMoreInfo;

  /// No description provided for @scanAddBackSide.
  ///
  /// In tr, this message translates to:
  /// **'Arka Yüz Ekle'**
  String get scanAddBackSide;

  /// No description provided for @scanDeleteCard.
  ///
  /// In tr, this message translates to:
  /// **'KARTI SİL'**
  String get scanDeleteCard;

  /// No description provided for @cardDeleteConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kartı Sil'**
  String get cardDeleteConfirmTitle;

  /// No description provided for @cardDeleteConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu kart geri dönüşüm kutusuna taşınacak ve 30 gün sonra kalıcı olarak silinecek.'**
  String get cardDeleteConfirmMessage;

  /// No description provided for @addressStreet.
  ///
  /// In tr, this message translates to:
  /// **'Adres Satırı'**
  String get addressStreet;

  /// No description provided for @addressCity.
  ///
  /// In tr, this message translates to:
  /// **'İl'**
  String get addressCity;

  /// No description provided for @addressDistrict.
  ///
  /// In tr, this message translates to:
  /// **'İlçe'**
  String get addressDistrict;

  /// No description provided for @addressPostalCode.
  ///
  /// In tr, this message translates to:
  /// **'Posta Kodu'**
  String get addressPostalCode;

  /// No description provided for @addressCountry.
  ///
  /// In tr, this message translates to:
  /// **'Ülke'**
  String get addressCountry;

  /// No description provided for @photoRetake.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Çek'**
  String get photoRetake;

  /// No description provided for @photoRotate.
  ///
  /// In tr, this message translates to:
  /// **'Döndür'**
  String get photoRotate;

  /// No description provided for @photoCrop.
  ///
  /// In tr, this message translates to:
  /// **'Kırp'**
  String get photoCrop;

  /// No description provided for @photoShare.
  ///
  /// In tr, this message translates to:
  /// **'Görseli Paylaş'**
  String get photoShare;

  /// No description provided for @photoPickFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get photoPickFromGallery;

  /// No description provided for @cardsSortTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get cardsSortTitle;

  /// No description provided for @cardsSortByDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarihe göre'**
  String get cardsSortByDate;

  /// No description provided for @cardsSortByName.
  ///
  /// In tr, this message translates to:
  /// **'İsme göre'**
  String get cardsSortByName;

  /// No description provided for @cardsSortByCompany.
  ///
  /// In tr, this message translates to:
  /// **'Şirkete göre'**
  String get cardsSortByCompany;

  /// No description provided for @cardActionCall.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get cardActionCall;

  /// No description provided for @cardActionManageGroups.
  ///
  /// In tr, this message translates to:
  /// **'Grupları Yönet'**
  String get cardActionManageGroups;

  /// No description provided for @cardActionAddNote.
  ///
  /// In tr, this message translates to:
  /// **'Not / Ziyaret Kaydı Ekle'**
  String get cardActionAddNote;

  /// No description provided for @cardActionSaveToContacts.
  ///
  /// In tr, this message translates to:
  /// **'Rehbere Kaydet'**
  String get cardActionSaveToContacts;

  /// No description provided for @cardActionAddReminder.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Ekle'**
  String get cardActionAddReminder;

  /// No description provided for @cardContactsPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Rehbere erişim izni verilmedi.'**
  String get cardContactsPermissionDenied;

  /// No description provided for @cardNotesSection.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get cardNotesSection;

  /// No description provided for @noteTypeNote.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get noteTypeNote;

  /// No description provided for @noteTypeVisitLog.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret Kaydı'**
  String get noteTypeVisitLog;

  /// No description provided for @reminderMessage.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma mesajı'**
  String get reminderMessage;

  /// No description provided for @groupsNewGroup.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Grup'**
  String get groupsNewGroup;

  /// No description provided for @groupsNamePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Grup adı girin'**
  String get groupsNamePlaceholder;

  /// No description provided for @groupsRename.
  ///
  /// In tr, this message translates to:
  /// **'Grubu Yeniden Adlandır'**
  String get groupsRename;

  /// No description provided for @groupsDeleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu grup silinecek. Kartlar silinmez, yalnızca gruptan çıkarılır.'**
  String get groupsDeleteConfirm;

  /// No description provided for @groupsSearchPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Grup adı girin'**
  String get groupsSearchPlaceholder;

  /// No description provided for @groupsSmartGroups.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Gruplar'**
  String get groupsSmartGroups;

  /// No description provided for @groupsRecentlyViewed.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 günde görüntülenenler'**
  String get groupsRecentlyViewed;

  /// No description provided for @groupsRecentlyAdded.
  ///
  /// In tr, this message translates to:
  /// **'Son eklenenler'**
  String get groupsRecentlyAdded;

  /// No description provided for @groupsUngrouped.
  ///
  /// In tr, this message translates to:
  /// **'Grupsuz'**
  String get groupsUngrouped;

  /// No description provided for @manageBulkSelect.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Seçim'**
  String get manageBulkSelect;

  /// No description provided for @manageImport.
  ///
  /// In tr, this message translates to:
  /// **'İçe Aktar'**
  String get manageImport;

  /// No description provided for @importFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Görsel'**
  String get importFromGallery;

  /// No description provided for @importFromVcf.
  ///
  /// In tr, this message translates to:
  /// **'VCF Dosyası (.vcf)'**
  String get importFromVcf;

  /// No description provided for @importSuccess.
  ///
  /// In tr, this message translates to:
  /// **'{count} kart içe aktarıldı.'**
  String importSuccess(int count);

  /// No description provided for @importVcfEmpty.
  ///
  /// In tr, this message translates to:
  /// **'VCF dosyasında geçerli kart bulunamadı.'**
  String get importVcfEmpty;

  /// No description provided for @manageDedup.
  ///
  /// In tr, this message translates to:
  /// **'Yinelenenleri Temizle'**
  String get manageDedup;

  /// No description provided for @manageBrowse.
  ///
  /// In tr, this message translates to:
  /// **'Gözat (Izgara Görünümü)'**
  String get manageBrowse;

  /// No description provided for @manageHighAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Doğruluk'**
  String get manageHighAccuracy;

  /// No description provided for @manageRecycleBin.
  ///
  /// In tr, this message translates to:
  /// **'Geri Dönüşüm Kutusu'**
  String get manageRecycleBin;

  /// No description provided for @bulkAssignGroup.
  ///
  /// In tr, this message translates to:
  /// **'Grup Ata'**
  String get bulkAssignGroup;

  /// No description provided for @bulkExportCsv.
  ///
  /// In tr, this message translates to:
  /// **'Dışa Aktar (CSV)'**
  String get bulkExportCsv;

  /// No description provided for @bulkExportVCard.
  ///
  /// In tr, this message translates to:
  /// **'Dışa Aktar (vCard zip)'**
  String get bulkExportVCard;

  /// No description provided for @bulkSms.
  ///
  /// In tr, this message translates to:
  /// **'SMS'**
  String get bulkSms;

  /// No description provided for @bulkEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get bulkEmail;

  /// No description provided for @bulkActions.
  ///
  /// In tr, this message translates to:
  /// **'İşlemler'**
  String get bulkActions;

  /// No description provided for @bulkSelectedCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kart seçildi'**
  String bulkSelectedCount(int count);

  /// No description provided for @recycleBinTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geri Dönüşüm Kutusu'**
  String get recycleBinTitle;

  /// No description provided for @recycleBinEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Geri dönüşüm kutusu boş'**
  String get recycleBinEmpty;

  /// No description provided for @recycleBinEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Silinen kartlar burada 30 gün tutulur.'**
  String get recycleBinEmptyMessage;

  /// No description provided for @recycleBinRestore.
  ///
  /// In tr, this message translates to:
  /// **'Geri Al'**
  String get recycleBinRestore;

  /// No description provided for @recycleBinPermanentDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı Olarak Sil'**
  String get recycleBinPermanentDeleteTitle;

  /// No description provided for @duplicatesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yinelenenleri Temizle'**
  String get duplicatesTitle;

  /// No description provided for @duplicatesNone.
  ///
  /// In tr, this message translates to:
  /// **'Yinelenen kart bulunamadı'**
  String get duplicatesNone;

  /// No description provided for @duplicatesKeepFirst.
  ///
  /// In tr, this message translates to:
  /// **'İlkini Tut, Diğerlerini Sil'**
  String get duplicatesKeepFirst;

  /// No description provided for @duplicatesMerged.
  ///
  /// In tr, this message translates to:
  /// **'Yinelenen kartlar temizlendi.'**
  String get duplicatesMerged;

  /// No description provided for @scanQrMode.
  ///
  /// In tr, this message translates to:
  /// **'QR'**
  String get scanQrMode;

  /// No description provided for @qrCardNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Kart bulunamadı.'**
  String get qrCardNotFound;

  /// No description provided for @qrUrlDetected.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Algılandı'**
  String get qrUrlDetected;

  /// No description provided for @qrOpenLink.
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get qrOpenLink;

  /// No description provided for @scanQueueTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tarama Kuyruğu'**
  String get scanQueueTitle;

  /// No description provided for @scanQueuePending.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get scanQueuePending;

  /// No description provided for @scanQueueDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get scanQueueDone;

  /// No description provided for @scanQueueBadge.
  ///
  /// In tr, this message translates to:
  /// **'Kuyruk ({count})'**
  String scanQueueBadge(int count);

  /// No description provided for @highAccuracyDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıkken taranan kart görselleri sıkıştırılmadan gönderilir; daha yüksek doğruluk sağlar ancak veri kullanımını artırır.'**
  String get highAccuracyDescription;

  /// No description provided for @systemPermissionsDescription.
  ///
  /// In tr, this message translates to:
  /// **'Kamera, galeri, rehber ve bildirim izinlerini telefonunuzun ayarlar uygulamasından yönetebilirsiniz.'**
  String get systemPermissionsDescription;

  /// No description provided for @systemPermissionsOpenSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlara Git'**
  String get systemPermissionsOpenSettings;

  /// No description provided for @notificationsEnabled.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Al'**
  String get notificationsEnabled;

  /// No description provided for @notificationsSound.
  ///
  /// In tr, this message translates to:
  /// **'Ses'**
  String get notificationsSound;

  /// No description provided for @notificationsVibrate.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get notificationsVibrate;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Dili'**
  String get languageSystem;

  /// No description provided for @generalCacheCleared.
  ///
  /// In tr, this message translates to:
  /// **'Önbellek temizlendi.'**
  String get generalCacheCleared;

  /// No description provided for @generalClearCache.
  ///
  /// In tr, this message translates to:
  /// **'Önbelleği Temizle'**
  String get generalClearCache;

  /// No description provided for @generalAppVersion.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Sürümü'**
  String get generalAppVersion;

  /// No description provided for @generalAppearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get generalAppearance;

  /// No description provided for @generalTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get generalTheme;

  /// No description provided for @generalThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get generalThemeSystem;

  /// No description provided for @generalThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get generalThemeLight;

  /// No description provided for @generalThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get generalThemeDark;

  /// No description provided for @generalFontSize.
  ///
  /// In tr, this message translates to:
  /// **'Yazı Boyutu'**
  String get generalFontSize;

  /// No description provided for @generalFontStandard.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get generalFontStandard;

  /// No description provided for @generalFontLarge.
  ///
  /// In tr, this message translates to:
  /// **'Büyük'**
  String get generalFontLarge;

  /// No description provided for @generalFontXLarge.
  ///
  /// In tr, this message translates to:
  /// **'Çok Büyük'**
  String get generalFontXLarge;

  /// No description provided for @generalCardSettings.
  ///
  /// In tr, this message translates to:
  /// **'Kart Ayarları'**
  String get generalCardSettings;

  /// No description provided for @generalAutoSaveContacts.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kartları rehbere otomatik kaydet'**
  String get generalAutoSaveContacts;

  /// No description provided for @generalShowGroupOnSave.
  ///
  /// In tr, this message translates to:
  /// **'Kart kaydederken grup ayarlarını göster'**
  String get generalShowGroupOnSave;

  /// No description provided for @generalSaveCardImage.
  ///
  /// In tr, this message translates to:
  /// **'Kart görselini kaydet'**
  String get generalSaveCardImage;

  /// No description provided for @generalNameFormat.
  ///
  /// In tr, this message translates to:
  /// **'İsim Formatı'**
  String get generalNameFormat;

  /// No description provided for @generalSortOrder.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama Düzeni'**
  String get generalSortOrder;

  /// No description provided for @generalDisplayOrder.
  ///
  /// In tr, this message translates to:
  /// **'Görüntüleme Düzeni'**
  String get generalDisplayOrder;

  /// No description provided for @generalFirstLast.
  ///
  /// In tr, this message translates to:
  /// **'Ad, Soyad'**
  String get generalFirstLast;

  /// No description provided for @generalLastFirst.
  ///
  /// In tr, this message translates to:
  /// **'Soyad, Ad'**
  String get generalLastFirst;

  /// No description provided for @generalRecognitionLangs.
  ///
  /// In tr, this message translates to:
  /// **'Tanıma Dilleri'**
  String get generalRecognitionLangs;

  /// No description provided for @generalRecognitionWarning.
  ///
  /// In tr, this message translates to:
  /// **'Kartlarınızdaki dilleri seçin. Ne az seçerseniz doğruluk o kadar artar.'**
  String get generalRecognitionWarning;

  /// No description provided for @generalStorageSection.
  ///
  /// In tr, this message translates to:
  /// **'Depolama'**
  String get generalStorageSection;

  /// No description provided for @generalClearSpace.
  ///
  /// In tr, this message translates to:
  /// **'Alanı Temizle'**
  String get generalClearSpace;

  /// No description provided for @generalClearSpaceUsed.
  ///
  /// In tr, this message translates to:
  /// **'{size} kullanılıyor'**
  String generalClearSpaceUsed(String size);

  /// No description provided for @generalClearSpaceConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önbelleği Temizle'**
  String get generalClearSpaceConfirmTitle;

  /// No description provided for @generalClearSpaceConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Tüm önbelleğe alınmış veriler silinecek. Devam edilsin mi?'**
  String get generalClearSpaceConfirmMessage;

  /// No description provided for @generalSecurity.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get generalSecurity;

  /// No description provided for @generalAppLock.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Kilidi'**
  String get generalAppLock;

  /// No description provided for @generalAppLockSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Face ID, Touch ID veya parola ile kilidi aç'**
  String get generalAppLockSubtitle;

  /// No description provided for @generalAppLockUnlock.
  ///
  /// In tr, this message translates to:
  /// **'Kilidi Aç'**
  String get generalAppLockUnlock;

  /// No description provided for @langEn.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get langEn;

  /// No description provided for @langTr.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langTr;

  /// No description provided for @langFr.
  ///
  /// In tr, this message translates to:
  /// **'Fransızca'**
  String get langFr;

  /// No description provided for @langDe.
  ///
  /// In tr, this message translates to:
  /// **'Almanca'**
  String get langDe;

  /// No description provided for @langEs.
  ///
  /// In tr, this message translates to:
  /// **'İspanyolca'**
  String get langEs;

  /// No description provided for @langIt.
  ///
  /// In tr, this message translates to:
  /// **'İtalyanca'**
  String get langIt;

  /// No description provided for @langPt.
  ///
  /// In tr, this message translates to:
  /// **'Portekizce'**
  String get langPt;

  /// No description provided for @langNl.
  ///
  /// In tr, this message translates to:
  /// **'Hollandaca'**
  String get langNl;

  /// No description provided for @langRu.
  ///
  /// In tr, this message translates to:
  /// **'Rusça'**
  String get langRu;

  /// No description provided for @langAr.
  ///
  /// In tr, this message translates to:
  /// **'Arapça'**
  String get langAr;

  /// No description provided for @langZh.
  ///
  /// In tr, this message translates to:
  /// **'Çince (Basit)'**
  String get langZh;

  /// No description provided for @langJa.
  ///
  /// In tr, this message translates to:
  /// **'Japonca'**
  String get langJa;

  /// No description provided for @langKo.
  ///
  /// In tr, this message translates to:
  /// **'Korece'**
  String get langKo;

  /// No description provided for @langHi.
  ///
  /// In tr, this message translates to:
  /// **'Hintçe'**
  String get langHi;

  /// No description provided for @cardValidationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu Alanlar Eksik'**
  String get cardValidationTitle;

  /// No description provided for @cardValidationMessage.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen aşağıdaki zorunlu alanları doldurun:'**
  String get cardValidationMessage;

  /// No description provided for @accountDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get accountDeleteTitle;

  /// No description provided for @accountDeleteMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Hesabınız ve tüm verileriniz kalıcı olarak silinecek.'**
  String get accountDeleteMessage;

  /// No description provided for @accountLinkProviders.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı Hesaplar'**
  String get accountLinkProviders;

  /// No description provided for @accountLinked.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı'**
  String get accountLinked;

  /// No description provided for @accountLink.
  ///
  /// In tr, this message translates to:
  /// **'Bağla'**
  String get accountLink;

  /// No description provided for @accountUnlink.
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get accountUnlink;

  /// No description provided for @accountUnlinkConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıyı Kaldır'**
  String get accountUnlinkConfirmTitle;

  /// No description provided for @accountUnlinkConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesabın bağlantısını kaldırmak istediğinden emin misin?'**
  String get accountUnlinkConfirmMessage;

  /// No description provided for @accountUnlinkLastError.
  ///
  /// In tr, this message translates to:
  /// **'Son giriş yöntemini kaldıramazsın.'**
  String get accountUnlinkLastError;

  /// No description provided for @accountLinkPhone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Bağla'**
  String get accountLinkPhone;

  /// No description provided for @accountLinkPhoneInput.
  ///
  /// In tr, this message translates to:
  /// **'Telefon numarası (+90...)'**
  String get accountLinkPhoneInput;

  /// No description provided for @accountLinkPhoneSend.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama Kodu Gönder'**
  String get accountLinkPhoneSend;

  /// No description provided for @accountLinkPhoneOtp.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu'**
  String get accountLinkPhoneOtp;

  /// No description provided for @accountLinkPhoneVerify.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get accountLinkPhoneVerify;

  /// No description provided for @accountLinkEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Bağla'**
  String get accountLinkEmail;

  /// No description provided for @accountLinkEmailPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre belirle'**
  String get accountLinkEmailPassword;

  /// No description provided for @accountLinkEmailConfirm.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Ekle'**
  String get accountLinkEmailConfirm;

  /// No description provided for @accountLinkSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Hesap başarıyla bağlandı.'**
  String get accountLinkSuccess;

  /// No description provided for @accountSyncCards.
  ///
  /// In tr, this message translates to:
  /// **'Kartları Senkronize Et'**
  String get accountSyncCards;

  /// No description provided for @accountNeverSynced.
  ///
  /// In tr, this message translates to:
  /// **'Henüz senkronize edilmedi'**
  String get accountNeverSynced;

  /// No description provided for @accountLastSynced.
  ///
  /// In tr, this message translates to:
  /// **'Son senkron: {date}'**
  String accountLastSynced(String date);

  /// No description provided for @accountManagement.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Yönetimi'**
  String get accountManagement;

  /// No description provided for @settingsImportFromCamcard.
  ///
  /// In tr, this message translates to:
  /// **'CamCard\'dan Kişileri Aktar'**
  String get settingsImportFromCamcard;

  /// No description provided for @camcardImportTitle.
  ///
  /// In tr, this message translates to:
  /// **'CamCard\'dan Aktarma'**
  String get camcardImportTitle;

  /// No description provided for @camcardImportDescription.
  ///
  /// In tr, this message translates to:
  /// **'CamCard uygulamasındaki kartvizitlerini VCF dosyası olarak dışa aktarıp buraya aktarabilirsin.'**
  String get camcardImportDescription;

  /// No description provided for @camcardImportStep1.
  ///
  /// In tr, this message translates to:
  /// **'1. CamCard uygulamasını aç'**
  String get camcardImportStep1;

  /// No description provided for @camcardImportStep2.
  ///
  /// In tr, this message translates to:
  /// **'2. Profil → Yedekle ve Aktar → Kişileri Dışa Aktar'**
  String get camcardImportStep2;

  /// No description provided for @camcardImportStep3.
  ///
  /// In tr, this message translates to:
  /// **'3. VCF formatını seç ve Dosyalar uygulamasına kaydet'**
  String get camcardImportStep3;

  /// No description provided for @camcardImportStep4.
  ///
  /// In tr, this message translates to:
  /// **'4. Aşağıdaki butona bas ve o dosyayı seç'**
  String get camcardImportStep4;

  /// No description provided for @camcardImportButton.
  ///
  /// In tr, this message translates to:
  /// **'VCF Dosyasını Seç ve Aktar'**
  String get camcardImportButton;

  /// No description provided for @profilePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Profil Fotoğrafı'**
  String get profilePhoto;

  /// No description provided for @profilePhotoAdd.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Ekle'**
  String get profilePhotoAdd;

  /// No description provided for @profilePhotoRemove.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı Kaldır'**
  String get profilePhotoRemove;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
