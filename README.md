# NDCard

Kartvizit tarama ve dijital kart uygulaması. Flutter + Cupertino tasarım dili,
Riverpod, go_router, drift (offline-first lokal önbellek) ve Supabase backend
(repository soyutlaması arkasında — bkz. `lib/core/domain/repositories/`).

Şu an tamamlanan fazlar: **Faz 0 (iskelet)** ve **Faz 1 (backend temeli)**.

## Gereksinimler

- Flutter stable (bu proje Flutter 3.44.6 ile kuruldu)
- Bir Supabase projesi
- Bir Anthropic Console hesabı (kart tarama OCR'ı için, Faz 3'te kullanılacak)

## Kurulum

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 1. Supabase projesi oluşturun

1. https://supabase.com/dashboard adresinden yeni bir proje oluşturun.
2. Sol menüden **Settings -> API** sayfasına gidin.
3. **Project URL** değerini kopyalayıp kök dizindeki `.env` dosyasında
   `SUPABASE_URL=` satırına yapıştırın.
4. **Project API keys** altındaki **anon / public** key'i kopyalayıp
   `.env` dosyasında `SUPABASE_ANON_KEY=` satırına yapıştırın.

`.env` dosyası `.gitignore`'dadır, commit edilmez. `.env.example` aynı
anahtarları boş değerlerle içerir ve referans için repoda tutulur.

### 2. Veritabanı şemasını çalıştırın

1. Supabase Dashboard'da **SQL Editor** sekmesine gidin.
2. `supabase/migrations/0001_init.sql` dosyasının tüm içeriğini kopyalayıp
   yapıştırın ve **Run** butonuna basın.
3. Bu dosya idempotenttir — tekrar çalıştırmak güvenlidir (örn. şema
   güncellemesi sonrası). Şunları oluşturur:
   - Tüm tablolar + index'ler
   - Her tabloda RLS (kullanıcı yalnızca kendi satırlarını görür/yazar)
   - `updated_at` otomatik güncelleme trigger'ı
   - Yeni kullanıcı kaydında `profiles` + `user_settings` satırlarını
     otomatik oluşturan `auth.users` trigger'ı
   - `card-images` ve `avatars` storage bucket'ları + RLS policy'leri

### 3. Edge Function secret'ını girin (Faz 3'te devreye girecek)

`supabase/functions/.env` dosyasını doldurun:

```env
ANTHROPIC_API_KEY=sk-ant-...
```

Bu anahtarı https://console.anthropic.com/settings/keys adresinden alın.
**Bu anahtar hiçbir zaman Flutter tarafında bulunmaz**, yalnızca edge
function ortamında kullanılır. Supabase CLI kurulduğunda:

```bash
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
```

ya da Dashboard -> **Edge Functions -> scan-card -> Secrets** üzerinden
girilebilir. `scan-card` fonksiyonunun kendisi Faz 3'te eklenecektir.

## Çalıştırma

```bash
flutter run
```

`.env` dosyası boşsa uygulama çökmez; "Yapılandırma Eksik" ekranını
gösterir. Doldurduktan sonra uygulamayı yeniden başlatın.

## Mimari notları

- **Repository soyutlaması**: `lib/core/domain/repositories/` altındaki
  arayüzler UI/iş mantığı katmanının tek bağımlılığıdır. Supabase'e özgü
  hiçbir şey bu arayüzlerin dışına sızmaz. İleride backend değişirse
  yalnızca `lib/core/backend_providers.dart` ve yeni bir
  `lib/core/<backend>/` implementasyon klasörü gerekir.
- **Offline-first**: `digital_cards` ve `scanned_cards` için okumalar önce
  drift'ten (`lib/core/db/app_database.dart`), yazmalar önce lokale sonra
  mümkünse hemen Supabase'e, değilse `pending_sync_queue`'ya gider.
  Bağlantı geldiğinde `SyncEngine` (`lib/core/db/sync/sync_engine.dart`)
  kuyruğu sırayla işler. Diğer tablolar (gruplar, notlar, bildirimler) bu
  fazda doğrudan Supabase üzerinden çalışır; offline kuyruklama kendi
  UI'ları geldiğinde (Faz 5/7) eklenecektir.
- **i18n**: `lib/l10n/app_tr.arb` (şablon) ve `app_en.arb`. Yeni metin
  eklerken önce `app_tr.arb`'a ekleyin, `app_en.arb`'a karşılığını girin,
  sonra `flutter gen-l10n` çalıştırın.
- **iOS**: Bu proje Windows üzerinde geliştirildiği için iOS derlemesi bu
  makinede yapılamaz; `ios/` klasörü hazır, gerçek bir Mac'te
  `flutter build ios` ile derlenebilir.

## Sonraki fazlar

Faz 2 (dijital kart + vCard/QR) → Faz 3 (kamera + `scan-card` edge
function) → Faz 4 (kartlar modülü) → Faz 5 (gruplar/yönetim) → Faz 6
(gelişmiş tarama) → Faz 7 (ayarlar/bildirimler/senkron cilası).
