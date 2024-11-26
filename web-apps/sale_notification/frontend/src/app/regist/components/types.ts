export type FormModel = {
  saleName?: string;
  itemCategory?: (typeof ItemCategory)[number];
  startDate?: string;
  endDate?: string;
};

export const ItemCategory = [
  "homeAppliances",
  "sportsOutdoors",
  "digitalEquipment",
  "books",
  "dailyNecessities",
  "kitchenItems",
  "foodBeverageAlcohol",
  "cosmeticsAndBeautySupplies",
];
