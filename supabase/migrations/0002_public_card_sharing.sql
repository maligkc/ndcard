-- NDCard — Faz 6: QR ile dijital kart paylaşımı için herkese açık okuma
-- Bir kullanıcı başka bir kullanıcının dijital kartını QR ile taradığında,
-- paylaşım linkindeki share_slug üzerinden o karta (ve alt tablolarına)
-- kimliksiz/başka-kullanıcı erişimiyle salt-okunur erişebilmesi gerekir.
-- Bu dosya 0001_init.sql'den SONRA çalıştırılmalıdır. İdempotenttir.

drop policy if exists "digital_cards_select_by_share_slug" on public.digital_cards;
create policy "digital_cards_select_by_share_slug" on public.digital_cards
  for select using (share_slug is not null);

drop policy if exists "digital_card_experiences_select_shared" on public.digital_card_experiences;
create policy "digital_card_experiences_select_shared" on public.digital_card_experiences
  for select using (
    exists (
      select 1 from public.digital_cards c
      where c.id = card_id and c.share_slug is not null
    )
  );

drop policy if exists "digital_card_extras_select_shared" on public.digital_card_extras;
create policy "digital_card_extras_select_shared" on public.digital_card_extras
  for select using (
    exists (
      select 1 from public.digital_cards c
      where c.id = card_id and c.share_slug is not null
    )
  );

drop policy if exists "digital_card_fields_select_shared" on public.digital_card_fields;
create policy "digital_card_fields_select_shared" on public.digital_card_fields
  for select using (
    exists (
      select 1 from public.digital_cards c
      where c.id = card_id and c.share_slug is not null
    )
  );
