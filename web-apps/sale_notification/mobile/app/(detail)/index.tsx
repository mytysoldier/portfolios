import { useLocalSearchParams, useRouter } from "expo-router";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { SaleDetailForm } from "./components/SaleDetailForm";

export default function HomeScreen() {
  const router = useRouter();
  const params = useLocalSearchParams();
  const { id } = params;
  return (
    <View style={styles.container}>
      <Text>Detail Page</Text>
      <Text>{id}</Text>
      <TouchableOpacity onPress={() => router.back()}>
        <Text>texttexttext</Text>
      </TouchableOpacity>
      <SaleDetailForm id={Number(id)} />
      <TouchableOpacity onPress={() => router.back()}>
        <Text>texttexttext</Text>
      </TouchableOpacity>
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
    paddingTop: 100,
  },
  text: {
    fontSize: 20,
    color: "#000", // テキストの色を設定
  },
});
