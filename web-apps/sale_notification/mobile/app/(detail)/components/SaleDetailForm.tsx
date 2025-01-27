import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import {
  Dimensions,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { yupResolver } from "@hookform/resolvers/yup";
import { InputControl } from "@/components/form/input/InputControl";
import { SelectBoxControl } from "@/components/form/selectbox/SelectBoxControl ";
import { CustomDatePickerControl } from "@/components/form/datepicker/CustomDatePickerControl";
import { Sales, SNTable } from "@/components/SNTable";
import { useState } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Form, formSchema } from "@/app/(list)/components/yupForm";
import { router, useRouter } from "expo-router";

export const SaleDetailForm = () => {
  const { t } = useTranslation();
  const [data, setData] = useState<Sales[]>([]);
  const router = useRouter();

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "",
      saleStatus: "",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = (data: Form) => {
    console.log(JSON.stringify(data));
  };

  const handleSubmit = methods.handleSubmit(onSubmit);
  const handleBack = methods.handleSubmit(router.back);

  return (
    <FormProvider {...methods}>
      <View style={styles.container}>
        <View style={styles.block}>
          <Text style={styles.label}>{t("form.label.saleName")}</Text>
          <InputControl<Form> fieldName="saleName" style={styles.input} />
        </View>

        <View style={styles.block}>
          <Text style={styles.label}>{t("form.label.itemCategory")}</Text>
          <SelectBoxControl<Form>
            fieldName="saleItemCategory"
            data={[]}
            items={[
              {
                key: 1,
                label: t("form.selectbox.itemCategory.digitalEquipment"),
                value: "digitalEquipment",
              },
              {
                key: 2,
                label: t("form.selectbox.itemCategory.sportsOutdoors"),
                value: "sportsOutdoors",
              },
              {
                key: 3,
                label: t("form.selectbox.itemCategory.books"),
                value: "books",
              },
              {
                key: 4,
                label: t("form.selectbox.itemCategory.dailyNecessities"),
                value: "dailyNecessities",
              },
              {
                key: 5,
                label: t("form.selectbox.itemCategory.kitchenItems"),
                value: "kitchenItems",
              },
              {
                key: 6,
                label: t("form.selectbox.itemCategory.foodBeverageAlcohol"),
                value: "foodBeverageAlcohol",
              },
              {
                key: 7,
                label: t(
                  "form.selectbox.itemCategory.cosmeticsAndBeautySupplies"
                ),
                value: "cosmeticsAndBeautySupplies",
              },
            ]}
          />
        </View>

        <View style={styles.block}>
          <Text style={styles.label}>{t("form.label.startDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="startDate" mode="single" />
        </View>

        <View style={styles.block}>
          <Text style={styles.label}>{t("form.label.endDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="endDate" mode="single" />
        </View>

        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.halfWidthButton} onPress={handleBack}>
            <Text style={styles.submitButtonText}>{t("form.button.back")}</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.halfWidthButton}
            onPress={handleSubmit}
          >
            <Text style={styles.submitButtonText}>
              {t("form.button.update")}
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </FormProvider>
  );
};

// 端末横幅
// const insets = useSafeAreaInsets();
const width = Dimensions.get("window").width;

const styles = StyleSheet.create({
  container: {
    padding: 16,
    height: Dimensions.get("window").height,
  },
  block: {
    marginBottom: 16,
  },
  row: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 10,
    // paddingHorizontal: 60,
    // paddingRight: 100,
  },
  label: {
    width: 80,
    marginBottom: 10,
  },
  input: {
    // alignSelf: "stretch",
    // flex: 1,
    // width: width / 2,
    width: width * 0.8,
    height: 40,
  },
  buttonContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
  },
  halfWidthButton: {
    flex: 1,
    marginHorizontal: 5,
    backgroundColor: "#007BFF",
    padding: 10,
    alignItems: "center",
    borderRadius: 5,
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
