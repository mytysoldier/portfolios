import type { SaleItem, SaleItemRequest } from "../models/sale_list_model.js";

export interface SaleItemRepository {
  createSaleItem(saleItemRequest: SaleItemRequest): Promise<SaleItem>;
}
