import type {
  SaleItem,
  SaleItemRequest,
} from "../../domain/models/sale_list_model.js";
import { inject, injectable } from "tsyringe";
import type { SaleItemRepository } from "../../domain/repositories/sale_item_repository.js";

@injectable()
export class CreateSaleItemUseCase {
  constructor(
    @inject("SaleItemRepositoryImpl")
    private readonly saleItemRepository: SaleItemRepository
  ) {}

  async execute(saleItemRequest: SaleItemRequest): Promise<SaleItem> {
    const newSaleItem = await this.saleItemRepository.createSaleItem(
      saleItemRequest
    );
    return newSaleItem;
  }
}
