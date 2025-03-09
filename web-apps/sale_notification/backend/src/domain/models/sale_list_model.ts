export type SaleItem = {
  id: number;
  name: string;
  item_category: string;
  start_at: Date;
  end_at: Date;
};

export type SaleItemRequest = Omit<SaleItem, "id" | "item_category"> & {
  item_category_id: number;
  user_id: number;
};
