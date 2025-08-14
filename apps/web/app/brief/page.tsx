export default async function BriefPage(){
  const resInv = await fetch(process.env.NEXT_PUBLIC_API+"/inventory",{cache:"no-store"});
  const resTh = await fetch(process.env.NEXT_PUBLIC_API+"/themes",{cache:"no-store"});
  const inv = await resInv.json(); const themes = await resTh.json();
  return (
    <main className="p-6 print:p-0">
      <h1 className="text-xl mb-2">Pre‑Shift Brief</h1>
      <section className="grid md:grid-cols-2 gap-4">
        <div className="border rounded-2xl p-4">
          <h2 className="font-semibold mb-2">86 & Low Stock</h2>
          <ul>{inv.map((it:any)=> <li key={it.item_id}>{it.status.toUpperCase()}; <b>{it.name}</b> {it.expected_back?`; back ${'{'}it.expected_back{'}'}`:``} {it.notes?`; ${'{'}it.notes{'}'}`:``}</li>)}</ul>
        </div>
        <div className="border rounded-2xl p-4">
          <h2 className="font-semibold mb-2">Review Themes; 7 days</h2>
          <ul>{themes.map((t:any)=> <li key={t.name}><b>{t.name}</b>; {t.count} mentions</li>)}</ul>
        </div>
      </section>
      <button className="mt-4 rounded-2xl border px-3 py-2" onClick={()=>window.print()}>Print</button>
    </main>
  )
}