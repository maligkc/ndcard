-- card_reminders: hatırlatıcı bildirim kutusuna eklendi mi?
alter table public.card_reminders
  add column if not exists is_notified boolean not null default false;

create index if not exists card_reminders_notified_idx
  on public.card_reminders (user_id, is_notified, remind_at);
