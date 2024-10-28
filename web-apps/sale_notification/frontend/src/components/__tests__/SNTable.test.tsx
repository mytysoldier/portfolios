import React from "react";
import { render, screen } from "@testing-library/react";
import { Sales, SNTable } from "../SNTable";

// テストデータ
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
];

describe("SNTableコンポーネントのテスト", () => {
  beforeEach(() => {
    render(<SNTable data={testData} />);
  });

  test("ヘッダーが正しく描画されること", () => {
    expect(screen.getByText("ID")).toBeInTheDocument();
    expect(screen.getByText("Sale Name")).toBeInTheDocument();
    expect(screen.getByText("Item Category")).toBeInTheDocument();
    expect(screen.getByText("Status")).toBeInTheDocument();
    expect(screen.getByText("Start Date")).toBeInTheDocument();
    expect(screen.getByText("End Date")).toBeInTheDocument();
  });

  test("データが正しく描画されること", () => {
    expect(screen.getByText("1")).toBeInTheDocument();
    expect(screen.getByText("Summer Sale")).toBeInTheDocument();
    expect(screen.getByText("Clothing")).toBeInTheDocument();
    expect(screen.getByText("Active")).toBeInTheDocument();
    expect(screen.getByText("2024/06/01")).toBeInTheDocument();
    expect(screen.getByText("2024/06/30")).toBeInTheDocument();

    expect(screen.getByText("2")).toBeInTheDocument();
    expect(screen.getByText("Winter Clearance")).toBeInTheDocument();
    expect(screen.getByText("Footwear")).toBeInTheDocument();
    expect(screen.getByText("Completed")).toBeInTheDocument();
    expect(screen.getByText("2024/12/01")).toBeInTheDocument();
    expect(screen.getByText("2024/12/31")).toBeInTheDocument();
  });
});
