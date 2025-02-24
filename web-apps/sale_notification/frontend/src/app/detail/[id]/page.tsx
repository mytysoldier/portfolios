"use client";
import { useEffect, useState } from "react";
import { SaleDetailForm } from "./components/SaleDetailForm";
import { getSaleDetail } from "./actions/actions";
import { Sales } from "@/components/SNTable";

export default function Detail({ params }: { params: { id: number } }) {
  const [saleItem, setSaleItem] = useState<Sales | null>(null);
  useEffect(() => {
    console.log("詳細画面ID:", params.id);
    (async () => {
      const result = await getSaleDetail(params.id);
      if (result != null) {
        const item: Sales = {
          id: result.id,
          saleName: result.name,
          itemCategory: result.item_category,
          // TODO statusの判定
          status: "",
          startAt: result.start_at,
          endAt: result.end_at,
        };
        setSaleItem(item);
        console.log(`detail item: ${JSON.stringify(item)}`);
      }
    })();
  }, []);

  useEffect(() => {
    console.log(`sale detail item: ${JSON.stringify(saleItem)}`);
  }, [saleItem]);

  return (
    <div>
      <div>{saleItem != null ? <SaleDetailForm item={saleItem} /> : null}</div>
    </div>
  );
}
