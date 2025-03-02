import "reflect-metadata";
import { inject, injectable } from "tsyringe";
import type { SaleItem } from "../../domain/models/sale_list_model.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { tsyringe } from "@hono/tsyringe";

@injectable()
export class GetSaleListUseCase {
  constructor(
    @inject("SaleListRepositoryImpl")
    private readonly saleListRepository: SaleListRepository
  ) {}

  async execute(queries: Record<string, string[]>): Promise<SaleItem[]> {
    if (Object.keys(queries).length === 0) {
      // 全件検索
      const saleItems = await this.saleListRepository.findAll();
      return saleItems;
    }

    // クエリによる検索
    const saleItems = await this.saleListRepository.findByQuery(queries);
    return saleItems;
  }
}
