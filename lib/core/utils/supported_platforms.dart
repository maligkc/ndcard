import 'package:flutter/cupertino.dart';

import '../../l10n/gen/app_localizations.dart';

enum PlatformInputType { email, phone, address, text }

class SupportedPlatform {
  const SupportedPlatform({
    required this.key,
    required this.fallbackName,
    required this.icon,
    required this.inputType,
    this.vcardType = 'URL',
    this.vcardTypeLabel,
    this.urlTemplate,
  });

  /// Sabit anahtar; DB'de `platform` kolonuna yazılır.
  final String key;

  /// Marka adları (Instagram, LinkedIn, ...) için doğrudan gösterilir;
  /// jenerik olanlar (e-posta, telefon, ...) [platformLabel] ile localize edilir.
  final String fallbackName;
  final IconData icon;
  final PlatformInputType inputType;

  /// vCard 3.0 satırı üretimi için: TEL, EMAIL, ADR veya URL.
  final String vcardType;

  /// URL;TYPE=INSTAGRAM gibi satırlarda kullanılan etiket.
  final String? vcardTypeLabel;

  /// Kullanıcı yalnızca kullanıcı adı girdiyse tam URL üretmek için, örn.
  /// 'https://instagram.com/{value}'.
  final String? urlTemplate;
}

String platformLabel(AppLocalizations l10n, SupportedPlatform platform) {
  switch (platform.key) {
    case 'email':
      return l10n.fieldEmail;
    case 'phone_mobile':
      return l10n.fieldPhoneMobile;
    case 'phone_landline':
      return l10n.fieldPhoneLandline;
    case 'address':
      return l10n.fieldAddress;
    case 'website':
      return l10n.fieldWebsite;
    case 'link':
      return l10n.fieldLink;
    case 'fax':
      return l10n.fieldFax;
    default:
      return platform.fallbackName;
  }
}

const List<SupportedPlatform> kSupportedPlatforms = [
  SupportedPlatform(
    key: 'email',
    fallbackName: 'E-posta',
    icon: CupertinoIcons.mail,
    inputType: PlatformInputType.email,
    vcardType: 'EMAIL',
  ),
  SupportedPlatform(
    key: 'phone_mobile',
    fallbackName: 'Telefon (mobil)',
    icon: CupertinoIcons.phone,
    inputType: PlatformInputType.phone,
    vcardType: 'TEL',
    vcardTypeLabel: 'CELL',
  ),
  SupportedPlatform(
    key: 'phone_landline',
    fallbackName: 'Telefon (sabit)',
    icon: CupertinoIcons.phone_circle,
    inputType: PlatformInputType.phone,
    vcardType: 'TEL',
    vcardTypeLabel: 'WORK',
  ),
  SupportedPlatform(
    key: 'address',
    fallbackName: 'Adres',
    icon: CupertinoIcons.location,
    inputType: PlatformInputType.address,
    vcardType: 'ADR',
  ),
  SupportedPlatform(
    key: 'website',
    fallbackName: 'Web Sitesi',
    icon: CupertinoIcons.globe,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'WEBSITE',
  ),
  SupportedPlatform(
    key: 'link',
    fallbackName: 'Bağlantı',
    icon: CupertinoIcons.link,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'LINK',
  ),
  SupportedPlatform(
    key: 'instagram',
    fallbackName: 'Instagram',
    icon: CupertinoIcons.camera,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'INSTAGRAM',
    urlTemplate: 'https://instagram.com/{value}',
  ),
  SupportedPlatform(
    key: 'linkedin',
    fallbackName: 'LinkedIn',
    icon: CupertinoIcons.person_2,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'LINKEDIN',
    urlTemplate: 'https://linkedin.com/in/{value}',
  ),
  SupportedPlatform(
    key: 'facebook',
    fallbackName: 'Facebook',
    icon: CupertinoIcons.person_crop_square,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'FACEBOOK',
    urlTemplate: 'https://facebook.com/{value}',
  ),
  SupportedPlatform(
    key: 'x',
    fallbackName: 'X.com',
    icon: CupertinoIcons.at,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'X',
    urlTemplate: 'https://x.com/{value}',
  ),
  SupportedPlatform(
    key: 'snapchat',
    fallbackName: 'Snapchat',
    icon: CupertinoIcons.camera_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'SNAPCHAT',
  ),
  SupportedPlatform(
    key: 'tiktok',
    fallbackName: 'TikTok',
    icon: CupertinoIcons.music_note,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'TIKTOK',
    urlTemplate: 'https://tiktok.com/@{value}',
  ),
  SupportedPlatform(
    key: 'youtube',
    fallbackName: 'YouTube',
    icon: CupertinoIcons.play_rectangle,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'YOUTUBE',
  ),
  SupportedPlatform(
    key: 'pinterest',
    fallbackName: 'Pinterest',
    icon: CupertinoIcons.pin,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'PINTEREST',
  ),
  SupportedPlatform(
    key: 'twitch',
    fallbackName: 'Twitch',
    icon: CupertinoIcons.gamecontroller,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'TWITCH',
  ),
  SupportedPlatform(
    key: 'xing',
    fallbackName: 'Xing',
    icon: CupertinoIcons.briefcase,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'XING',
  ),
  SupportedPlatform(
    key: 'threads',
    fallbackName: 'Threads',
    icon: CupertinoIcons.at_badge_plus,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'THREADS',
  ),
  SupportedPlatform(
    key: 'weibo',
    fallbackName: 'Weibo',
    icon: CupertinoIcons.chat_bubble_2,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'WEIBO',
  ),
  SupportedPlatform(
    key: 'qq',
    fallbackName: 'QQ',
    icon: CupertinoIcons.chat_bubble,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'QQ',
  ),
  SupportedPlatform(
    key: 'whatsapp',
    fallbackName: 'WhatsApp',
    icon: CupertinoIcons.phone_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'WHATSAPP',
    urlTemplate: 'https://wa.me/{value}',
  ),
  SupportedPlatform(
    key: 'telegram',
    fallbackName: 'Telegram',
    icon: CupertinoIcons.paperplane,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'TELEGRAM',
    urlTemplate: 'https://t.me/{value}',
  ),
  SupportedPlatform(
    key: 'discord',
    fallbackName: 'Discord',
    icon: CupertinoIcons.game_controller_solid,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'DISCORD',
  ),
  SupportedPlatform(
    key: 'wechat',
    fallbackName: 'WeChat',
    icon: CupertinoIcons.chat_bubble_text,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'WECHAT',
  ),
  SupportedPlatform(
    key: 'line',
    fallbackName: 'Line',
    icon: CupertinoIcons.chat_bubble_2_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'LINE',
  ),
  SupportedPlatform(
    key: 'signal',
    fallbackName: 'Signal',
    icon: CupertinoIcons.lock_shield,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'SIGNAL',
  ),
  SupportedPlatform(
    key: 'fax',
    fallbackName: 'Faks',
    icon: CupertinoIcons.printer,
    inputType: PlatformInputType.phone,
    vcardType: 'TEL',
    vcardTypeLabel: 'FAX',
  ),
  SupportedPlatform(
    key: 'zoom',
    fallbackName: 'Zoom',
    icon: CupertinoIcons.videocam,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'ZOOM',
  ),
  SupportedPlatform(
    key: 'teams',
    fallbackName: 'Teams',
    icon: CupertinoIcons.videocam_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'TEAMS',
  ),
  SupportedPlatform(
    key: 'meet',
    fallbackName: 'Meet',
    icon: CupertinoIcons.video_camera,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'MEET',
  ),
  SupportedPlatform(
    key: 'skype',
    fallbackName: 'Skype',
    icon: CupertinoIcons.phone_badge_plus,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'SKYPE',
  ),
  SupportedPlatform(
    key: 'webex',
    fallbackName: 'Webex',
    icon: CupertinoIcons.tv,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'WEBEX',
  ),
  SupportedPlatform(
    key: 'venmo',
    fallbackName: 'Venmo',
    icon: CupertinoIcons.money_dollar_circle,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'VENMO',
  ),
  SupportedPlatform(
    key: 'paypal',
    fallbackName: 'PayPal',
    icon: CupertinoIcons.money_dollar,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'PAYPAL',
  ),
  SupportedPlatform(
    key: 'cashapp',
    fallbackName: 'Cash App',
    icon: CupertinoIcons.money_dollar_circle_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'CASHAPP',
  ),
  SupportedPlatform(
    key: 'zelle',
    fallbackName: 'Zelle',
    icon: CupertinoIcons.creditcard,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'ZELLE',
  ),
  SupportedPlatform(
    key: 'brightcove',
    fallbackName: 'Brightcove',
    icon: CupertinoIcons.play_circle,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'BRIGHTCOVE',
  ),
  SupportedPlatform(
    key: 'vimeo',
    fallbackName: 'Vimeo',
    icon: CupertinoIcons.play_rectangle_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'VIMEO',
  ),
  SupportedPlatform(
    key: 'spotify',
    fallbackName: 'Spotify',
    icon: CupertinoIcons.music_note_2,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'SPOTIFY',
  ),
  SupportedPlatform(
    key: 'apple_music',
    fallbackName: 'Apple Music',
    icon: CupertinoIcons.music_note_list,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'APPLEMUSIC',
  ),
  SupportedPlatform(
    key: 'soundcloud',
    fallbackName: 'SoundCloud',
    icon: CupertinoIcons.waveform,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'SOUNDCLOUD',
  ),
  SupportedPlatform(
    key: 'behance',
    fallbackName: 'Behance',
    icon: CupertinoIcons.paintbrush,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'BEHANCE',
  ),
  SupportedPlatform(
    key: 'dribbble',
    fallbackName: 'Dribbble',
    icon: CupertinoIcons.paintbrush_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'DRIBBBLE',
  ),
  SupportedPlatform(
    key: 'psn',
    fallbackName: 'PSN',
    icon: CupertinoIcons.gamecontroller_fill,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'PSN',
  ),
  SupportedPlatform(
    key: 'xbox_live',
    fallbackName: 'Xbox Live',
    icon: CupertinoIcons.device_desktop,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'XBOXLIVE',
  ),
  SupportedPlatform(
    key: 'nintendo',
    fallbackName: 'Nintendo',
    icon: CupertinoIcons.game_controller,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'NINTENDO',
  ),
  SupportedPlatform(
    key: 'github',
    fallbackName: 'GitHub',
    icon: CupertinoIcons.chevron_left_slash_chevron_right,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'GITHUB',
    urlTemplate: 'https://github.com/{value}',
  ),
  SupportedPlatform(
    key: 'calendly',
    fallbackName: 'Calendly',
    icon: CupertinoIcons.calendar,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'CALENDLY',
  ),
  SupportedPlatform(
    key: 'patreon',
    fallbackName: 'Patreon',
    icon: CupertinoIcons.heart,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'PATREON',
  ),
  SupportedPlatform(
    key: 'yelp',
    fallbackName: 'Yelp',
    icon: CupertinoIcons.star,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'YELP',
  ),
  SupportedPlatform(
    key: 'ms_bookings',
    fallbackName: 'Microsoft Bookings',
    icon: CupertinoIcons.calendar_badge_plus,
    inputType: PlatformInputType.text,
    vcardTypeLabel: 'MSBOOKINGS',
  ),
];

SupportedPlatform platformByKey(String key) {
  return kSupportedPlatforms.firstWhere(
    (p) => p.key == key,
    orElse: () => kSupportedPlatforms.firstWhere((p) => p.key == 'link'),
  );
}
