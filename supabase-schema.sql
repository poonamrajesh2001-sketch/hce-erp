-- ============================================================
-- HCE TITAN — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- Students
create table if not exists hce_students (
  roll        text primary key,
  name        text not null,
  prog        text not null,
  yr          int  not null,
  sec         text not null,
  elective    text default '',
  s1          numeric default 0,
  s2          numeric default 0,
  avg         numeric default 0,
  fee         text default 'Paid',
  status      text default 'Active',
  updated_at  timestamptz default now()
);

-- Attendance Records
create table if not exists hce_att_records (
  id          text primary key,
  date        text not null,
  prog        text not null,
  yr          int  not null,
  sec         text not null,
  subject     text not null,
  slot        text not null,
  faculty     text not null,
  present     int  default 0,
  absent      int  default 0,
  leave_count int  default 0,
  total       int  default 0,
  pct         numeric default 0,
  data        jsonb default '[]',
  saved_at    timestamptz default now()
);

-- Sessional Marks
create table if not exists hce_sessional_marks (
  id           text primary key,
  prog         text not null,
  yr           int  not null,
  sec          text not null,
  subject      text not null,
  subject_code text not null,
  exam_type    text not null,
  max_marks    int  default 30,
  entries      jsonb default '[]',
  faculty      text not null,
  saved_at     timestamptz default now()
);

-- Assignment Marks (separate table for granularity)
create table if not exists hce_assignment_marks (
  id           text primary key,
  prog         text not null,
  yr           int  not null,
  sec          text not null,
  subject      text not null,
  subject_code text not null,
  assignment_no int default 1,
  max_marks    int  default 10,
  entries      jsonb default '[]',
  faculty      text not null,
  saved_at     timestamptz default now()
);

-- Enable Row Level Security (open for anon reads/writes — tighten in production)
alter table hce_students        enable row level security;
alter table hce_att_records     enable row level security;
alter table hce_sessional_marks enable row level security;
alter table hce_assignment_marks enable row level security;

-- Policies: allow all for anon key (single-institution internal tool)
create policy "allow all students"        on hce_students        for all using (true) with check (true);
create policy "allow all att_records"     on hce_att_records     for all using (true) with check (true);
create policy "allow all sessional_marks" on hce_sessional_marks for all using (true) with check (true);
create policy "allow all assignment_marks" on hce_assignment_marks for all using (true) with check (true);

-- Realtime
alter publication supabase_realtime add table hce_students;
alter publication supabase_realtime add table hce_att_records;
alter publication supabase_realtime add table hce_sessional_marks;
alter publication supabase_realtime add table hce_assignment_marks;
