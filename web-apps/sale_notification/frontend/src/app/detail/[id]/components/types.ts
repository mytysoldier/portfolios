export type FormModel = {
  saleName?: string;
  itemCategory?: (typeof ItemCategory)[number];
  startDate?: Date;
  endDate?: Date;
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
