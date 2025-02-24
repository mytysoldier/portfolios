import "reflect-metadata";
import { inject, injectable } from "tsyringe";
import type { SaleItem } from "../../domain/models/sale_list_model.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { tsyringe } from "@hono/tsyringe";

@injectable()
export class GetSaleDetailUseCase {
  constructor(
    @inject("SaleListRepositoryImpl")
    private readonly saleListRepository: SaleListRepository
  ) {}

  async execute(id: number) {
    const saleItem = await this.saleListRepository.findById(id);
    return saleItem;
  }
}
