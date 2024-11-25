"use client";
import { useEffect } from "react";
import { SaleDetailForm } from "./components/SaleDetailForm";

export default function Detail({ params }: { params: { id: string } }) {
  useEffect(() => {
    console.log("詳細画面ID:", params.id);
  });
  return (
    <div>
      <div>
        <SaleDetailForm />
      </div>
    </div>
  );
}
