import type {
  SaleItemRequest,
  SaleItem,
} from "../../domain/models/sale_list_model.js";
import type { DbClient } from "../../domain/repositories/db_client.js";
import type { SaleItemRepository } from "../../domain/repositories/sale_item_repository.js";
import { inject, injectable } from "tsyringe";
import * as schema from "../../db/schema.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";

@injectable()
export class SaleItemRepositoryImpl implements SaleItemRepository {
  constructor(
    @inject("DbClientImpl")
    private readonly dbClient: DbClient,
    @inject("SaleListRepositoryImpl")
    private readonly saleListRepository: SaleListRepository
  ) {}

  async createSaleItem(saleItemRequest: SaleItemRequest): Promise<SaleItem> {
    console.log(`saleItem: ${JSON.stringify(saleItemRequest)}`);
    const insertedItems = await this.dbClient
      .getDb()
      .insert(schema.saleItem)
      .values({
        name: saleItemRequest.name,
        start_at: new Date(saleItemRequest.start_at).toDateString(),
        end_at: new Date(saleItemRequest.end_at).toDateString(),
        item_category_id: 1,
        created_user_id: saleItemRequest.user_id,
      })
      .returning();
    const insertedItem = await this.saleListRepository.findById(
      insertedItems[0].id
    );
    return insertedItem!;
  }
}
