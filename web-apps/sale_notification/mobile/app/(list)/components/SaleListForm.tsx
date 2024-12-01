import { FormProvider, useForm } from "react-hook-form";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { Form, formSchema } from "./yupForm";
import { yupResolver } from "@hookform/resolvers/yup";

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
      <View></View>
    </FormProvider>
  );
};
