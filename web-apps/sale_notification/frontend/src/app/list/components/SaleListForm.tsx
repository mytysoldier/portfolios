import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import { Form, formSchema } from "./yupForm";
import { yupResolver } from "@hookform/resolvers/yup";
import { InputControl } from "@/components/form/input/InputControl";
import { SelectBoxControl } from "@/components/form/selectbox/SelectBoxControl";
import { CustomDatePickerControl } from "@/components/form/datepicker/CustomDatePickerControl";
import { Button, ButtonType } from "@/components/Button";
import { Sales } from "@/components/SNTable";
import { SaleListReq } from "../models/request";
import { getSaleList } from "../actions/actions";

type Props = {
  updateSales: React.Dispatch<React.SetStateAction<Sales[]>>;
};

export const SaleListForm: React.FC<Props> = ({ updateSales }) => {
  const { t } = useTranslation();

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "sss",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = async (data: Form) => {
    console.log(JSON.stringify(data));
    const request: SaleListReq = {
      name: data.saleName,
      startAt: data.startDate,
      endAt: data.endDate,
    };
    const result = await getSaleList(request);
    console.log(`sale list search result : ${JSON.stringify(result)}`);
    const saleList: Sales[] = result.map((item) => {
      let status = "";
      const now = new Date();
      const startAt = new Date(item.start_at);
      const endAt = new Date(item.end_at);
      console.log(`now : ${now}`);
      console.log(`startAt : ${startAt}`);
      console.log(`endAt : ${endAt}`);
      if (startAt > now) {
        status = "未開始";
      } else if (endAt < now) {
        status = "終了";
      } else {
        status = "開催中";
      }

      return {
        id: item.id,
        saleName: item.name,
        itemCategory: item.item_category,
        status,
        startAt: item.start_at,
        endAt: item.end_at,
      };
    });
    updateSales(saleList);
  };

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
          <label htmlFor="saleStatus" className="w-32">
            {t("form.label.saleStatus")}
          </label>
          <SelectBoxControl<Form>
            fieldName="saleStatus"
            className="text-black h-10 min-w-[100px] leading-10"
            items={[
              {
                label: "未選択",
                value: "",
              },
              {
                label: "未開始",
                value: "todo",
              },
              {
                label: "開催中",
                value: "doing",
              },
              {
                label: "終了",
                value: "done",
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
        <div className="flex justify-end pr-32">
          <Button
            title={t("form.button.search")}
            buttonType={ButtonType.PRIMARY}
            // TODO 検索処理追加
            onClick={() => {}}
          />
        </div>
      </form>
    </FormProvider>
  );
};
