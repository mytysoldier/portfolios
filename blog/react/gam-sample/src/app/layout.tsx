import "./globals.css";
import Script from "next/script";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <Script async src="https://www.googletagservices.com/tag/js/gpt.js" />
      <body>{children}</body>
    </html>
  );
}
