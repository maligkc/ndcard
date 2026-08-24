// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NDCard';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabCards => 'Kartlar';

  @override
  String get tabScan => 'Kamera';

  @override
  String get tabTools => 'Araçlar';

  @override
  String get tabSettings => 'Ayarlar';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonRetry => 'Tekrar Dene';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonLoading => 'Yükleniyor…';

  @override
  String get commonError => 'Bir hata oluştu';

  @override
  String get commonComingSoon => 'Yakında';

  @override
  String get configMissingTitle => 'Yapılandırma Eksik';

  @override
  String get configMissingMessage =>
      '.env dosyasını doldurun. SUPABASE_URL ve SUPABASE_ANON_KEY değerleri gerekli.';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notificationsEmpty => 'Henüz bildiriminiz yok';

  @override
  String get notificationsClearAll => 'Tümünü Temizle';

  @override
  String get homeEmptyTitle => 'Henüz dijital kartınız yok';

  @override
  String get homeEmptyMessage =>
      'Kendi dijital kartvizitini oluşturarak paylaşmaya başla.';

  @override
  String get homeCreateCardButton => 'Dijital Kart Oluştur';

  @override
  String get cardsEmptyTitle => 'Henüz taranmış kartvizit yok';

  @override
  String get cardsEmptyMessage =>
      'Kamera sekmesinden bir kartvizit tarayarak başla.';

  @override
  String get cardsSearchPlaceholder => 'Ad, şirket, unvan ara';

  @override
  String cardsAllCardsCount(int count) {
    return 'Tüm Kartlar ($count)';
  }

  @override
  String get cardsGroupsButton => 'Gruplar';

  @override
  String get cardsManageButton => 'Yönet';

  @override
  String get toolsPlaceholder => 'Araçlar yakında';

  @override
  String get settingsAccount => 'Hesap';

  @override
  String get settingsAppSettings => 'Uygulama Ayarları';

  @override
  String get settingsAccountSync => 'Hesap ve Senkronizasyon';

  @override
  String get settingsGeneral => 'Genel';

  @override
  String get settingsLanguage => 'Dil Ayarı';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get settingsPrivacy => 'Gizlilik Ayarları';

  @override
  String get settingsSystemPermissions => 'Sistem İzinleri';

  @override
  String get settingsSignOut => 'Çıkış Yap';

  @override
  String get authLoginTitle => 'Giriş Yap';

  @override
  String get authRegisterTitle => 'Kayıt Ol';

  @override
  String get authEmail => 'E-posta';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authForgotPassword => 'Şifremi Unuttum';

  @override
  String get authLoginButton => 'Giriş Yap';

  @override
  String get authRegisterButton => 'Kayıt Ol';

  @override
  String get authNoAccount => 'Hesabın yok mu? Kayıt ol';

  @override
  String get authHaveAccount => 'Zaten hesabın var mı? Giriş yap';

  @override
  String get authResetPasswordTitle => 'Şifremi Sıfırla';

  @override
  String get authResetPasswordMessage =>
      'E-posta adresini gir, sana şifre sıfırlama bağlantısı gönderelim.';

  @override
  String get authResetPasswordButton => 'Bağlantı Gönder';

  @override
  String get authResetPasswordSent =>
      'Şifre sıfırlama bağlantısı e-postana gönderildi.';

  @override
  String get authInvalidEmail => 'Geçerli bir e-posta adresi gir.';

  @override
  String get authPasswordTooShort => 'Şifre en az 6 karakter olmalı.';

  @override
  String get authGenericError => 'Bir sorun oluştu, lütfen tekrar dene.';

  @override
  String get authSignInWithGoogle => 'Google ile devam et';

  @override
  String get homeShareCard => 'Kartı Paylaş';

  @override
  String get editTabInformations => 'Bilgiler';

  @override
  String get editTabFields => 'Alanlar';

  @override
  String get editTabDisplay => 'Görünüm';

  @override
  String get infoPersonal => 'Kişisel Bilgiler';

  @override
  String get infoFirstName => 'Ad';

  @override
  String get infoLastName => 'Soyad';

  @override
  String get infoAffiliation => 'Kurum Bilgileri';

  @override
  String get infoJobTitle => 'Unvan';

  @override
  String get infoDepartment => 'Departman';

  @override
  String get infoCompany => 'Şirket';

  @override
  String get infoHeadline => 'Başlık';

  @override
  String get infoExperience => 'Deneyim';

  @override
  String get experienceAdd => 'Deneyim Ekle';

  @override
  String get experienceCompany => 'Şirket';

  @override
  String get experienceTitle => 'Unvan';

  @override
  String get experienceStartYear => 'Başlangıç Yılı';

  @override
  String get experienceEndYear => 'Bitiş Yılı';

  @override
  String get experienceIsCurrent => 'Halen çalışıyorum';

  @override
  String get extraSectionTitle => 'Ek Bilgiler';

  @override
  String get extraAddMore => 'Daha Fazla Bilgi Ekle';

  @override
  String get extraKindPdf => 'PDF Eki';

  @override
  String get extraKindEducation => 'Eğitim';

  @override
  String get extraKindHonorAward => 'Ödüller';

  @override
  String get extraKindOther => 'Diğer Bilgi';

  @override
  String get extraKindCardImage => 'Kart Görseli';

  @override
  String get extraPdfTitle => 'Başlık';

  @override
  String get extraEducationSchool => 'Okul';

  @override
  String get extraEducationDepartment => 'Bölüm';

  @override
  String get extraEducationYear => 'Yıl';

  @override
  String get extraHonorTitle => 'Başlık';

  @override
  String get extraHonorYear => 'Yıl';

  @override
  String get extraHonorDescription => 'Açıklama';

  @override
  String get extraOtherTitle => 'Başlık';

  @override
  String get extraOtherText => 'Metin';

  @override
  String get fieldAdd => 'Alan Ekle';

  @override
  String get fieldLabel => 'Etiket (İş, Kişisel, ...)';

  @override
  String get fieldEmail => 'E-posta';

  @override
  String get fieldPhoneMobile => 'Telefon (mobil)';

  @override
  String get fieldPhoneLandline => 'Telefon (sabit)';

  @override
  String get fieldAddress => 'Adres';

  @override
  String get fieldWebsite => 'Web Sitesi';

  @override
  String get fieldLink => 'Bağlantı';

  @override
  String get fieldFax => 'Faks';

  @override
  String get displayThemeGallery => 'Tema Galerisi';

  @override
  String get scanLoading => 'Kartvizit taranıyor…';

  @override
  String get infoFullName => 'Ad Soyad';

  @override
  String get scanWorkEmail => 'İş E-postası';

  @override
  String get scanSortByCompany => 'Şirkete Göre Sırala';

  @override
  String get scanAddMoreInfo => 'Daha Fazla Bilgi Düzenle';

  @override
  String get scanAddBackSide => 'Arka Yüz Ekle';

  @override
  String get scanDeleteCard => 'KARTI SİL';

  @override
  String get cardDeleteConfirmTitle => 'Kartı Sil';

  @override
  String get cardDeleteConfirmMessage =>
      'Bu kart geri dönüşüm kutusuna taşınacak ve 30 gün sonra kalıcı olarak silinecek.';

  @override
  String get addressStreet => 'Adres Satırı';

  @override
  String get addressCity => 'İl';

  @override
  String get addressDistrict => 'İlçe';

  @override
  String get addressPostalCode => 'Posta Kodu';

  @override
  String get addressCountry => 'Ülke';

  @override
  String get photoRetake => 'Yeniden Çek';

  @override
  String get photoRotate => 'Döndür';

  @override
  String get photoCrop => 'Kırp';

  @override
  String get photoShare => 'Görseli Paylaş';

  @override
  String get photoPickFromGallery => 'Galeriden Seç';

  @override
  String get cardsSortTitle => 'Sıralama';

  @override
  String get cardsSortByDate => 'Tarihe göre';

  @override
  String get cardsSortByName => 'İsme göre';

  @override
  String get cardsSortByCompany => 'Şirkete göre';

  @override
  String get cardActionCall => 'Ara';

  @override
  String get cardActionManageGroups => 'Grupları Yönet';

  @override
  String get cardActionAddNote => 'Not / Ziyaret Kaydı Ekle';

  @override
  String get cardActionSaveToContacts => 'Rehbere Kaydet';

  @override
  String get cardActionAddReminder => 'Hatırlatıcı Ekle';

  @override
  String get cardContactsPermissionDenied => 'Rehbere erişim izni verilmedi.';

  @override
  String get cardNotesSection => 'Notlar';

  @override
  String get noteTypeNote => 'Not';

  @override
  String get noteTypeVisitLog => 'Ziyaret Kaydı';

  @override
  String get reminderMessage => 'Hatırlatma mesajı';

  @override
  String get groupsNewGroup => 'Yeni Grup';

  @override
  String get groupsNamePlaceholder => 'Grup adı girin';

  @override
  String get groupsRename => 'Grubu Yeniden Adlandır';

  @override
  String get groupsDeleteConfirm =>
      'Bu grup silinecek. Kartlar silinmez, yalnızca gruptan çıkarılır.';

  @override
  String get groupsSearchPlaceholder => 'Grup adı girin';

  @override
  String get groupsSmartGroups => 'Akıllı Gruplar';

  @override
  String get groupsRecentlyViewed => 'Son 30 günde görüntülenenler';

  @override
  String get groupsRecentlyAdded => 'Son eklenenler';

  @override
  String get groupsUngrouped => 'Grupsuz';

  @override
  String get manageBulkSelect => 'Toplu Seçim';

  @override
  String get manageImport => 'İçe Aktar';

  @override
  String get importFromGallery => 'Galeriden Görsel';

  @override
  String get importFromVcf => 'VCF Dosyası (.vcf)';

  @override
  String importSuccess(int count) {
    return '$count kart içe aktarıldı.';
  }

  @override
  String get importVcfEmpty => 'VCF dosyasında geçerli kart bulunamadı.';

  @override
  String get manageDedup => 'Yinelenenleri Temizle';

  @override
  String get manageBrowse => 'Gözat (Izgara Görünümü)';

  @override
  String get manageHighAccuracy => 'Yüksek Doğruluk';

  @override
  String get manageRecycleBin => 'Geri Dönüşüm Kutusu';

  @override
  String get bulkAssignGroup => 'Grup Ata';

  @override
  String get bulkExportCsv => 'Dışa Aktar (CSV)';

  @override
  String get bulkExportVCard => 'Dışa Aktar (vCard zip)';

  @override
  String get bulkSms => 'SMS';

  @override
  String get bulkEmail => 'E-posta';

  @override
  String get bulkActions => 'İşlemler';

  @override
  String bulkSelectedCount(int count) {
    return '$count kart seçildi';
  }

  @override
  String get recycleBinTitle => 'Geri Dönüşüm Kutusu';

  @override
  String get recycleBinEmpty => 'Geri dönüşüm kutusu boş';

  @override
  String get recycleBinEmptyMessage => 'Silinen kartlar burada 30 gün tutulur.';

  @override
  String get recycleBinRestore => 'Geri Al';

  @override
  String get recycleBinPermanentDeleteTitle => 'Kalıcı Olarak Sil';

  @override
  String get duplicatesTitle => 'Yinelenenleri Temizle';

  @override
  String get duplicatesNone => 'Yinelenen kart bulunamadı';

  @override
  String get duplicatesKeepFirst => 'İlkini Tut, Diğerlerini Sil';

  @override
  String get duplicatesMerged => 'Yinelenen kartlar temizlendi.';

  @override
  String get scanQrMode => 'QR';

  @override
  String get qrCardNotFound => 'Kart bulunamadı.';

  @override
  String get qrUrlDetected => 'Bağlantı Algılandı';

  @override
  String get qrOpenLink => 'Aç';

  @override
  String get scanQueueTitle => 'Tarama Kuyruğu';

  @override
  String get scanQueuePending => 'Bekliyor';

  @override
  String get scanQueueDone => 'Tamamlandı';

  @override
  String scanQueueBadge(int count) {
    return 'Kuyruk ($count)';
  }

  @override
  String get highAccuracyDescription =>
      'Açıkken taranan kart görselleri sıkıştırılmadan gönderilir; daha yüksek doğruluk sağlar ancak veri kullanımını artırır.';

  @override
  String get systemPermissionsDescription =>
      'Kamera, galeri, rehber ve bildirim izinlerini telefonunuzun ayarlar uygulamasından yönetebilirsiniz.';

  @override
  String get systemPermissionsOpenSettings => 'Ayarlara Git';

  @override
  String get notificationsEnabled => 'Bildirim Al';

  @override
  String get notificationsSound => 'Ses';

  @override
  String get notificationsVibrate => 'Titreşim';

  @override
  String get languageSystem => 'Sistem Dili';

  @override
  String get generalCacheCleared => 'Önbellek temizlendi.';

  @override
  String get generalClearCache => 'Önbelleği Temizle';

  @override
  String get generalAppVersion => 'Uygulama Sürümü';

  @override
  String get generalAppearance => 'Görünüm';

  @override
  String get generalTheme => 'Tema';

  @override
  String get generalThemeSystem => 'Sistem';

  @override
  String get generalThemeLight => 'Açık';

  @override
  String get generalThemeDark => 'Koyu';

  @override
  String get generalFontSize => 'Yazı Boyutu';

  @override
  String get generalFontStandard => 'Standart';

  @override
  String get generalFontLarge => 'Büyük';

  @override
  String get generalFontXLarge => 'Çok Büyük';

  @override
  String get generalCardSettings => 'Kart Ayarları';

  @override
  String get generalAutoSaveContacts => 'Yeni kartları rehbere otomatik kaydet';

  @override
  String get generalShowGroupOnSave =>
      'Kart kaydederken grup ayarlarını göster';

  @override
  String get generalSaveCardImage => 'Kart görselini kaydet';

  @override
  String get generalNameFormat => 'İsim Formatı';

  @override
  String get generalSortOrder => 'Sıralama Düzeni';

  @override
  String get generalDisplayOrder => 'Görüntüleme Düzeni';

  @override
  String get generalFirstLast => 'Ad, Soyad';

  @override
  String get generalLastFirst => 'Soyad, Ad';

  @override
  String get generalRecognitionLangs => 'Tanıma Dilleri';

  @override
  String get generalRecognitionWarning =>
      'Kartlarınızdaki dilleri seçin. Ne az seçerseniz doğruluk o kadar artar.';

  @override
  String get generalStorageSection => 'Depolama';

  @override
  String get generalClearSpace => 'Alanı Temizle';

  @override
  String generalClearSpaceUsed(String size) {
    return '$size kullanılıyor';
  }

  @override
  String get generalClearSpaceConfirmTitle => 'Önbelleği Temizle';

  @override
  String get generalClearSpaceConfirmMessage =>
      'Tüm önbelleğe alınmış veriler silinecek. Devam edilsin mi?';

  @override
  String get generalSecurity => 'Güvenlik';

  @override
  String get generalAppLock => 'Uygulama Kilidi';

  @override
  String get generalAppLockSubtitle =>
      'Face ID, Touch ID veya parola ile kilidi aç';

  @override
  String get generalAppLockUnlock => 'Kilidi Aç';

  @override
  String get langEn => 'İngilizce';

  @override
  String get langTr => 'Türkçe';

  @override
  String get langFr => 'Fransızca';

  @override
  String get langDe => 'Almanca';

  @override
  String get langEs => 'İspanyolca';

  @override
  String get langIt => 'İtalyanca';

  @override
  String get langPt => 'Portekizce';

  @override
  String get langNl => 'Hollandaca';

  @override
  String get langRu => 'Rusça';

  @override
  String get langAr => 'Arapça';

  @override
  String get langZh => 'Çince (Basit)';

  @override
  String get langJa => 'Japonca';

  @override
  String get langKo => 'Korece';

  @override
  String get langHi => 'Hintçe';

  @override
  String get cardValidationTitle => 'Zorunlu Alanlar Eksik';

  @override
  String get cardValidationMessage =>
      'Lütfen aşağıdaki zorunlu alanları doldurun:';

  @override
  String get accountDeleteTitle => 'Hesabı Sil';

  @override
  String get accountDeleteMessage =>
      'Bu işlem geri alınamaz. Hesabınız ve tüm verileriniz kalıcı olarak silinecek.';

  @override
  String get accountLinkProviders => 'Bağlı Hesaplar';

  @override
  String get accountLinked => 'Bağlı';

  @override
  String get accountLink => 'Bağla';

  @override
  String get accountUnlink => 'Kaldır';

  @override
  String get accountUnlinkConfirmTitle => 'Bağlantıyı Kaldır';

  @override
  String get accountUnlinkConfirmMessage =>
      'Bu hesabın bağlantısını kaldırmak istediğinden emin misin?';

  @override
  String get accountUnlinkLastError => 'Son giriş yöntemini kaldıramazsın.';

  @override
  String get accountLinkPhone => 'Telefon Bağla';

  @override
  String get accountLinkPhoneInput => 'Telefon numarası (+90...)';

  @override
  String get accountLinkPhoneSend => 'Doğrulama Kodu Gönder';

  @override
  String get accountLinkPhoneOtp => 'Doğrulama kodu';

  @override
  String get accountLinkPhoneVerify => 'Doğrula';

  @override
  String get accountLinkEmail => 'E-posta Bağla';

  @override
  String get accountLinkEmailPassword => 'Şifre belirle';

  @override
  String get accountLinkEmailConfirm => 'E-posta Ekle';

  @override
  String get accountLinkSuccess => 'Hesap başarıyla bağlandı.';

  @override
  String get accountSyncCards => 'Kartları Senkronize Et';

  @override
  String get accountNeverSynced => 'Henüz senkronize edilmedi';

  @override
  String accountLastSynced(String date) {
    return 'Son senkron: $date';
  }

  @override
  String get accountManagement => 'Hesap Yönetimi';

  @override
  String get settingsImportFromCamcard => 'CamCard\'dan Kişileri Aktar';

  @override
  String get camcardImportTitle => 'CamCard\'dan Aktarma';

  @override
  String get camcardImportDescription =>
      'CamCard uygulamasındaki kartvizitlerini VCF dosyası olarak dışa aktarıp buraya aktarabilirsin.';

  @override
  String get camcardImportStep1 => '1. CamCard uygulamasını aç';

  @override
  String get camcardImportStep2 =>
      '2. Profil → Yedekle ve Aktar → Kişileri Dışa Aktar';

  @override
  String get camcardImportStep3 =>
      '3. VCF formatını seç ve Dosyalar uygulamasına kaydet';

  @override
  String get camcardImportStep4 => '4. Aşağıdaki butona bas ve o dosyayı seç';

  @override
  String get camcardImportButton => 'VCF Dosyasını Seç ve Aktar';

  @override
  String get profilePhoto => 'Profil Fotoğrafı';

  @override
  String get profilePhotoAdd => 'Fotoğraf Ekle';

  @override
  String get profilePhotoRemove => 'Fotoğrafı Kaldır';
}
