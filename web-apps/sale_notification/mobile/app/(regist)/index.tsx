import { StyleSheet, Text, View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { SaleRegistForm } from "./components/SaleRegistForm";

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text>Regist Page</Text>
      <SaleRegistForm />
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
    padding: 16,
    paddingTop: 120,
  },
  text: {
    fontSize: 20,
    color: "#000", // テキストの色を設定
  },
});
