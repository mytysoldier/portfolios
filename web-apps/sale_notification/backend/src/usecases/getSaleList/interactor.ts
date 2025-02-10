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

  async execute() {
    const saleItems = await this.saleListRepository.findAll();
    return saleItems;
  }
}
