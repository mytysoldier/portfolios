import { ScrollView, StyleSheet, Text, View } from "react-native";
import { SaleListForm } from "./components/SaleListForm";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { ThemedText } from "@/components/ThemedText";
import { Link } from "expo-router";

export default function HomeScreen() {
  return (
    <SafeAreaProvider>
      <SafeAreaView>
        <ScrollView>
          <View style={styles.container}>
            <Text style={styles.text}>List Page</Text>
            <Link
              href={{
                pathname: "/(regist)",
              }}
            >
              <ThemedText type="link">セール追加</ThemedText>
            </Link>

            <SaleListForm />
          </View>
        </ScrollView>
      </SafeAreaView>
    </SafeAreaProvider>
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
  },
  text: {
    fontSize: 20,
    color: "#000", // テキストの色を設定
  },
});
