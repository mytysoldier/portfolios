import "reflect-metadata";
import type { SaleItem } from "../../domain/models/sale_list_model.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { inject, injectable } from "tsyringe";
import type { DbClient } from "../../domain/repositories/db_client.js";
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "../../db/schema.js";
import { and, eq, gt, like, lt } from "drizzle-orm";

type SaleItemType = typeof schema.saleItem.$inferSelect;
type ItemCategoryType = typeof schema.itemCategory.$inferSelect;

@injectable()
export class SaleListRepositoryImpl implements SaleListRepository {
  constructor(
    @inject("DbClientImpl")
    private readonly dbClient: DbClient
  ) {}

  async findById(id: number): Promise<SaleItem | null> {
    const result = await this.dbClient
      .getDb()
      .select()
      .from(schema.saleItem)
      .innerJoin(
        schema.itemCategory,
        eq(schema.saleItem.item_category_id, schema.itemCategory.id)
      )
      .where(eq(schema.saleItem.id, id));

    if (result.length === 0) {
      return null;
    }

    const saleItem: SaleItem = {
      id: result[0].sale_item.id,
      name: result[0].sale_item.name,
      item_category: result[0].item_category.name,
      start_at: new Date(result[0].sale_item.start_at),
      end_at: new Date(result[0].sale_item.end_at),
    };
    console.log(`saleItem: ${JSON.stringify(saleItem)}`);

    return saleItem;
  }

  async findAll(): Promise<SaleItem[]> {
    const results = await this.dbClient
      .getDb()
      .select({
        saleItem: schema.saleItem,
        itemCategory: schema.itemCategory,
      })
      .from(schema.saleItem)
      .innerJoin(
        schema.itemCategory,
        eq(schema.saleItem.item_category_id, schema.itemCategory.id)
      );
    const saleItems: SaleItem[] = results.map((item) => ({
      id: item.saleItem.id,
      name: item.saleItem.name,
      item_category: item.itemCategory.name,
      start_at: new Date(item.saleItem.start_at),
      end_at: new Date(item.saleItem.end_at),
    }));
    console.log(`saleItems: ${JSON.stringify(saleItems)}`);
    return saleItems;
  }

  async findByQuery(queries: Record<string, string[]>): Promise<SaleItem[]> {
    let sql = this.dbClient
      .getDb()
      .select({
        saleItem: schema.saleItem,
        itemCategory: schema.itemCategory,
      })
      .from(schema.saleItem)
      .innerJoin(
        schema.itemCategory,
        eq(schema.saleItem.item_category_id, schema.itemCategory.id)
      )
      .where(
        and(
          like(
            schema.saleItem.name,
            queries["name"] ? `%${queries["name"][0]}%` : "%%"
          ),
          gt(
            schema.saleItem.start_at,
            queries["start_at"] ? queries["start_at"][0] : "1970-01-01"
          ),
          lt(
            schema.saleItem.end_at,
            queries["end_at"] ? queries["end_at"][0] : "9999-12-31"
          )
        )
      );
    const results = await sql;
    const saleItems: SaleItem[] = results.map((item) => ({
      id: item.saleItem.id,
      name: item.saleItem.name,
      item_category: item.itemCategory.name,
      start_at: new Date(item.saleItem.start_at),
      end_at: new Date(item.saleItem.end_at),
    }));
    console.log(`saleItems: ${JSON.stringify(saleItems)}`);
    return saleItems;
  }
}
