import { StyleSheet, Text, View } from "react-native";
import { SaleListForm } from "./components/SaleListForm";
import { SNTable } from "@/components/SNTable";

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

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>List Page</Text>
      <SaleListForm />
      <SNTable data={testData} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    // flex: 1,
    justifyContent: "center",
    // alignItems: "center",
    backgroundColor: "#fff", // 背景色を設定
    height: "100%",
  },
  text: {
    fontSize: 20,
    color: "#000", // テキストの色を設定
  },
});
