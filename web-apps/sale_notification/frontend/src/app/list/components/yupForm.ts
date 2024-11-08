import * as yup from "yup";
import { FormModel, SaleStatus } from "./types";

export const formSchema: yup.ObjectSchema<FormModel> = yup.object().shape({
  saleName: yup
    .string()
    .label("セール名")
    .max(5, "${label}は${max}文字以内で入力してください。"),
  saleStatus: yup.string().oneOf(SaleStatus.concat([])),
  startDate: yup.string().label("開始日"),
});

export type Form = yup.InferType<typeof formSchema>;
