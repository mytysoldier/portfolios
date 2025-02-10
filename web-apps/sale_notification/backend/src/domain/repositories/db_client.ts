import type { PostgresJsDatabase } from "drizzle-orm/postgres-js";
import type { SaleItem } from "../models/sale_list_model.js";

export interface DbClient {
  getDb(): PostgresJsDatabase;
}
