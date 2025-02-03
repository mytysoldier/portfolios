import {
  DarkTheme,
  DefaultTheme,
  ThemeProvider,
} from "@react-navigation/native";
import { useFonts } from "expo-font";
import { Stack } from "expo-router";
import * as SplashScreen from "expo-splash-screen";
import { StatusBar } from "expo-status-bar";
import { useEffect } from "react";
import "react-native-reanimated";
import "./i18n/configs";

import { useColorScheme } from "@/hooks/useColorScheme";
import { SafeAreaView, Text, TouchableOpacity, View } from "react-native";
import { HeaderBackButton } from "@react-navigation/elements";

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

const HeaderText = () => {
  return (
    <View>
      <Text>aaa</Text>
    </View>
  );
};

export default function RootLayout() {
  const colorScheme = useColorScheme();
  const [loaded] = useFonts({
    SpaceMono: require("../assets/fonts/SpaceMono-Regular.ttf"),
  });

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return (
    <ThemeProvider value={colorScheme === "dark" ? DarkTheme : DefaultTheme}>
      <Stack>
        <Stack.Screen name="index" options={{ headerShown: false }} />
        <Stack.Screen
          name="(list)/index"
          options={{ headerShown: false, title: "List" }}
        />
        <Stack.Screen
          name="(detail)/index"
          options={{ headerShown: true, title: "Detail" }}
        />
        <Stack.Screen
          name="(regist)/index"
          options={{
            headerShown: true,
            title: "Regist",
            header: ({ navigation, route, options, back }) => {
              return (
                <SafeAreaView>
                  <View
                    style={{
                      height: 100,
                      backgroundColor: "lightblue",
                      flexDirection: "row",
                      alignItems: "center",
                      justifyContent: "space-between",
                    }}
                  >
                    {back && (
                      <HeaderBackButton
                        label="Back"
                        onPress={navigation.goBack}
                        style={{ position: "absolute", left: 0 }}
                      />
                    )}
                    <View
                      style={{
                        alignItems: "center",
                        justifyContent: "center",
                        width: "100%",
                      }}
                    >
                      <Text style={{}}>Regist</Text>
                    </View>
                  </View>
                </SafeAreaView>
              );
            },
          }}
        />
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="+not-found" />
      </Stack>
      <StatusBar style="auto" />
    </ThemeProvider>
  );
}
