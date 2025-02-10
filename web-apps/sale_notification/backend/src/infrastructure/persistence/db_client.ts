import "reflect-metadata";
import { drizzle, PostgresJsDatabase } from "drizzle-orm/postgres-js";
import { injectable } from "tsyringe";
import type { DbClient } from "../../domain/repositories/db_client.js";
import * as scheme from "../../db/schema.js";

@injectable()
export class DbClientImpl implements DbClient {
  private db: PostgresJsDatabase;

  constructor() {
    this.db = drizzle(process.env.DATABASE_URL!);
  }

  getDb() {
    return this.db;
  }
}
