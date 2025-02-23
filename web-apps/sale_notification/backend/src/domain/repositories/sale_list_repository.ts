import type { SaleItem } from "../models/sale_list_model.js";

export interface SaleListRepository {
  findAll(): Promise<SaleItem[]>;
  findById(id: number): Promise<SaleItem | null>;
}
