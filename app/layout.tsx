import "./globals.css";
import type { ReactNode } from "react";

export const metadata = {
  title: "CNJ Admin",
  description: "Admin SaaS for judicial segments"
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="pt-BR">
      <body className="min-h-screen antialiased">{children}</body>
    </html>
  );
}
