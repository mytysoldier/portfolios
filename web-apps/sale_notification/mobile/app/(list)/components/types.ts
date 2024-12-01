export type FormModel = {
  saleName?: string;
  saleStatus?: (typeof SaleStatus)[number];
  startDate?: string;
};

export const SaleStatus = ["todo", "doing", "done", ""];
