import { View, Text } from "react-native";
import React from "react";
import { Tabs } from "expo-router";
// Import Solar icons
import { SolarIcon } from 'react-native-solar-icons';

const _Layout = () => {
  return (
    <Tabs
      screenOptions={{
        tabBarStyle: {
          height: 70,
          paddingBottom: 10,
          paddingTop: 10,
          backgroundColor: 'rgba(248, 249, 250, 0.95)',
          borderTopWidth: 0,
          elevation: 0,
          shadowOpacity: 0,
        },
        tabBarActiveTintColor: '#4e49b6', // secondary-500
        tabBarInactiveTintColor: '#1b2c4b', // text-200
        tabBarLabelStyle: {
          fontFamily: 'Chillax-Medium',
          fontSize: 12,
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: "Home",
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <SolarIcon name="HomeSmile" type="linear" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="learn"
        options={{
          title: "Learn",
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <SolarIcon name="NotebookMinimalistic" type="linear" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="practice"
        options={{
          title: "Practice",
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <SolarIcon name="Target" type="linear" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="challenge"
        options={{
          title: "Challenge",
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <SolarIcon name="Cup" type="linear" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: "Profile", 
          headerShown: false,
          tabBarIcon: ({ color, size }) => (
            <SolarIcon name="User" type="linear" size={size} color={color} />
          ),
        }}
      />
    </Tabs>
  );
};

export default _Layout;