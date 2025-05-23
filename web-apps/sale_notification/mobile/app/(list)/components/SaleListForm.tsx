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
import { useEffect, useState } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { getSaleList } from "../actions/actions";
import { SaleListReq } from "../models/request";

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

  const [saleItems, setSaleItems] = useState<Sales[]>([]);

  const methods = useForm<Form>({
    mode: "onBlur",
    defaultValues: {
      saleName: "",
      saleStatus: "",
    },
    resolver: yupResolver(formSchema),
  });

  const onSubmit = async (data: Form) => {
    // setData(testData);
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
    setSaleItems(saleList);
    console.log(JSON.stringify(data));
  };

  const handleSubmit = methods.handleSubmit(onSubmit);

  useEffect(() => {
    (async () => {
      const result = await getSaleList();
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
      setSaleItems(saleList);
      console.log(JSON.stringify(saleItems));
    })();
  }, []);

  return (
    <FormProvider {...methods}>
      <View style={styles.container}>
        <View>
          <View style={styles.row}>
            {/* <Text style={styles.label}>{t("form.label.saleName")}</Text> */}
            {/* <Text>{width}</Text> */}
            <InputControl<Form> fieldName="saleName" style={styles.input} />
          </View>

          <View>
            <Text style={{ marginBottom: 10 }}>
              {t("form.label.saleStatus")}
            </Text>
            {/* <InputControl<Form> fieldName="saleName" style={styles.input} /> */}
            <SelectBoxControl<Form>
              fieldName="saleStatus"
              data={[]}
              items={[
                {
                  key: 1,
                  label: "未選択",
                  value: "",
                },
                {
                  key: 2,
                  label: "未開始",
                  value: "todo",
                },
                {
                  key: 3,
                  label: "開催中",
                  value: "doing",
                },
                {
                  key: 4,
                  label: "終了",
                  value: "done",
                },
              ]}
            />
          </View>
        </View>

        <View>
          <Text style={{ marginBottom: 10 }}>{t("form.label.startDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="startDate" mode="single" />
        </View>

        <View style={{ marginBottom: 16 }}>
          <Text style={{ marginBottom: 10 }}>{t("form.label.endDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="endDate" mode="single" />
        </View>

        {/* <View style={styles.row}>
          <Text style={styles.label}>{t("form.label.startDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="startDate" mode="single" />
          <Text style={styles.label}>{t("form.label.endDate")}</Text>
          <CustomDatePickerControl<Form> fieldName="endDate" mode="single" />
        </View> */}

        <TouchableOpacity style={styles.submitButton} onPress={handleSubmit}>
          <Text style={styles.submitButtonText}>{t("form.button.search")}</Text>
        </TouchableOpacity>

        {saleItems && saleItems.length > 0 ? (
          <SNTable data={saleItems} />
        ) : (
          <View style={{ flex: 1, backgroundColor: "white" }} />
        )}
        {/* <SNTable data={data} /> */}
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
    marginRight: 10,
  },
  input: {
    // alignSelf: "stretch",
    // flex: 1,
    // width: width / 2,
    width: width * 0.8,
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
