import Link from "next/link";
import { Button } from "@/components/ui/button";

const items = [
  {
    title: "Modelos de dados e migrações",
    description:
      "Tabelas segmentadas com chaves compostas, view de fallback e políticas RLS para perfis."
  },
  {
    title: "Pipeline de carga",
    description:
      "Fluxo de staging com preview de validação, relatórios de erro e upsert por chave natural."
  },
  {
    title: "UX/UI",
    description:
      "Dashboard com filtros persistentes na URL, busca server-side e formulários modais."
  }
];

export default function DocsPage() {
  return (
    <main className="min-h-screen bg-white px-6 py-12">
      <section className="mx-auto flex w-full max-w-4xl flex-col gap-6">
        <header className="space-y-3">
          <p className="text-sm font-semibold uppercase tracking-[0.3em] text-slate-500">
            Especificações técnicas
          </p>
          <h1 className="text-3xl font-semibold text-slate-900">Visão geral do projeto</h1>
          <p className="text-base text-slate-600">
            Referência para desenvolvimento do app CNJ Admin com Supabase, Next.js e Tailwind.
          </p>
        </header>

        <div className="grid gap-4 md:grid-cols-3">
          {items.map((item) => (
            <article key={item.title} className="rounded-xl border border-slate-200 p-4">
              <h2 className="text-lg font-semibold text-slate-900">{item.title}</h2>
              <p className="mt-2 text-sm text-slate-600">{item.description}</p>
            </article>
          ))}
        </div>

        <div className="flex flex-wrap gap-3">
          <Button asChild>
            <Link href="/dashboard">Voltar ao dashboard</Link>
          </Button>
          <Button asChild variant="secondary">
            <Link href="/">Página inicial</Link>
          </Button>
        </div>
      </section>
    </main>
  );
}
