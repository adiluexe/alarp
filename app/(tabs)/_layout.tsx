import { View, Text } from "react-native";
import React from "react";
import { Tabs } from "expo-router";

const _Layout = () => {
  return (
    <Tabs>
      <Tabs.Screen
        name="index"
        options={{title: "Home", headerShown: false}}
      />
      <Tabs.Screen
        name="learn"
        options={{title: "Learn", headerShown: false}}
      />
      <Tabs.Screen
        name="practice"
        options={{title: "Practice", headerShown: false}}
      />
      <Tabs.Screen
        name="challenge"
        options={{title: "Challenge", headerShown: false}}
      />
      <Tabs.Screen
        name="profile"
        options={{title: "Profile", headerShown: false}}
      />
    </Tabs>
    
  );
};

export default _Layout;
