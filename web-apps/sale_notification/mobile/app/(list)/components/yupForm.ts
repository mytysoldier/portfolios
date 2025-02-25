import * as yup from "yup";
import { FormModel, SaleItemCategory, SaleStatus } from "./types";

export const formSchema: yup.ObjectSchema<FormModel> = yup.object().shape({
  saleName: yup
    .string()
    .label("セール名")
    .max(5, "${label}は${max}文字以内で入力してください。"),
  saleStatus: yup.string().oneOf(SaleStatus.concat([])),
  saleItemCategory: yup.string().label("商品カテゴリ"),
  startDate: yup.date().label("開始日"),
  endDate: yup.date().label("終了日"),
});

export type Form = yup.InferType<typeof formSchema>;
