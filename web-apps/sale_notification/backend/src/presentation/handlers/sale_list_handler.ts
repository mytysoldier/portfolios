import type { Context } from "hono";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { GetSaleListUseCase } from "../../usecases/getSaleList/interactor.js";
import { container } from "tsyringe";
import type { GetSaleDetailUseCase } from "../../usecases/getSaleDetail/interactor.js";
import { InvalidRequestError } from "../model/response/error.js";

// const getSaleListUseCase =
//     container.resolve<GetSaleListUseCase>("GetSaleListUseCase");

export const getSaleListHandler = async (c: Context) => {
  const a = c.req.queries();
  console.log(`queries: ${JSON.stringify(a)}`);
  if (Object.keys(a).length === 0) {
    console.log("no queries");
  }
  const getSaleListUseCase =
    container.resolve<GetSaleListUseCase>("GetSaleListUseCase");
  const saleItems = await getSaleListUseCase.execute(c.req.queries());
  return c.json(saleItems);
};

export const getSaleDetailHandler = async (c: Context) => {
  const id = c.req.query("id");
  if (!id || isNaN(Number(id))) {
    c.status(400);
    return c.json(new InvalidRequestError());
  }
  const getSaleDetailUseCase = container.resolve<GetSaleDetailUseCase>(
    "GetSaleDetailUseCase"
  );
  const saleItem = await getSaleDetailUseCase.execute(Number(id));
  return c.json(saleItem);
};
