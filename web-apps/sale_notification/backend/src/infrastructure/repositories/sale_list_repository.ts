import type { SaleItem } from "../../domain/models/sale_list_model.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";

export class SaleListRepositoryImpl implements SaleListRepository {
  async findAll(): Promise<SaleItem> {
    return {
      id: 1,
      name: "Test Sale Item",
      start_at: new Date(),
      end_at: new Date(),
    };
  }
}
