-- =========================================================================
-- 0003_digital_card_soft_delete.sql
-- digital_cards tablosuna soft-delete desteği ekler.
-- =========================================================================

alter table public.digital_cards
  add column if not exists deleted_at timestamptz;

create index if not exists digital_cards_deleted_at_idx on public.digital_cards (deleted_at)
  where deleted_at is not null;
