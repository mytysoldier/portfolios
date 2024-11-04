"use client";

import { Button, ButtonType } from "@/components/Button";
import { CustomDatePicker } from "@/components/CustomDatePicker";
import { SelectBox } from "@/components/SelectBox";
import { Sales, SNTable } from "@/components/SNTable";
import { Text } from "@/components/Text";
import { TextArea } from "@/components/TextArea";
import { SaleListForm } from "./SaleListForm";

const testData: Sales[] = [
  {
    id: 1,
    saleName: "Summer Sale",
    itemCategory: "Clothing",
    status: "Active",
    startAt: new Date("2024-06-01"),
    endAt: new Date("2024-06-30"),
  },
  {
    id: 2,
    saleName: "Winter Clearance",
    itemCategory: "Footwear",
    status: "Completed",
    startAt: new Date("2024-12-01"),
    endAt: new Date("2024-12-31"),
  },
  {
    id: 3,
    saleName: "Back to School",
    itemCategory: "Stationery",
    status: "Active",
    startAt: new Date("2024-08-01"),
    endAt: new Date("2024-08-31"),
  },
];

export default function Home() {
  return (
    <div>
      <div>
        <SaleListForm />
      </div>
      <Button title="test" buttonType={ButtonType.TEXT} onClick={() => {}} />
      <Button title="test" buttonType={ButtonType.PRIMARY} onClick={() => {}} />
      <Text text="セール" />
      <TextArea value={""} onChange={() => {}} />
      <SelectBox
        options={[
          { label: "aaa", value: "aaa" },
          { label: "bbb", value: "bbb" },
        ]}
        value={""}
        onChange={() => {}}
      />
      <CustomDatePicker />
      <SNTable data={testData} />
    </div>
  );
}
