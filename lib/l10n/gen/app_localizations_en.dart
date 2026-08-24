// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NDCard';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCards => 'Cards';

  @override
  String get tabScan => 'Camera';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabSettings => 'Settings';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonBack => 'Back';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get configMissingTitle => 'Missing Configuration';

  @override
  String get configMissingMessage =>
      'Please fill in the .env file. SUPABASE_URL and SUPABASE_ANON_KEY are required.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsClearAll => 'Clear All';

  @override
  String get homeEmptyTitle => 'You don\'t have a digital card yet';

  @override
  String get homeEmptyMessage =>
      'Create your own digital business card to start sharing.';

  @override
  String get homeCreateCardButton => 'Create Digital Card';

  @override
  String get cardsEmptyTitle => 'No scanned cards yet';

  @override
  String get cardsEmptyMessage =>
      'Scan a business card from the Camera tab to get started.';

  @override
  String get cardsSearchPlaceholder => 'Search name, company, title';

  @override
  String cardsAllCardsCount(int count) {
    return 'All Cards ($count)';
  }

  @override
  String get cardsGroupsButton => 'Groups';

  @override
  String get cardsManageButton => 'Manage';

  @override
  String get toolsPlaceholder => 'Tools coming soon';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAppSettings => 'App Settings';

  @override
  String get settingsAccountSync => 'Account & Sync';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSystemPermissions => 'System Permissions';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get authLoginTitle => 'Sign In';

  @override
  String get authRegisterTitle => 'Sign Up';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot Password';

  @override
  String get authLoginButton => 'Sign In';

  @override
  String get authRegisterButton => 'Sign Up';

  @override
  String get authNoAccount => 'Don\'t have an account? Sign up';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authResetPasswordTitle => 'Reset Password';

  @override
  String get authResetPasswordMessage =>
      'Enter your email and we\'ll send you a reset link.';

  @override
  String get authResetPasswordButton => 'Send Link';

  @override
  String get authResetPasswordSent => 'Password reset link sent to your email.';

  @override
  String get authInvalidEmail => 'Enter a valid email address.';

  @override
  String get authPasswordTooShort => 'Password must be at least 6 characters.';

  @override
  String get authGenericError => 'Something went wrong, please try again.';

  @override
  String get authSignInWithGoogle => 'Continue with Google';

  @override
  String get homeShareCard => 'Share Card';

  @override
  String get editTabInformations => 'Informations';

  @override
  String get editTabFields => 'Fields';

  @override
  String get editTabDisplay => 'Display';

  @override
  String get infoPersonal => 'Personal Information';

  @override
  String get infoFirstName => 'First Name';

  @override
  String get infoLastName => 'Last Name';

  @override
  String get infoAffiliation => 'Affiliation';

  @override
  String get infoJobTitle => 'Job Title';

  @override
  String get infoDepartment => 'Department';

  @override
  String get infoCompany => 'Company';

  @override
  String get infoHeadline => 'Headline';

  @override
  String get infoExperience => 'Experience';

  @override
  String get experienceAdd => 'Add Experience';

  @override
  String get experienceCompany => 'Company';

  @override
  String get experienceTitle => 'Title';

  @override
  String get experienceStartYear => 'Start Year';

  @override
  String get experienceEndYear => 'End Year';

  @override
  String get experienceIsCurrent => 'I currently work here';

  @override
  String get extraSectionTitle => 'Additional Information';

  @override
  String get extraAddMore => 'Add More Info';

  @override
  String get extraKindPdf => 'PDF Attachment';

  @override
  String get extraKindEducation => 'Education';

  @override
  String get extraKindHonorAward => 'Honors & Awards';

  @override
  String get extraKindOther => 'Other Info';

  @override
  String get extraKindCardImage => 'Card Image';

  @override
  String get extraPdfTitle => 'Title';

  @override
  String get extraEducationSchool => 'School';

  @override
  String get extraEducationDepartment => 'Department';

  @override
  String get extraEducationYear => 'Year';

  @override
  String get extraHonorTitle => 'Title';

  @override
  String get extraHonorYear => 'Year';

  @override
  String get extraHonorDescription => 'Description';

  @override
  String get extraOtherTitle => 'Title';

  @override
  String get extraOtherText => 'Text';

  @override
  String get fieldAdd => 'Add Field';

  @override
  String get fieldLabel => 'Label (Work, Personal, ...)';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhoneMobile => 'Phone (mobile)';

  @override
  String get fieldPhoneLandline => 'Phone (landline)';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldLink => 'Link';

  @override
  String get fieldFax => 'Fax';

  @override
  String get displayThemeGallery => 'Theme Gallery';

  @override
  String get scanLoading => 'Scanning business card…';

  @override
  String get infoFullName => 'Full Name';

  @override
  String get scanWorkEmail => 'Work Email';

  @override
  String get scanSortByCompany => 'Sort by Company';

  @override
  String get scanAddMoreInfo => 'Edit More Info';

  @override
  String get scanAddBackSide => 'Add Back Side';

  @override
  String get scanDeleteCard => 'DELETE CARD';

  @override
  String get cardDeleteConfirmTitle => 'Delete Card';

  @override
  String get cardDeleteConfirmMessage =>
      'This card will be moved to the recycle bin and permanently deleted after 30 days.';

  @override
  String get addressStreet => 'Street';

  @override
  String get addressCity => 'City';

  @override
  String get addressDistrict => 'District';

  @override
  String get addressPostalCode => 'Postal Code';

  @override
  String get addressCountry => 'Country';

  @override
  String get photoRetake => 'Retake';

  @override
  String get photoRotate => 'Rotate';

  @override
  String get photoCrop => 'Crop';

  @override
  String get photoShare => 'Share Image';

  @override
  String get photoPickFromGallery => 'Pick from Gallery';

  @override
  String get cardsSortTitle => 'Sort';

  @override
  String get cardsSortByDate => 'By date';

  @override
  String get cardsSortByName => 'By name';

  @override
  String get cardsSortByCompany => 'By company';

  @override
  String get cardActionCall => 'Call';

  @override
  String get cardActionManageGroups => 'Manage Groups';

  @override
  String get cardActionAddNote => 'Add Note / Visit Log';

  @override
  String get cardActionSaveToContacts => 'Save to Contacts';

  @override
  String get cardActionAddReminder => 'Add Reminder';

  @override
  String get cardContactsPermissionDenied => 'Contacts access was not granted.';

  @override
  String get cardNotesSection => 'Notes';

  @override
  String get noteTypeNote => 'Note';

  @override
  String get noteTypeVisitLog => 'Visit Log';

  @override
  String get reminderMessage => 'Reminder message';

  @override
  String get groupsNewGroup => 'New Group';

  @override
  String get groupsNamePlaceholder => 'Enter group name';

  @override
  String get groupsRename => 'Rename Group';

  @override
  String get groupsDeleteConfirm =>
      'This group will be deleted. Cards are not deleted, only removed from the group.';

  @override
  String get groupsSearchPlaceholder => 'Enter group name';

  @override
  String get groupsSmartGroups => 'Smart Groups';

  @override
  String get groupsRecentlyViewed => 'Viewed in last 30 days';

  @override
  String get groupsRecentlyAdded => 'Recently added';

  @override
  String get groupsUngrouped => 'Ungrouped';

  @override
  String get manageBulkSelect => 'Bulk Select';

  @override
  String get manageImport => 'Import';

  @override
  String get importFromGallery => 'Image from Gallery';

  @override
  String get importFromVcf => 'VCF File (.vcf)';

  @override
  String importSuccess(int count) {
    return '$count cards imported.';
  }

  @override
  String get importVcfEmpty => 'No valid cards found in the VCF file.';

  @override
  String get manageDedup => 'Clean Up Duplicates';

  @override
  String get manageBrowse => 'Browse (Grid View)';

  @override
  String get manageHighAccuracy => 'High Accuracy';

  @override
  String get manageRecycleBin => 'Recycle Bin';

  @override
  String get bulkAssignGroup => 'Assign Group';

  @override
  String get bulkExportCsv => 'Export (CSV)';

  @override
  String get bulkExportVCard => 'Export (vCard zip)';

  @override
  String get bulkSms => 'SMS';

  @override
  String get bulkEmail => 'Email';

  @override
  String get bulkActions => 'Actions';

  @override
  String bulkSelectedCount(int count) {
    return '$count cards selected';
  }

  @override
  String get recycleBinTitle => 'Recycle Bin';

  @override
  String get recycleBinEmpty => 'Recycle bin is empty';

  @override
  String get recycleBinEmptyMessage =>
      'Deleted cards are kept here for 30 days.';

  @override
  String get recycleBinRestore => 'Restore';

  @override
  String get recycleBinPermanentDeleteTitle => 'Delete Permanently';

  @override
  String get duplicatesTitle => 'Clean Up Duplicates';

  @override
  String get duplicatesNone => 'No duplicate cards found';

  @override
  String get duplicatesKeepFirst => 'Keep First, Delete Others';

  @override
  String get duplicatesMerged => 'Duplicate cards cleaned up.';

  @override
  String get scanQrMode => 'QR';

  @override
  String get qrCardNotFound => 'Card not found.';

  @override
  String get qrUrlDetected => 'Link Detected';

  @override
  String get qrOpenLink => 'Open';

  @override
  String get scanQueueTitle => 'Scan Queue';

  @override
  String get scanQueuePending => 'Pending';

  @override
  String get scanQueueDone => 'Done';

  @override
  String scanQueueBadge(int count) {
    return 'Queue ($count)';
  }

  @override
  String get highAccuracyDescription =>
      'When on, scanned card images are sent uncompressed for higher accuracy at the cost of more data usage.';

  @override
  String get systemPermissionsDescription =>
      'You can manage camera, gallery, contacts, and notification permissions from your phone\'s settings app.';

  @override
  String get systemPermissionsOpenSettings => 'Go to Settings';

  @override
  String get notificationsEnabled => 'Allow Notifications';

  @override
  String get notificationsSound => 'Sound';

  @override
  String get notificationsVibrate => 'Vibrate';

  @override
  String get languageSystem => 'System Language';

  @override
  String get generalCacheCleared => 'Cache cleared.';

  @override
  String get generalClearCache => 'Clear Cache';

  @override
  String get generalAppVersion => 'App Version';

  @override
  String get generalAppearance => 'Appearance';

  @override
  String get generalTheme => 'Theme';

  @override
  String get generalThemeSystem => 'System';

  @override
  String get generalThemeLight => 'Light';

  @override
  String get generalThemeDark => 'Dark';

  @override
  String get generalFontSize => 'Font Size';

  @override
  String get generalFontStandard => 'Standard';

  @override
  String get generalFontLarge => 'Large';

  @override
  String get generalFontXLarge => 'Extra Large';

  @override
  String get generalCardSettings => 'Card Settings';

  @override
  String get generalAutoSaveContacts => 'Auto-save new cards to Contacts';

  @override
  String get generalShowGroupOnSave => 'Show group settings when saving cards';

  @override
  String get generalSaveCardImage => 'Save card image';

  @override
  String get generalNameFormat => 'Name Format';

  @override
  String get generalSortOrder => 'Sort Order';

  @override
  String get generalDisplayOrder => 'Display Order';

  @override
  String get generalFirstLast => 'First, Last';

  @override
  String get generalLastFirst => 'Last, First';

  @override
  String get generalRecognitionLangs => 'Recognition Languages';

  @override
  String get generalRecognitionWarning =>
      'Please select languages of your cards. The less you select, the better accuracy you will get.';

  @override
  String get generalStorageSection => 'Storage';

  @override
  String get generalClearSpace => 'Clear Your Space';

  @override
  String generalClearSpaceUsed(String size) {
    return '$size used';
  }

  @override
  String get generalClearSpaceConfirmTitle => 'Clear Cache';

  @override
  String get generalClearSpaceConfirmMessage =>
      'All cached data will be deleted. Continue?';

  @override
  String get generalSecurity => 'Security';

  @override
  String get generalAppLock => 'App Lock';

  @override
  String get generalAppLockSubtitle =>
      'Use Face ID, Touch ID, or passcode to unlock';

  @override
  String get generalAppLockUnlock => 'Unlock';

  @override
  String get langEn => 'English';

  @override
  String get langTr => 'Turkish';

  @override
  String get langFr => 'French';

  @override
  String get langDe => 'German';

  @override
  String get langEs => 'Spanish';

  @override
  String get langIt => 'Italian';

  @override
  String get langPt => 'Portuguese';

  @override
  String get langNl => 'Dutch';

  @override
  String get langRu => 'Russian';

  @override
  String get langAr => 'Arabic';

  @override
  String get langZh => 'Chinese (Simplified)';

  @override
  String get langJa => 'Japanese';

  @override
  String get langKo => 'Korean';

  @override
  String get langHi => 'Hindi';

  @override
  String get cardValidationTitle => 'Required Fields Missing';

  @override
  String get cardValidationMessage =>
      'Please fill in the following required fields:';

  @override
  String get accountDeleteTitle => 'Delete Account';

  @override
  String get accountDeleteMessage =>
      'This cannot be undone. Your account and all your data will be permanently deleted.';

  @override
  String get accountLinkProviders => 'Linked Accounts';

  @override
  String get accountLinked => 'Linked';

  @override
  String get accountLink => 'Link';

  @override
  String get accountUnlink => 'Remove';

  @override
  String get accountUnlinkConfirmTitle => 'Remove Link';

  @override
  String get accountUnlinkConfirmMessage =>
      'Are you sure you want to remove this account link?';

  @override
  String get accountUnlinkLastError =>
      'You cannot remove your last sign-in method.';

  @override
  String get accountLinkPhone => 'Link Phone';

  @override
  String get accountLinkPhoneInput => 'Phone number (+1...)';

  @override
  String get accountLinkPhoneSend => 'Send Verification Code';

  @override
  String get accountLinkPhoneOtp => 'Verification code';

  @override
  String get accountLinkPhoneVerify => 'Verify';

  @override
  String get accountLinkEmail => 'Link Email';

  @override
  String get accountLinkEmailPassword => 'Set a password';

  @override
  String get accountLinkEmailConfirm => 'Add Email';

  @override
  String get accountLinkSuccess => 'Account linked successfully.';

  @override
  String get accountSyncCards => 'Sync Cards';

  @override
  String get accountNeverSynced => 'Never synced';

  @override
  String accountLastSynced(String date) {
    return 'Last synced: $date';
  }

  @override
  String get accountManagement => 'Account Management';

  @override
  String get settingsImportFromCamcard => 'Import from CamCard';

  @override
  String get camcardImportTitle => 'Import from CamCard';

  @override
  String get camcardImportDescription =>
      'You can export your CamCard contacts as a VCF file and import them here.';

  @override
  String get camcardImportStep1 => '1. Open the CamCard app';

  @override
  String get camcardImportStep2 =>
      '2. Profile → Backup & Export → Export Contacts';

  @override
  String get camcardImportStep3 =>
      '3. Choose VCF format and save to the Files app';

  @override
  String get camcardImportStep4 =>
      '4. Tap the button below and select that file';

  @override
  String get camcardImportButton => 'Select VCF File and Import';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get profilePhotoAdd => 'Add Photo';

  @override
  String get profilePhotoRemove => 'Remove Photo';
}
