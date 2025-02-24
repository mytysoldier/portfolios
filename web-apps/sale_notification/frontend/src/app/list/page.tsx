"use client";

import { Sales, SNTable } from "@/components/SNTable";
import { SaleListForm } from "./components/SaleListForm";
import { useEffect, useState } from "react";
import { getSaleList } from "./actions/actions";

// const testData: Sales[] = [
//   {
//     id: 1,
//     saleName: "Summer Sale",
//     itemCategory: "Clothing",
//     status: "Active",
//     startAt: new Date("2024-06-01"),
//     endAt: new Date("2024-06-30"),
//   },
//   {
//     id: 2,
//     saleName: "Winter Clearance",
//     itemCategory: "Footwear",
//     status: "Completed",
//     startAt: new Date("2024-12-01"),
//     endAt: new Date("2024-12-31"),
//   },
//   {
//     id: 3,
//     saleName: "Back to School",
//     itemCategory: "Stationery",
//     status: "Active",
//     startAt: new Date("2024-08-01"),
//     endAt: new Date("2024-08-31"),
//   },
// ];

export default function Home() {
  const [saleItems, setSaleItems] = useState<Sales[]>([]);

  useEffect(() => {
    (async () => {
      const result = await getSaleList();
      const saleList: Sales[] = result.map((item) => {
        let status = "";
        const now = new Date();
        const startAt = new Date(item.start_at);
        const endAt = new Date(item.end_at);
        console.log(`now : ${now}`);
        console.log(`startAt : ${startAt}`);
        console.log(`endAt : ${endAt}`);
        if (startAt > now) {
          status = "未開始";
        } else if (endAt < now) {
          status = "終了";
        } else {
          status = "開催中";
        }

        return {
          id: item.id,
          saleName: item.name,
          itemCategory: item.item_category,
          status,
          startAt: item.start_at,
          endAt: item.end_at,
        };
      });
      setSaleItems(saleList);
      console.log(JSON.stringify(saleItems));
    })();
  }, []);

  useEffect(() => {
    console.log(JSON.stringify(saleItems));
  }, [saleItems]);

  return (
    <div>
      <div>
        <SaleListForm />
      </div>
      {/* <SNTable data={testData} /> */}
      <SNTable data={saleItems} />
    </div>
  );
}
