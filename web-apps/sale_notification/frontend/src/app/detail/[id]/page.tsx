"use client";
import { SaleDetailForm } from "./components/SaleDetailForm";

export default function Detail({ params }: { params: { id: string } }) {
  return (
    <div>
      <div>{params.id}</div>
      <div>
        <SaleDetailForm />
      </div>
    </div>
  );
}
