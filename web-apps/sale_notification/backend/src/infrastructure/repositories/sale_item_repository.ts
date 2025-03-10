import type {
  SaleItemRequest,
  SaleItem,
} from "../../domain/models/sale_list_model.js";
import type { DbClient } from "../../domain/repositories/db_client.js";
import type { SaleItemRepository } from "../../domain/repositories/sale_item_repository.js";
import { inject, injectable } from "tsyringe";
import * as schema from "../../db/schema.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import type { SaleItemUpsertRequest } from "../../domain/models/sale_item_model.js";
import { eq } from "drizzle-orm";

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

  async upsertSaleItem(
    saleItemRequest: SaleItemUpsertRequest
  ): Promise<SaleItem> {
    console.log(`saleItem: ${JSON.stringify(saleItemRequest)}`);
    // let upsertedItems;
    // if (saleItemRequest.id) {

    // } else
    const upsertedItems = await this.dbClient
      .getDb()
      .insert(schema.saleItem)
      .values({
        id: saleItemRequest.id,
        name: saleItemRequest.name,
        start_at: new Date(saleItemRequest.start_at).toDateString(),
        end_at: new Date(saleItemRequest.end_at).toDateString(),
        item_category_id: saleItemRequest.item_category_id,
        created_user_id: saleItemRequest.user_id,
      })
      .onConflictDoUpdate({
        target: schema.saleItem.id,
        set: {
          name: saleItemRequest.name,
          start_at: new Date(saleItemRequest.start_at).toDateString(),
          end_at: new Date(saleItemRequest.end_at).toDateString(),
          item_category_id: saleItemRequest.item_category_id,
        },
      })
      .returning();
    const upsertedItem = await this.saleListRepository.findById(
      upsertedItems[0].id
    );
    return upsertedItem!;
  }

  async deleteSaleItem(saleItemId: number): Promise<void> {
    console.log(`Delete saleItemId: ${saleItemId}`);
    await this.dbClient
      .getDb()
      .delete(schema.saleItem)
      .where(eq(schema.saleItem.id, saleItemId));
  }
}
