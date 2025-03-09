import { inject, injectable } from "tsyringe";
import type { SaleItemRepository } from "../../domain/repositories/sale_item_repository.js";
import type {
  SaleItem,
  SaleItemRequest,
} from "../../domain/models/sale_list_model.js";
import type { SaleItemUpsertRequest } from "../../domain/models/sale_item_model.js";

@injectable()
export class UpsertSaleItemUseCase {
  constructor(
    @inject("SaleItemRepositoryImpl")
    private readonly saleItemRepository: SaleItemRepository
  ) {}

  async execute(saleItemRequest: SaleItemUpsertRequest): Promise<SaleItem> {
    const upsertedSaleItem = await this.saleItemRepository.upsertSaleItem(
      saleItemRequest
    );
    return upsertedSaleItem;
  }
}
