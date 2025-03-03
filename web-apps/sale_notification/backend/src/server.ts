import { serve } from "@hono/node-server";
import { Hono } from "hono";
import {
  getSaleDetailHandler,
  getSaleListHandler,
} from "./presentation/handlers/sale_list_handler.js";
import { tsyringe } from "@hono/tsyringe";
import { GetSaleListUseCase } from "./usecases/getSaleList/interactor.js";
import { container } from "tsyringe";
import { SaleListRepositoryImpl } from "./infrastructure/repositories/sale_list_repository.js";
import { DbClientImpl } from "./infrastructure/persistence/db_client.js";
import { GetSaleDetailUseCase } from "./usecases/getSaleDetail/interactor.js";
import { cors } from "hono/cors";

export function startServer() {
  const app = new Hono();

  container.register("DbClientImpl", {
    useClass: DbClientImpl,
  });

  container.register("SaleListRepositoryImpl", {
    useClass: SaleListRepositoryImpl,
  });

  container.register("GetSaleListUseCase", {
    useClass: GetSaleListUseCase,
  });

  container.register("GetSaleDetailUseCase", {
    useClass: GetSaleDetailUseCase,
  });

  app.use("*", cors());

  app.get("/", (c) => {
    return c.text("Hello Hono!");
  });

  app.get("/test", (c) => {
    return c.text("Hello Test Hono!");
  });

  app.get("/saleList", getSaleListHandler);

  app.get("/saleDetail", getSaleDetailHandler);

  const port = 3001;
  console.log(`Server is running on http://localhost:${port}`);

  serve({
    fetch: app.fetch,
    port,
  });
}
