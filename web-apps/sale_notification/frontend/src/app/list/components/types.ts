export type FormModel = {
  saleName?: string;
  saleStatus?: (typeof SaleStatus)[number];
  startDate?: Date;
  endDate?: Date;
};

export const SaleStatus = ["todo", "doing", "done", ""];
