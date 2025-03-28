import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, ActivityIndicator, ScrollView, Dimensions } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { SolarIcon } from 'react-native-solar-icons';
import Animated, { useSharedValue, useAnimatedStyle, withTiming, withSequence, withDelay } from 'react-native-reanimated';

import ModelViewer from '@/components/positioning/ModelViewer';
import PositioningControls from '@/components/positioning/PositioningControls';
import PositioningGuide from '@/components/positioning/PositioningGuide';

const Positioning = () => {
  const navigation = useNavigation();
  const route = useRoute();
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'controls' | 'guide'>('controls');
  const [feedback, setFeedback] = useState<null | { status: 'success' | 'error'; message: string }>(null);
  
  // State for precise controls
  const [rotationX, setRotationX] = useState(0);
  const [rotationY, setRotationY] = useState(0);
  const [rotationZ, setRotationZ] = useState(0);
  const [beamCenterX, setBeamCenterX] = useState(50);
  const [beamCenterY, setBeamCenterY] = useState(50);
  const [beamAngle, setBeamAngle] = useState(0);
  const [viewType, setViewType] = useState<string>('anterior');
  
  // Animation values
  const headerOpacity = useSharedValue(0);
  const headerTranslateY = useSharedValue(-20);
  const contentOpacity = useSharedValue(0);
  const panelTranslateY = useSharedValue(50);
  
  // Parse route params to determine what type of content to show
  const params = route.params || {};
  const { region, exercise, challenge } = params as any;
  
  let title = "Positioning";
  if (region) {
    // Convert region-name to Region Name format
    title = region.split('-').map((word: string) => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
  } else if (exercise) {
    // Here we would look up the exercise name from the ID
    title = exercise.split('-').map((word: string) => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
  } else if (challenge) {
    // Here we would look up the challenge name from the ID
    title = challenge.split('-').map((word: string) => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
  }
  
  // Simulate loading the 3D scene
  useEffect(() => {
    const timer = setTimeout(() => {
      setIsLoading(false);
      
      // Start animations
      headerOpacity.value = withTiming(1, { duration: 500 });
      headerTranslateY.value = withTiming(0, { duration: 500 });
      contentOpacity.value = withTiming(1, { duration: 500 });
      panelTranslateY.value = withDelay(300, withTiming(0, { duration: 500 }));
    }, 1500);
    
    return () => clearTimeout(timer);
  }, []);
  
  const handleBack = () => {
    navigation.goBack();
  };
  
  const handleCheckPosition = () => {
    // In a real implementation, this would check against optimal values for the selected view
    // For this demo, we'll just check if the values are close to some predefined optimal values
    
    let success = false;
    let message = "";
    
    // Different optimal values for different view types
    const optimalValues = {
      anterior: { rotX: 0, rotY: 0, beamX: 50, beamY: 50, angle: 0 },
      posterior: { rotX: 0, rotY: 180, beamX: 50, beamY: 50, angle: 0 },
      lateral: { rotX: 0, rotY: 90, beamX: 50, beamY: 50, angle: 0 },
      oblique: { rotX: 0, rotY: 45, beamX: 50, beamY: 50, angle: 0 }
    };
    
    const optimal = optimalValues[viewType as keyof typeof optimalValues];
    
    // A very simple check - are we within 10 degrees/percent of optimal?
    const rotXDiff = Math.abs(rotationX - optimal.rotX);
    const rotYDiff = Math.abs(rotationY - optimal.rotY);
    const beamXDiff = Math.abs(beamCenterX - optimal.beamX);
    const beamYDiff = Math.abs(beamCenterY - optimal.beamY);
    const angleDiff = Math.abs(beamAngle - optimal.angle);
    
    if (rotXDiff <= 10 && rotYDiff <= 10 && beamXDiff <= 10 && beamYDiff <= 10 && angleDiff <= 10) {
      success = true;
      message = "Great job! Positioning is correct for " + viewType + " view.";
    } else {
      success = false;
      if (rotXDiff > 10 || rotYDiff > 10) {
        message = "Positioning needs adjustment. Check patient rotation.";
      } else if (beamXDiff > 10 || beamYDiff > 10) {
        message = "Positioning needs adjustment. Check beam centering.";
      } else {
        message = "Positioning needs adjustment. Check beam angle.";
      }
    }
    
    setFeedback({
      status: success ? 'success' : 'error',
      message: message
    });
    
    // Clear feedback after 3 seconds
    setTimeout(() => {
      setFeedback(null);
    }, 3000);
  };

  // Animated styles
  const headerAnimStyle = useAnimatedStyle(() => {
    return {
      opacity: headerOpacity.value,
      transform: [{ translateY: headerTranslateY.value }],
    };
  });
  
  const panelAnimStyle = useAnimatedStyle(() => {
    return {
      transform: [{ translateY: panelTranslateY.value }],
    };
  });
  
  const feedbackAnimStyle = useAnimatedStyle(() => {
    return {
      opacity: feedback ? withSequence(
        withTiming(1, { duration: 300 }),
        withDelay(2400, withTiming(0, { duration: 300 }))
      ) : 0,
      transform: [{ 
        translateY: feedback ? 
          withSequence(
            withTiming(0, { duration: 300 }),
            withDelay(2400, withTiming(20, { duration: 300 }))
          ) : 20 
      }],
    };
  });

  // Calculate panel dimensions based on screen size - more responsive
  const screenHeight = Dimensions.get('window').height;
  const controlPanelHeight = screenHeight * 0.4; // Make it exactly 40% of screen height

  return (
    <View className="flex-1 bg-background-950">
      {/* Top navigation bar */}
      <Animated.View 
        className="flex-row items-center justify-between px-4 py-3 border-b border-background-200/20 bg-white"
        style={headerAnimStyle}
      >
        <TouchableOpacity
          onPress={handleBack}
          className="flex-row items-center"
        >
          <SolarIcon name="ArrowLeft" type="linear" size={20} color="#4a4a4a" />
          <Text className="text-sm font-satoshi-medium text-text-400 ml-1">
            Back
          </Text>
        </TouchableOpacity>
        
        <Text className="text-lg font-chillax-medium text-primary-500">
          {title}
        </Text>
        
        <TouchableOpacity className="p-1">
          <SolarIcon name="InfoSquare" type="linear" size={20} color="#4a4a4a" />
        </TouchableOpacity>
      </Animated.View>
      
      {/* 3D visualization area */}
      <View className="flex-1 relative">
        {isLoading ? (
          <View className="flex-1 justify-center items-center bg-background-950">
            <ActivityIndicator size="large" color="#4478bb" />
            <Text className="mt-4 text-text-400 font-satoshi">
              Loading 3D environment...
            </Text>
          </View>
        ) : (
          <Animated.View 
            className="flex-1"
            style={{ opacity: contentOpacity }}
          >
            <ModelViewer
              rotationX={rotationX}
              setRotationX={setRotationX}
              rotationY={rotationZ}
              setRotationY={setRotationZ}
              rotationZ={rotationY}
              setRotationZ={setRotationY}
              beamCenterX={beamCenterX}
              setBeamCenterX={setBeamCenterX}
              beamCenterY={beamCenterY}
              setBeamCenterY={setBeamCenterY}
              beamAngle={beamAngle}
              setBeamAngle={setBeamAngle}
            />
          </Animated.View>
        )}
        
        {/* Feedback overlay */}
        {feedback && (
          <Animated.View
            className={`absolute bottom-6 left-1/2 -translate-x-36 w-72 py-3 px-4 rounded-lg shadow-sm items-center ${
              feedback.status === 'success' ? 'bg-green-50' : 'bg-red-50'
            }`}
            style={feedbackAnimStyle}
          >
            <Text className={`text-sm font-satoshi-medium text-center ${
              feedback.status === 'success' ? 'text-green-600' : 'text-red-600'
            }`}>
              {feedback.message}
            </Text>
          </Animated.View>
        )}
      </View>
      
      {/* Controls panel */}
      <Animated.View 
        className="bg-white border-t border-background-200/20 shadow-sm"
        style={[
          panelAnimStyle, 
          { 
            height: controlPanelHeight,
            maxHeight: controlPanelHeight,
          }
        ]}
      >
        {/* Tabs */}
        <View className="flex-row border-b border-background-200/20">
          <TouchableOpacity
            onPress={() => setActiveTab('controls')}
            className={`flex-1 py-3 items-center ${
              activeTab === 'controls'
                ? 'border-b-2 border-primary-500'
                : ''
            }`}
          >
            <Text className={`text-sm font-satoshi-medium ${
              activeTab === 'controls'
                ? 'text-primary-500'
                : 'text-text-400'
            }`}>
              Controls
              
            </Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            onPress={() => setActiveTab('guide')}
            className={`flex-1 py-3 items-center ${
              activeTab === 'guide'
                ? 'border-b-2 border-primary-500'
                : ''
            }`}
          >
            <Text className={`text-sm font-satoshi-medium ${
              activeTab === 'guide'
                ? 'text-primary-500'
                : 'text-text-400'
            }`}>
              Positioning Guide
            </Text>
          </TouchableOpacity>
        </View>
        
        {/* Tab content */}
        <View className="flex-1 overflow-hidden">
          {activeTab === 'controls' ? (
            <PositioningControls
              rotationX={rotationX}
              setRotationX={setRotationX}
              rotationY={rotationY}
              setRotationY={setRotationY}
              rotationZ={rotationZ}
              setRotationZ={setRotationZ}
              beamCenterX={beamCenterX}
              setBeamCenterX={setBeamCenterX}
              beamCenterY={beamCenterY}
              setBeamCenterY={setBeamCenterY}
              beamAngle={beamAngle}
              setBeamAngle={setBeamAngle}
              viewType={viewType}
              setViewType={setViewType}
              handleCheckPosition={handleCheckPosition}
            />
          ) : (
            <PositioningGuide viewType={viewType} />
          )}
        </View>
      </Animated.View>
    </View>
  );
};

export default Positioning;