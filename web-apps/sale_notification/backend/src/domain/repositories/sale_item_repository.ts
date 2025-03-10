import type { SaleItemUpsertRequest } from "../models/sale_item_model.js";
import type { SaleItem, SaleItemRequest } from "../models/sale_list_model.js";

export interface SaleItemRepository {
  createSaleItem(saleItemRequest: SaleItemRequest): Promise<SaleItem>;
  upsertSaleItem(saleItemRequest: SaleItemUpsertRequest): Promise<SaleItem>;
  deleteSaleItem(saleItemId: number): Promise<void>;
}
