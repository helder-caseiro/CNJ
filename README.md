# CNJ

Aplicação admin moderna construída com Next.js (App Router), TypeScript, Tailwind CSS e Supabase.

## Stack

- **Front-end:** Next.js + Tailwind + shadcn/ui (estrutura base de componentes).
- **Back-end:** Supabase (PostgreSQL, Auth e RLS).
- **Deploy:** Vercel (app) + Supabase (banco).

## Estrutura do projeto

```
app/                 # App Router
components/ui/       # Componentes base (estilo shadcn/ui)
lib/                 # Utilitários
supabase/migrations/ # Migrações SQL
```

## Migrações Supabase

A migração inicial está em `supabase/migrations/0001_init.sql` e inclui:

- Tabelas `SegmentoJudiciario`, `TribunalJudiciario`, `LocalJustica`, `UnidadeOrigem`.
- View `vw_UnidadeOrigem_ContatoEfetivo` com fallback via `COALESCE`.
- Tabela `PerfilUsuario` integrada ao `auth.users`.
- Políticas RLS: leitura para autenticados e escrita apenas para admins.

## Variáveis de ambiente

Crie um arquivo `.env.local` com:

```
NEXT_PUBLIC_SUPABASE_URL=...\
NEXT_PUBLIC_SUPABASE_ANON_KEY=...\
SUPABASE_SERVICE_ROLE_KEY=...
```

> Use a chave `SUPABASE_SERVICE_ROLE_KEY` somente em ambientes server-side.

## Desenvolvimento local

```bash
npm install
npm run dev
```

Se houver erro de permissão ao baixar dependências (`403 Forbidden`), verifique se o npm está
apontando para o registro público. O projeto já inclui um `.npmrc` para isso, então basta
repetir o `npm install`.

## Deploy

1. Crie o projeto no Supabase e aplique as migrações via `supabase db push`.
2. Configure as variáveis de ambiente na Vercel.
3. Faça o deploy da aplicação Next.js.

## Notas sobre RLS

Para cadastrar o primeiro usuário admin, utilize a `SUPABASE_SERVICE_ROLE_KEY` e insira o registro em `PerfilUsuario` via client server-side ou SQL.
