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

export const SaleListForm = () => {
  const { t } = useTranslation();

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = (data: Form) => console.log(JSON.stringify(data));

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
          <InputControl<Form> fieldName="saleName" style={styles.input} />
          <Text style={styles.label}>{t("form.label.endDate")}</Text>
        </View>

        <TouchableOpacity style={styles.submitButton} onPress={handleSubmit}>
          <Text style={styles.submitButtonText}>{t("form.button.search")}</Text>
        </TouchableOpacity>
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
