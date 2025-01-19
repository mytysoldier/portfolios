import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import {
  Dimensions,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { Form, formSchema } from "./yupForm";
import { yupResolver } from "@hookform/resolvers/yup";
import { InputControl } from "@/components/form/input/InputControl";
import { SelectBoxControl } from "@/components/form/selectbox/SelectBoxControl ";
import { CustomDatePickerControl } from "@/components/form/datepicker/CustomDatePickerControl";
import { Sales, SNTable } from "@/components/SNTable";
import { useState } from "react";

const testData: Sales[] = [
  {
    id: 1,
    saleName: "Summer Sale",
    itemCategory: "Clothing",
    status: "Active",
    startAt: new Date("2024-06-01"),
    endAt: new Date("2024-06-30"),
  },
  {
    id: 2,
    saleName: "Winter Clearance",
    itemCategory: "Footwear",
    status: "Completed",
    startAt: new Date("2024-12-01"),
    endAt: new Date("2024-12-31"),
  },
  {
    id: 3,
    saleName: "Back to School",
    itemCategory: "Stationery",
    status: "Active",
    startAt: new Date("2024-08-01"),
    endAt: new Date("2024-08-31"),
  },
];

export const SaleListForm = () => {
  const { t } = useTranslation();
  const [data, setData] = useState<Sales[]>([]);

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = (data: Form) => {
    setData(testData);
    console.log(JSON.stringify(data));
  };

  const handleSubmit = methods.handleSubmit(onSubmit);

  return (
    <FormProvider {...methods}>
      <View>
        <View style={styles.container}>
          <View style={styles.row}>
            <Text style={styles.label}>{t("form.label.saleName")}</Text>
            <InputControl<Form> fieldName="saleName" style={styles.input} />
          </View>

          <View style={styles.row}>
            <Text style={styles.label}>{t("form.label.saleStatus")}</Text>
            {/* <InputControl<Form> fieldName="saleName" style={styles.input} /> */}
            <SelectBoxControl<Form>
              fieldName="saleStatus"
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
          </View>
        </View>

        <View style={styles.row}>
          <Text style={styles.label}>{t("form.label.startDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="startDate" mode="single" />
          <Text style={styles.label}>{t("form.label.endDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="endDate" mode="single" />
        </View>

        <TouchableOpacity style={styles.submitButton} onPress={handleSubmit}>
          <Text style={styles.submitButtonText}>{t("form.button.search")}</Text>
        </TouchableOpacity>

        {data && data.length > 0 && <SNTable data={data} />}
        {/* <SNTable data={data} /> */}
      </View>
    </FormProvider>
  );
};

// 端末横幅
const width = Dimensions.get("window").width;

const styles = StyleSheet.create({
  container: {
    padding: 16,
  },
  row: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 10,
    // paddingHorizontal: 60,
    // paddingRight: 100,
  },
  label: {
    width: 80,
    marginRight: 10,
  },
  input: {
    // alignSelf: "stretch",
    // flex: 1,
    width: width / 2,
    height: 40,
  },
  submitButton: {
    backgroundColor: "#007AFF",
    padding: 15,
    borderRadius: 8,
    alignItems: "center",
  },
  submitButtonText: {
    color: "white",
    fontSize: 16,
    fontWeight: "600",
  },
});
