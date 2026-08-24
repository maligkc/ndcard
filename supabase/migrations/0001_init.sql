-- NDCard — Faz 1: Temel şema, RLS, trigger'lar ve storage bucket'ları
-- Bu dosya baştan sona idempotent olacak şekilde yazılmıştır; tekrar
-- çalıştırıldığında hata vermeden mevcut durumu günceller.
-- Kullanım: Supabase Dashboard -> SQL Editor -> yapıştır -> Run.

create extension if not exists pgcrypto;

-- =========================================================================
-- Ortak: updated_at otomatik güncelleme
-- =========================================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================================================================
-- profiles
-- =========================================================================
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  avatar_url text,
  phone text,
  language text default 'tr',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_delete_own" on public.profiles
  for delete using (auth.uid() = id);

drop trigger if exists set_updated_at on public.profiles;
create trigger set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

-- =========================================================================
-- user_settings
-- =========================================================================
create table if not exists public.user_settings (
  user_id uuid primary key references auth.users (id) on delete cascade,
  notifications_enabled boolean not null default true,
  sound boolean not null default true,
  vibrate boolean not null default true,
  language text default 'tr',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.user_settings enable row level security;

drop policy if exists "user_settings_select_own" on public.user_settings;
create policy "user_settings_select_own" on public.user_settings
  for select using (auth.uid() = user_id);

drop policy if exists "user_settings_insert_own" on public.user_settings;
create policy "user_settings_insert_own" on public.user_settings
  for insert with check (auth.uid() = user_id);

drop policy if exists "user_settings_update_own" on public.user_settings;
create policy "user_settings_update_own" on public.user_settings
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "user_settings_delete_own" on public.user_settings;
create policy "user_settings_delete_own" on public.user_settings
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.user_settings;
create trigger set_updated_at before update on public.user_settings
  for each row execute function public.set_updated_at();

-- =========================================================================
-- digital_cards
-- =========================================================================
create table if not exists public.digital_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  first_name text not null,
  last_name text not null,
  photo_url text,
  job_title text,
  department text,
  company text,
  headline text,
  theme text not null default 'classic',
  is_default boolean not null default false,
  share_slug text unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists digital_cards_user_id_idx on public.digital_cards (user_id);

alter table public.digital_cards enable row level security;

drop policy if exists "digital_cards_select_own" on public.digital_cards;
create policy "digital_cards_select_own" on public.digital_cards
  for select using (auth.uid() = user_id);

drop policy if exists "digital_cards_insert_own" on public.digital_cards;
create policy "digital_cards_insert_own" on public.digital_cards
  for insert with check (auth.uid() = user_id);

drop policy if exists "digital_cards_update_own" on public.digital_cards;
create policy "digital_cards_update_own" on public.digital_cards
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "digital_cards_delete_own" on public.digital_cards;
create policy "digital_cards_delete_own" on public.digital_cards
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.digital_cards;
create trigger set_updated_at before update on public.digital_cards
  for each row execute function public.set_updated_at();

-- =========================================================================
-- digital_card_experiences (deneyim - birden fazla şirket)
-- =========================================================================
create table if not exists public.digital_card_experiences (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references public.digital_cards (id) on delete cascade,
  company text not null,
  title text not null,
  start_date date,
  end_date date,
  is_current boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists digital_card_experiences_card_id_idx
  on public.digital_card_experiences (card_id);

alter table public.digital_card_experiences enable row level security;

drop policy if exists "digital_card_experiences_select_own" on public.digital_card_experiences;
create policy "digital_card_experiences_select_own" on public.digital_card_experiences
  for select using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_experiences_insert_own" on public.digital_card_experiences;
create policy "digital_card_experiences_insert_own" on public.digital_card_experiences
  for insert with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_experiences_update_own" on public.digital_card_experiences;
create policy "digital_card_experiences_update_own" on public.digital_card_experiences
  for update using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_experiences_delete_own" on public.digital_card_experiences;
create policy "digital_card_experiences_delete_own" on public.digital_card_experiences
  for delete using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop trigger if exists set_updated_at on public.digital_card_experiences;
create trigger set_updated_at before update on public.digital_card_experiences
  for each row execute function public.set_updated_at();

-- =========================================================================
-- digital_card_extras (Daha Fazla Bilgi Ekle: pdf/eğitim/ödül/diğer/kart görseli)
-- =========================================================================
create table if not exists public.digital_card_extras (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references public.digital_cards (id) on delete cascade,
  kind text not null check (kind in ('pdf', 'education', 'honor_award', 'other', 'card_image')),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists digital_card_extras_card_id_idx on public.digital_card_extras (card_id);

alter table public.digital_card_extras enable row level security;

drop policy if exists "digital_card_extras_select_own" on public.digital_card_extras;
create policy "digital_card_extras_select_own" on public.digital_card_extras
  for select using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_extras_insert_own" on public.digital_card_extras;
create policy "digital_card_extras_insert_own" on public.digital_card_extras
  for insert with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_extras_update_own" on public.digital_card_extras;
create policy "digital_card_extras_update_own" on public.digital_card_extras
  for update using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_extras_delete_own" on public.digital_card_extras;
create policy "digital_card_extras_delete_own" on public.digital_card_extras
  for delete using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop trigger if exists set_updated_at on public.digital_card_extras;
create trigger set_updated_at before update on public.digital_card_extras
  for each row execute function public.set_updated_at();

-- =========================================================================
-- digital_card_fields (Alanlar sekmesi: e-posta, telefon, sosyal medya, ...)
-- =========================================================================
create table if not exists public.digital_card_fields (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references public.digital_cards (id) on delete cascade,
  platform text not null,
  label text default '',
  value text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists digital_card_fields_card_id_idx on public.digital_card_fields (card_id);

alter table public.digital_card_fields enable row level security;

drop policy if exists "digital_card_fields_select_own" on public.digital_card_fields;
create policy "digital_card_fields_select_own" on public.digital_card_fields
  for select using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_fields_insert_own" on public.digital_card_fields;
create policy "digital_card_fields_insert_own" on public.digital_card_fields
  for insert with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_fields_update_own" on public.digital_card_fields;
create policy "digital_card_fields_update_own" on public.digital_card_fields
  for update using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "digital_card_fields_delete_own" on public.digital_card_fields;
create policy "digital_card_fields_delete_own" on public.digital_card_fields
  for delete using (
    exists (select 1 from public.digital_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop trigger if exists set_updated_at on public.digital_card_fields;
create trigger set_updated_at before update on public.digital_card_fields
  for each row execute function public.set_updated_at();

-- =========================================================================
-- scanned_cards (taranan kartvizitler)
-- =========================================================================
create table if not exists public.scanned_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  front_image_url text,
  back_image_url text,
  full_name text,
  company text,
  department text,
  job_title text,
  sort_by_company boolean not null default false,
  raw_ocr jsonb,
  last_viewed_at timestamptz,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists scanned_cards_user_id_idx on public.scanned_cards (user_id);
create index if not exists scanned_cards_last_viewed_at_idx on public.scanned_cards (last_viewed_at);
create index if not exists scanned_cards_deleted_at_idx on public.scanned_cards (deleted_at)
  where deleted_at is not null;

alter table public.scanned_cards enable row level security;

drop policy if exists "scanned_cards_select_own" on public.scanned_cards;
create policy "scanned_cards_select_own" on public.scanned_cards
  for select using (auth.uid() = user_id);

drop policy if exists "scanned_cards_insert_own" on public.scanned_cards;
create policy "scanned_cards_insert_own" on public.scanned_cards
  for insert with check (auth.uid() = user_id);

drop policy if exists "scanned_cards_update_own" on public.scanned_cards;
create policy "scanned_cards_update_own" on public.scanned_cards
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "scanned_cards_delete_own" on public.scanned_cards;
create policy "scanned_cards_delete_own" on public.scanned_cards
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.scanned_cards;
create trigger set_updated_at before update on public.scanned_cards
  for each row execute function public.set_updated_at();

-- =========================================================================
-- scanned_card_fields (telefon, e-posta, adres, url, faks, ...)
-- =========================================================================
create table if not exists public.scanned_card_fields (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references public.scanned_cards (id) on delete cascade,
  field_type text not null,
  label text default '',
  value text not null,
  address_detail jsonb,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists scanned_card_fields_card_id_idx on public.scanned_card_fields (card_id);

alter table public.scanned_card_fields enable row level security;

drop policy if exists "scanned_card_fields_select_own" on public.scanned_card_fields;
create policy "scanned_card_fields_select_own" on public.scanned_card_fields
  for select using (
    exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "scanned_card_fields_insert_own" on public.scanned_card_fields;
create policy "scanned_card_fields_insert_own" on public.scanned_card_fields
  for insert with check (
    exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "scanned_card_fields_update_own" on public.scanned_card_fields;
create policy "scanned_card_fields_update_own" on public.scanned_card_fields
  for update using (
    exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "scanned_card_fields_delete_own" on public.scanned_card_fields;
create policy "scanned_card_fields_delete_own" on public.scanned_card_fields
  for delete using (
    exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop trigger if exists set_updated_at on public.scanned_card_fields;
create trigger set_updated_at before update on public.scanned_card_fields
  for each row execute function public.set_updated_at();

-- =========================================================================
-- card_groups
-- =========================================================================
create table if not exists public.card_groups (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists card_groups_user_id_idx on public.card_groups (user_id);

alter table public.card_groups enable row level security;

drop policy if exists "card_groups_select_own" on public.card_groups;
create policy "card_groups_select_own" on public.card_groups
  for select using (auth.uid() = user_id);

drop policy if exists "card_groups_insert_own" on public.card_groups;
create policy "card_groups_insert_own" on public.card_groups
  for insert with check (auth.uid() = user_id);

drop policy if exists "card_groups_update_own" on public.card_groups;
create policy "card_groups_update_own" on public.card_groups
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "card_groups_delete_own" on public.card_groups;
create policy "card_groups_delete_own" on public.card_groups
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.card_groups;
create trigger set_updated_at before update on public.card_groups
  for each row execute function public.set_updated_at();

-- =========================================================================
-- card_group_members (junction: bir kart birden fazla grupta olabilir)
-- =========================================================================
create table if not exists public.card_group_members (
  group_id uuid not null references public.card_groups (id) on delete cascade,
  card_id uuid not null references public.scanned_cards (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (group_id, card_id)
);

create index if not exists card_group_members_card_id_idx on public.card_group_members (card_id);

alter table public.card_group_members enable row level security;

drop policy if exists "card_group_members_select_own" on public.card_group_members;
create policy "card_group_members_select_own" on public.card_group_members
  for select using (
    exists (select 1 from public.card_groups g where g.id = group_id and g.user_id = auth.uid())
  );

drop policy if exists "card_group_members_insert_own" on public.card_group_members;
create policy "card_group_members_insert_own" on public.card_group_members
  for insert with check (
    exists (select 1 from public.card_groups g where g.id = group_id and g.user_id = auth.uid())
    and exists (select 1 from public.scanned_cards c where c.id = card_id and c.user_id = auth.uid())
  );

drop policy if exists "card_group_members_delete_own" on public.card_group_members;
create policy "card_group_members_delete_own" on public.card_group_members
  for delete using (
    exists (select 1 from public.card_groups g where g.id = group_id and g.user_id = auth.uid())
  );

-- =========================================================================
-- card_notes (not / ziyaret kayıtları)
-- =========================================================================
create table if not exists public.card_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  card_id uuid not null references public.scanned_cards (id) on delete cascade,
  content text not null,
  note_type text not null default 'note' check (note_type in ('note', 'visit_log')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists card_notes_card_id_idx on public.card_notes (card_id);
create index if not exists card_notes_user_id_idx on public.card_notes (user_id);

alter table public.card_notes enable row level security;

drop policy if exists "card_notes_select_own" on public.card_notes;
create policy "card_notes_select_own" on public.card_notes
  for select using (auth.uid() = user_id);

drop policy if exists "card_notes_insert_own" on public.card_notes;
create policy "card_notes_insert_own" on public.card_notes
  for insert with check (auth.uid() = user_id);

drop policy if exists "card_notes_update_own" on public.card_notes;
create policy "card_notes_update_own" on public.card_notes
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "card_notes_delete_own" on public.card_notes;
create policy "card_notes_delete_own" on public.card_notes
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.card_notes;
create trigger set_updated_at before update on public.card_notes
  for each row execute function public.set_updated_at();

-- =========================================================================
-- card_reminders (hatırlatıcılar)
-- =========================================================================
create table if not exists public.card_reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  card_id uuid not null references public.scanned_cards (id) on delete cascade,
  remind_at timestamptz not null,
  message text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists card_reminders_card_id_idx on public.card_reminders (card_id);
create index if not exists card_reminders_remind_at_idx on public.card_reminders (remind_at);

alter table public.card_reminders enable row level security;

drop policy if exists "card_reminders_select_own" on public.card_reminders;
create policy "card_reminders_select_own" on public.card_reminders
  for select using (auth.uid() = user_id);

drop policy if exists "card_reminders_insert_own" on public.card_reminders;
create policy "card_reminders_insert_own" on public.card_reminders
  for insert with check (auth.uid() = user_id);

drop policy if exists "card_reminders_update_own" on public.card_reminders;
create policy "card_reminders_update_own" on public.card_reminders
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "card_reminders_delete_own" on public.card_reminders;
create policy "card_reminders_delete_own" on public.card_reminders
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.card_reminders;
create trigger set_updated_at before update on public.card_reminders
  for each row execute function public.set_updated_at();

-- =========================================================================
-- notifications (uygulama içi bildirimler)
-- =========================================================================
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists notifications_user_id_idx on public.notifications (user_id);
create index if not exists notifications_is_read_idx on public.notifications (is_read);

alter table public.notifications enable row level security;

drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own" on public.notifications
  for select using (auth.uid() = user_id);

drop policy if exists "notifications_insert_own" on public.notifications;
create policy "notifications_insert_own" on public.notifications
  for insert with check (auth.uid() = user_id);

drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own" on public.notifications
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "notifications_delete_own" on public.notifications;
create policy "notifications_delete_own" on public.notifications
  for delete using (auth.uid() = user_id);

drop trigger if exists set_updated_at on public.notifications;
create trigger set_updated_at before update on public.notifications
  for each row execute function public.set_updated_at();

-- =========================================================================
-- auth.users -> profiles + user_settings otomatik oluşturma
-- =========================================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, language)
  values (new.id, new.raw_user_meta_data ->> 'full_name', 'tr')
  on conflict (id) do nothing;

  insert into public.user_settings (user_id, language)
  values (new.id, 'tr')
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =========================================================================
-- Storage: card-images, avatars
-- Bucket'lar public: dijital kart paylaşımı ve QR ile görüntüleme
-- kimliksiz erişim gerektirir. Yazma (insert/update/delete) yalnızca
-- {user_id}/... klasörünün sahibine açıktır.
-- =========================================================================
insert into storage.buckets (id, name, public)
values ('card-images', 'card-images', true)
on conflict (id) do update set public = excluded.public;

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "card_images_select_own" on storage.objects;
create policy "card_images_select_own" on storage.objects
  for select to authenticated
  using (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "card_images_insert_own" on storage.objects;
create policy "card_images_insert_own" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "card_images_update_own" on storage.objects;
create policy "card_images_update_own" on storage.objects
  for update to authenticated
  using (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "card_images_delete_own" on storage.objects;
create policy "card_images_delete_own" on storage.objects
  for delete to authenticated
  using (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "avatars_select_own" on storage.objects;
create policy "avatars_select_own" on storage.objects
  for select to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "avatars_insert_own" on storage.objects;
create policy "avatars_insert_own" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "avatars_update_own" on storage.objects;
create policy "avatars_update_own" on storage.objects
  for update to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "avatars_delete_own" on storage.objects;
create policy "avatars_delete_own" on storage.objects
  for delete to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
