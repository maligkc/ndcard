-- Taranan kartlara ayrı profil fotoğrafı alanı ekler.
-- Kartvizit fotoğrafından (front_image_url) bağımsız; kişi avatarı olarak kullanılır.
alter table scanned_cards
  add column if not exists profile_image_url text;
