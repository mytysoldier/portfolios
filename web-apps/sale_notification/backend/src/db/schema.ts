import { date, integer, pgTable, serial, varchar } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: serial().primaryKey(),
  name: varchar({ length: 255 }).notNull(),
  created_at: date().notNull().default("now()"),
  deleted_at: date(),
});

export const itemCategory = pgTable("item_category", {
  id: serial().primaryKey(),
  name: varchar({ length: 255 }).notNull(),
  created_at: date().notNull().default("now()"),
});

export const saleItem = pgTable("sale_item", {
  id: serial().primaryKey(),
  name: varchar({ length: 255 }).notNull(),
  start_at: date().notNull(),
  end_at: date().notNull(),
  item_category_id: integer()
    .notNull()
    .references(() => itemCategory.id),
  created_user_id: integer()
    .notNull()
    .references(() => users.id),
  created_at: date().notNull().default("now()"),
});
