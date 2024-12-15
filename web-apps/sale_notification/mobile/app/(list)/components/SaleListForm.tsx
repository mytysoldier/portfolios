import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import { Dimensions, StyleSheet, Text, View } from "react-native";
import { Form, formSchema } from "./yupForm";
import { yupResolver } from "@hookform/resolvers/yup";
import { InputControl } from "@/components/form/input/InputControl";

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

  return (
    <FormProvider {...methods}>
      <View>
        <View style={styles.container}>
          <View style={styles.row}>
            <Text style={styles.label}>{t("form.label.saleName")}</Text>
            <InputControl<Form> fieldName="saleName" style={styles.input} />
          </View>
        </View>
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
});
