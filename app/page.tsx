import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 px-6 text-center">
      <div className="max-w-2xl space-y-4">
        <p className="text-sm font-semibold uppercase tracking-[0.3em] text-slate-500">
          Admin SaaS
        </p>
        <h1 className="text-4xl font-semibold text-slate-900 sm:text-5xl">
          Painel CNJ para gestão de tribunais e unidades de origem
        </h1>
        <p className="text-base text-slate-600">
          Estrutura inicial pronta para integração com Supabase, RLS e módulos de
          importação CSV.
        </p>
      </div>
      <div className="flex flex-wrap items-center justify-center gap-3">
        <Button asChild>
          <Link href="/dashboard">Acessar dashboard</Link>
        </Button>
        <Button asChild variant="secondary">
          <Link href="/docs">Ver especificações</Link>
        </Button>
      </div>
    </main>
  );
}
