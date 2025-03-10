import { inject, injectable } from "tsyringe";
import type { SaleItemRepository } from "../../domain/repositories/sale_item_repository.js";
import type { SaleItem } from "../../domain/models/sale_list_model.js";

@injectable()
export class DeleteSaleItemUseCase {
  constructor(
    @inject("SaleItemRepositoryImpl")
    private readonly saleItemRepository: SaleItemRepository
  ) {}

  async execute(saleItemId: number): Promise<void> {
    await this.saleItemRepository.deleteSaleItem(saleItemId);
  }
}
