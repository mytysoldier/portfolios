import { yupResolver } from "@hookform/resolvers/yup";
import { FieldErrors, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import * as yup from "yup";

const schema = yup.object({
  saleName: yup
    .string()
    .label("セール名")
    .max(5, "${label}は${max}文字以内で入力してください。"),
});

type SaleListFormType = {
  saleName?: string;
};

export const SaleListForm = () => {
  const { t } = useTranslation();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm({
    defaultValues: {
      saleName: "",
    },
    resolver: yupResolver(schema),
  });

  const onsubmit = (data: SaleListFormType) =>
    console.log(JSON.stringify(data));
  const onerror = (err: FieldErrors) => console.log(err);

  return (
    <form onSubmit={handleSubmit(onsubmit, onerror)} noValidate>
      <div>
        <label htmlFor="saleName" className="pr-4">
          {t("form.label.saleName")}
        </label>
        <input
          id="saleName"
          type="text"
          {...register("saleName")}
          className="text-black"
        />
        <div>{errors.saleName?.message}</div>
      </div>
      <div></div>
      <div>
        <button type="submit">送信</button>
      </div>
    </form>
  );
};
