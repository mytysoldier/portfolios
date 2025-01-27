export type FormModel = {
  saleName?: string;
  saleStatus?: (typeof SaleStatus)[number];
  saleItemCategory?: (typeof SaleItemCategory)[number];
  startDate?: string;
};

export const SaleStatus = ["todo", "doing", "done", ""];
export const SaleItemCategory = [
  "digitalEquipment",
  "sportsOutdoors",
  "books",
  "dailyNecessities",
  "kitchenItems",
  "foodBeverageAlcohol",
  "cosmeticsAndBeautySupplies",
];
