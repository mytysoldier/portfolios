"use client";
import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import { Form, formSchema } from "./yupForm";
import { yupResolver } from "@hookform/resolvers/yup";
import { InputControl } from "@/components/form/input/InputControl";
import { SelectBoxControl } from "@/components/form/selectbox/SelectBoxControl";
import { CustomDatePickerControl } from "@/components/form/datepicker/CustomDatePickerControl";
import { Button, ButtonType } from "@/components/Button";
import { useRouter } from "next/navigation";

export const SaleDetailForm = () => {
  const { t } = useTranslation();
  const router = useRouter();

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = (data: Form) => console.log(JSON.stringify(data));

  return (
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(onSubmit)} noValidate>
        <div className="flex items-center gap-4 mb-4 px-16">
          <label htmlFor="saleName" className="w-32">
            {t("form.label.saleName")}
          </label>
          <InputControl<Form>
            fieldName="saleName"
            className="text-black flex-1 border h-10 rounded leading-10"
          />
        </div>

        <div className="flex items-center gap-4 mb-4 px-16">
          <label htmlFor="itemCategory" className="w-32">
            {t("form.label.itemCategory")}
          </label>
          <SelectBoxControl<Form>
            fieldName="itemCategory"
            className="text-black h-10 min-w-[100px] leading-10"
            items={[
              {
                label: t("form.selectbox.itemCategory.digitalEquipment"),
                value: "digitalEquipment",
              },
              {
                label: t("form.selectbox.itemCategory.sportsOutdoors"),
                value: "sportsOutdoors",
              },
              {
                label: t("form.selectbox.itemCategory.books"),
                value: "books",
              },
              {
                label: t("form.selectbox.itemCategory.dailyNecessities"),
                value: "dailyNecessities",
              },
              {
                label: t("form.selectbox.itemCategory.kitchenItems"),
                value: "kitchenItems",
              },
              {
                label: t("form.selectbox.itemCategory.foodBeverageAlcohol"),
                value: "foodBeverageAlcohol",
              },
              {
                label: t(
                  "form.selectbox.itemCategory.cosmeticsAndBeautySupplies",
                ),
                value: "cosmeticsAndBeautySupplies",
              },
            ]}
          />
        </div>

        <div className="flex items-center gap-4 mb-4 px-16">
          <label htmlFor="startDate" className="w-32">
            {t("form.label.startDate")}
          </label>
          <div className="flex items-center">
            <CustomDatePickerControl<Form>
              fieldName="startDate"
              className="h-10 leading-10"
            />
            <label htmlFor="endDate" className="w-32 ml-48">
              {t("form.label.endDate")}
            </label>
            <CustomDatePickerControl<Form>
              fieldName="endDate"
              className="h-10 leading-10"
            />
          </div>
        </div>

        <div className="flex justify-end pr-32 gap-4">
          <Button
            title={t("form.button.back")}
            buttonType={ButtonType.SECONDARY}
            onClick={() => {
              router.back();
            }}
          />
          <Button
            title={t("form.button.update")}
            buttonType={ButtonType.PRIMARY}
            // TODO 検索処理追加
            onClick={() => {}}
          />
        </div>
      </form>
    </FormProvider>
  );
};
