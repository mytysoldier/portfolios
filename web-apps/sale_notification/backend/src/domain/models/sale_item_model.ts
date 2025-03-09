import type { SaleItem } from "./sale_list_model.js";

export type SaleItemUpsertRequest = Omit<SaleItem, "id" | "item_category"> & {
  id?: number;
  item_category_id: number;
  user_id: number;
};
