import "reflect-metadata";
import type { SaleItem } from "../../domain/models/sale_list_model.js";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { inject, injectable } from "tsyringe";
import type { DbClient } from "../../domain/repositories/db_client.js";
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "../../db/schema.js";

@injectable()
export class SaleListRepositoryImpl implements SaleListRepository {
  constructor(
    @inject("DbClientImpl")
    private readonly dbClient: DbClient
  ) {}

  async findAll(): Promise<SaleItem[]> {
    const result = await this.dbClient.getDb().select().from(schema.saleItem);
    const saleItems: SaleItem[] = result.map((item) => ({
      id: item.id,
      name: item.name,
      start_at: new Date(item.start_at),
      end_at: new Date(item.end_at),
    }));
    console.log(`saleItems: ${JSON.stringify(saleItems)}`);
    return saleItems;
  }
}
