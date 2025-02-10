import type { Context } from "hono";
import type { SaleListRepository } from "../../domain/repositories/sale_list_repository.js";
import { GetSaleListUseCase } from "../../usecases/getSaleList/interactor.js";
import { container } from "tsyringe";

// const getSaleListUseCase =
//     container.resolve<GetSaleListUseCase>("GetSaleListUseCase");

export const getSaleListHandler = async (c: Context) => {
  const getSaleListUseCase =
    container.resolve<GetSaleListUseCase>("GetSaleListUseCase");
  const saleItems = await getSaleListUseCase.execute();
  return c.json(saleItems);
};
