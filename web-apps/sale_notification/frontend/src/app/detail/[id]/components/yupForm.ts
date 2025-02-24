import * as yup from "yup";
import { FormModel, ItemCategory } from "./types";

export const formSchema: yup.ObjectSchema<FormModel> = yup.object().shape({
  saleName: yup
    .string()
    .label("セール名")
    .max(20, "${label}は${max}文字以内で入力してください。"),
  itemCategory: yup.string().oneOf(ItemCategory.concat([])),
  startDate: yup.date().label("開始日"),
  endDate: yup.date().label("終了日"),
});

export type Form = yup.InferType<typeof formSchema>;
