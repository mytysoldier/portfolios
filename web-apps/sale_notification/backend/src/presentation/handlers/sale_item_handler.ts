import type { Context } from "hono";
import type { SaleItemRequest } from "../../domain/models/sale_list_model.js";
import { InvalidRequestError } from "../model/response/error.js";
import { container } from "tsyringe";
import type { CreateSaleItemUseCase } from "../../usecases/createSaleItem/interactor.js";
import type { UpsertSaleItemUseCase } from "../../usecases/upsertSaleItem/interactor.js";
import type { SaleItemUpsertRequest } from "../../domain/models/sale_item_model.js";

export const createSaleItemHandler = async (c: Context) => {
  try {
    const request: SaleItemRequest = await c.req.json();
    console.log(`saleItem: ${JSON.stringify(request)}`);
    const createSaleItemUseCase = container.resolve<CreateSaleItemUseCase>(
      "CreateSaleItemUseCase"
    );
    const saleItem = await createSaleItemUseCase.execute(request);
    return c.json(saleItem);
  } catch (e) {
    console.error(e);
    c.status(400);
    return c.json(new InvalidRequestError());
  }
};

export const upsertSaleItemHandler = async (c: Context) => {
  try {
    const request: SaleItemUpsertRequest = await c.req.json();
    console.log(`saleItem: ${JSON.stringify(request)}`);
    const upsertSaleItemUseCase = container.resolve<UpsertSaleItemUseCase>(
      "UpsertSaleItemUseCase"
    );
    const saleItem = await upsertSaleItemUseCase.execute(request);
    return c.json(saleItem);
  } catch (e) {
    console.error(e);
    c.status(400);
    return c.json(new InvalidRequestError());
  }
};
