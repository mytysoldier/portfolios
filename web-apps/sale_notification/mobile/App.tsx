import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";
import { SharedButton } from "shared";

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Open up App.tsx to start working on your app!</Text>
      <StatusBar style="auto" />
      <SharedButton label="test" onClick={() => alert("")} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});