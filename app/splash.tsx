import React, { useEffect } from 'react';
import { View, Text, Dimensions } from 'react-native';
import { Redirect } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import Animated, { 
  useSharedValue, 
  useAnimatedStyle, 
  withTiming,
  Easing,
  runOnJS
} from 'react-native-reanimated';
import { AlarpIcon } from '../components/AlarpIcon';

// Keep the splash screen visible while we fetch resources
SplashScreen.preventAutoHideAsync();

// Get screen dimensions for positioning
const { height } = Dimensions.get('window');

export default function SplashPage() {
  const [isReady, setIsReady] = React.useState(false);
  const opacity = useSharedValue(0); // Start everything invisible
  
  const containerStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
  }));

  function onAnimationComplete() {
    setIsReady(true);
  }

  useEffect(() => {
    async function prepare() {
      try {
        // Pre-load any assets or make API calls here
        await new Promise(resolve => setTimeout(resolve, 1000));
      } catch (e) {
        console.warn(e);
      } finally {
        // Hide the native splash screen
        await SplashScreen.hideAsync();

        // Simple fade in everything at once
        opacity.value = withTiming(1, { 
          duration: 800, 
          easing: Easing.out(Easing.ease) 
        });

        // After everything is shown, fade out entire screen
        setTimeout(() => {
          opacity.value = withTiming(0, { 
            duration: 500, 
            easing: Easing.in(Easing.ease) 
          }, () => {
            runOnJS(onAnimationComplete)();
          });
        }, 2500);
      }
    }

    prepare();
  }, []);

  if (isReady) {
    return <Redirect href="/(tabs)" />;
  }

  return (
    <Animated.View 
      className="flex-1 bg-white" 
      style={containerStyle}
    >
      {/* Center container for logo */}
      <View className="flex-1 items-center justify-center">
        <AlarpIcon size={120} color="#5B8CBE" />
      </View>
      
      {/* Bottom container for text, positioned at 80% of screen height */}
      <View className="absolute bottom-0 left-0 right-0 mb-20 items-center">
        <Text className="text-5xl font-chillax-bold text-primary-500">
          ALARP
        </Text>
        <Text className="text-base font-chillax-medium text-text-300 text-center px-8">
          A Learning Aid in Radiographic Positioning
        </Text>
      </View>
    </Animated.View>
  );
}