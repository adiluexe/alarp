import { Stack } from "expo-router";
import "./globals.css";
import { useFonts } from "expo-font";
import { useEffect } from "react";
import { SplashScreen } from "expo-router";

export default function RootLayout() {
  const [fontsLoaded, fontError] = useFonts({
    "Chillax-Regular": require("../assets/fonts/Chillax-Regular.otf"),
    "Chillax-Medium": require("../assets/fonts/Chillax-Medium.otf"),
    "Chillax-Semibold": require("../assets/fonts/Chillax-Semibold.otf"),
    "Chillax-Bold": require("../assets/fonts/Chillax-Bold.otf"),
    "Satoshi-Regular": require("../assets/fonts/Satoshi-Regular.otf"),
    "Satoshi-Medium": require("../assets/fonts/Satoshi-Medium.otf"),
    "Satoshi-Bold": require("../assets/fonts/Satoshi-Bold.otf"),
  });

  // Expose the fonts loaded state
  useEffect(() => {
    if (fontsLoaded || fontError) {
      // Hide the splash screen after the fonts have loaded or if there was an error
      SplashScreen.hideAsync();
    }
  }, [fontsLoaded, fontError]);

  // If fonts are still loading, you can return null or a loading indicator
  if (!fontsLoaded && !fontError) {
    return null;
  }
  return (
    <Stack>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen name="learn/[id]" options={{ headerShown: false }} />
    </Stack>
  );
}
