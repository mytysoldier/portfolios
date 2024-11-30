"use client";
// import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";
import { Header } from "@/components/Header";
import "../i18n/configs";
import { useTranslation } from "react-i18next";
import { Button, ButtonType } from "@/components/Button";
import { useRouter, useSelectedLayoutSegment } from "next/navigation";
import React, { useEffect } from "react";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

// export const metadata: Metadata = {
//   title: "Create Next App",
//   description: "Generated by create next app",
// };

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const { t } = useTranslation();
  const segment = useSelectedLayoutSegment();

  useEffect(() => {
    console.log("segment", segment);
  });

  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased p-16`}
      >
        {segment === null || segment === "list" ? (
          <ListLayout>{children}</ListLayout>
        ) : (
          <SimpleLayout
            title={
              segment === "regist"
                ? t("header.title.regist")
                : t("header.title.detail")
            }
          >
            {children}
          </SimpleLayout>
        )}
        {/* <div className="flex items-center justify-center">
          <div>
            <Header title={t("header.title.list")} />
          </div>
          <div className="absolute right-0 pr-16">
            <Button
              title={t("form.button.addSale")}
              buttonType={ButtonType.TEXT}
              onClick={() => {
                router.push("/regist");
              }}
            />
          </div>
        </div>
        {children} */}
      </body>
    </html>
  );
}

function ListLayout({ children }: { children: React.ReactNode }) {
  const { t } = useTranslation();
  const router = useRouter();

  return (
    <div>
      <div className="flex items-center justify-center">
        <div>
          <Header title={t("header.title.list")} />
        </div>
        <div className="absolute right-0 pr-16">
          <Button
            title={t("form.button.addSale")}
            buttonType={ButtonType.TEXT}
            onClick={() => {
              router.push("/regist");
            }}
          />
        </div>
      </div>
      {children}
    </div>
  );
}

function SimpleLayout({
  children,
  title,
}: {
  children: React.ReactNode;
  title: string;
}) {
  return (
    <div>
      <div className="flex items-center justify-center">
        <div>
          <Header title={title} />
        </div>
      </div>
      {children}
    </div>
  );
}
