import { StyleSheet, Text, View } from "react-native";
import { SaleListForm } from "./components/SaleListForm";

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>List Page</Text>
      <SaleListForm />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#fff", // 背景色を設定
  },
  text: {
    fontSize: 20,
    color: "#000", // テキストの色を設定
  },
});
