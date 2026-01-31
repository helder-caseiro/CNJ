import { Button } from "@/components/ui/button";

const rows = [
  {
    unidade: "0001",
    tribunal: "TRF-1",
    segmento: "Justiça Federal",
    contato: "contato@trf1.jus.br"
  },
  {
    unidade: "0234",
    tribunal: "TRT-2",
    segmento: "Trabalho",
    contato: "gestao@trt2.jus.br"
  }
];

export default function DashboardPage() {
  return (
    <main className="min-h-screen bg-slate-50 px-6 py-10">
      <section className="mx-auto flex w-full max-w-6xl flex-col gap-6">
        <header className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <h2 className="text-2xl font-semibold text-slate-900">Dashboard</h2>
            <p className="text-sm text-slate-600">
              Filtros persistidos via URL, busca server-side e paginação.
            </p>
          </div>
          <div className="flex flex-wrap gap-3">
            <Button variant="secondary">Importar CSV</Button>
            <Button>Nova unidade</Button>
          </div>
        </header>

        <div className="flex flex-wrap gap-3 rounded-xl bg-white p-4 shadow-sm">
          <input
            className="flex-1 rounded-md border border-slate-200 px-3 py-2 text-sm"
            placeholder="Buscar por unidade, tribunal ou contato"
            type="search"
          />
          <select className="rounded-md border border-slate-200 px-3 py-2 text-sm">
            <option>Todos os segmentos</option>
            <option>Justiça Federal</option>
            <option>Trabalho</option>
            <option>Eleitoral</option>
            <option>Estadual</option>
          </select>
          <Button variant="ghost">Aplicar filtros</Button>
        </div>

        <div className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-xs uppercase text-slate-500">
              <tr>
                <th className="px-4 py-3">Unidade</th>
                <th className="px-4 py-3">Tribunal</th>
                <th className="px-4 py-3">Segmento</th>
                <th className="px-4 py-3">Contato efetivo</th>
                <th className="px-4 py-3 text-right">Ações</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.unidade} className="border-t border-slate-100">
                  <td className="px-4 py-3 font-medium text-slate-900">{row.unidade}</td>
                  <td className="px-4 py-3 text-slate-600">{row.tribunal}</td>
                  <td className="px-4 py-3 text-slate-600">{row.segmento}</td>
                  <td className="px-4 py-3 text-slate-600">{row.contato}</td>
                  <td className="px-4 py-3 text-right">
                    <Button variant="ghost">Ver detalhes</Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <footer className="flex items-center justify-between text-sm text-slate-500">
          <span>Mostrando 1-2 de 48 resultados</span>
          <div className="flex gap-2">
            <Button variant="secondary">Anterior</Button>
            <Button variant="secondary">Próximo</Button>
          </div>
        </footer>
      </section>
    </main>
  );
}
