create extension if not exists "pgcrypto";

create table if not exists "SegmentoJudiciario" (
  "CodigoJ" integer primary key,
  "Nome" text not null
);

insert into "SegmentoJudiciario" ("CodigoJ", "Nome") values
  (4, 'Justiça Federal'),
  (5, 'Trabalho'),
  (6, 'Eleitoral'),
  (8, 'Estadual')
on conflict ("CodigoJ") do nothing;

create table if not exists "TribunalJudiciario" (
  "CodigoJ" integer not null,
  "CodigoTR" integer not null,
  "Nome" text not null,
  "Sigla" text,
  "EmailContato" text,
  "TelefoneContato" text,
  "UrlSite" text,
  "UrlPortalServicos" text,
  "CreatedAt" timestamptz not null default now(),
  "UpdatedAt" timestamptz not null default now(),
  primary key ("CodigoJ", "CodigoTR"),
  constraint "TribunalJudiciario_Segmento_fk" foreign key ("CodigoJ")
    references "SegmentoJudiciario" ("CodigoJ")
    on update cascade on delete restrict,
  constraint "TribunalJudiciario_UrlSite_https" check ("UrlSite" is null or "UrlSite" like 'https://%'),
  constraint "TribunalJudiciario_UrlPortal_https" check ("UrlPortalServicos" is null or "UrlPortalServicos" like 'https://%')
);

create table if not exists "LocalJustica" (
  "Id" uuid primary key default gen_random_uuid(),
  "CodigoJ" integer not null,
  "CodigoTR" integer not null,
  "Nome" text not null,
  "Endereco" text,
  "Bairro" text,
  "Cidade" text,
  "UF" text,
  "CEP" text,
  "EmailContato" text,
  "TelefoneContato" text,
  "UrlSite" text,
  "CreatedAt" timestamptz not null default now(),
  "UpdatedAt" timestamptz not null default now(),
  constraint "LocalJustica_Tribunal_fk" foreign key ("CodigoJ", "CodigoTR")
    references "TribunalJudiciario" ("CodigoJ", "CodigoTR")
    on update cascade on delete restrict,
  constraint "LocalJustica_UF" check ("UF" is null or "UF" ~ '^[A-Z]{2}$'),
  constraint "LocalJustica_UrlSite_https" check ("UrlSite" is null or "UrlSite" like 'https://%')
);

create table if not exists "UnidadeOrigem" (
  "CodigoJ" integer not null,
  "CodigoTR" integer not null,
  "Codigo0000" integer not null,
  "LocalJusticaId" uuid,
  "Nome" text not null,
  "EmailContatoOverride" text,
  "TelefoneContatoOverride" text,
  "UrlSiteOverride" text,
  "CreatedAt" timestamptz not null default now(),
  "UpdatedAt" timestamptz not null default now(),
  primary key ("CodigoJ", "CodigoTR", "Codigo0000"),
  constraint "UnidadeOrigem_Tribunal_fk" foreign key ("CodigoJ", "CodigoTR")
    references "TribunalJudiciario" ("CodigoJ", "CodigoTR")
    on update cascade on delete restrict,
  constraint "UnidadeOrigem_LocalJustica_fk" foreign key ("LocalJusticaId")
    references "LocalJustica" ("Id")
    on update cascade on delete set null,
  constraint "UnidadeOrigem_Codigo0000_range" check ("Codigo0000" between 0 and 9999),
  constraint "UnidadeOrigem_UrlSite_https" check ("UrlSiteOverride" is null or "UrlSiteOverride" like 'https://%')
);

create or replace view "vw_UnidadeOrigem_ContatoEfetivo" as
select
  u."CodigoJ",
  u."CodigoTR",
  u."Codigo0000",
  u."Nome" as "NomeUnidade",
  t."Nome" as "NomeTribunal",
  l."Nome" as "NomeLocalJustica",
  coalesce(u."EmailContatoOverride", l."EmailContato", t."EmailContato") as "EmailContatoEfetivo",
  coalesce(u."TelefoneContatoOverride", l."TelefoneContato", t."TelefoneContato") as "TelefoneContatoEfetivo",
  coalesce(u."UrlSiteOverride", l."UrlSite", t."UrlSite") as "UrlSiteEfetivo",
  l."Endereco",
  l."Cidade",
  l."UF",
  l."CEP"
from "UnidadeOrigem" u
left join "LocalJustica" l on u."LocalJusticaId" = l."Id"
join "TribunalJudiciario" t on u."CodigoJ" = t."CodigoJ" and u."CodigoTR" = t."CodigoTR";

create table if not exists "PerfilUsuario" (
  "UsuarioId" uuid primary key references auth.users (id) on delete cascade,
  "Role" text not null,
  "CreatedAt" timestamptz not null default now(),
  constraint "PerfilUsuario_Role" check ("Role" in ('admin', 'comum'))
);

create or replace function "is_admin"()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from "PerfilUsuario" pu
    where pu."UsuarioId" = auth.uid()
      and pu."Role" = 'admin'
  );
$$;

alter table "SegmentoJudiciario" enable row level security;
alter table "TribunalJudiciario" enable row level security;
alter table "LocalJustica" enable row level security;
alter table "UnidadeOrigem" enable row level security;
alter table "PerfilUsuario" enable row level security;

create policy "SegmentoJudiciario_read" on "SegmentoJudiciario"
  for select using (auth.uid() is not null);
create policy "SegmentoJudiciario_insert" on "SegmentoJudiciario"
  for insert with check ("is_admin"());
create policy "SegmentoJudiciario_update" on "SegmentoJudiciario"
  for update using ("is_admin"()) with check ("is_admin"());
create policy "SegmentoJudiciario_delete" on "SegmentoJudiciario"
  for delete using ("is_admin"());

create policy "TribunalJudiciario_read" on "TribunalJudiciario"
  for select using (auth.uid() is not null);
create policy "TribunalJudiciario_insert" on "TribunalJudiciario"
  for insert with check ("is_admin"());
create policy "TribunalJudiciario_update" on "TribunalJudiciario"
  for update using ("is_admin"()) with check ("is_admin"());
create policy "TribunalJudiciario_delete" on "TribunalJudiciario"
  for delete using ("is_admin"());

create policy "LocalJustica_read" on "LocalJustica"
  for select using (auth.uid() is not null);
create policy "LocalJustica_insert" on "LocalJustica"
  for insert with check ("is_admin"());
create policy "LocalJustica_update" on "LocalJustica"
  for update using ("is_admin"()) with check ("is_admin"());
create policy "LocalJustica_delete" on "LocalJustica"
  for delete using ("is_admin"());

create policy "UnidadeOrigem_read" on "UnidadeOrigem"
  for select using (auth.uid() is not null);
create policy "UnidadeOrigem_insert" on "UnidadeOrigem"
  for insert with check ("is_admin"());
create policy "UnidadeOrigem_update" on "UnidadeOrigem"
  for update using ("is_admin"()) with check ("is_admin"());
create policy "UnidadeOrigem_delete" on "UnidadeOrigem"
  for delete using ("is_admin"());

create policy "PerfilUsuario_read" on "PerfilUsuario"
  for select using (auth.uid() is not null);
create policy "PerfilUsuario_insert" on "PerfilUsuario"
  for insert with check ("is_admin"());
create policy "PerfilUsuario_update" on "PerfilUsuario"
  for update using ("is_admin"()) with check ("is_admin"());
create policy "PerfilUsuario_delete" on "PerfilUsuario"
  for delete using ("is_admin"());
