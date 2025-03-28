import { View, Text } from 'react-native'
import React from 'react'
import { router } from "expo-router";


const Challenge = () => {
  return (
    <View>
      <Text>Challenge</Text>
      <Text onPress={() => router.push('../positioning/positioning')}>Positioning</Text>
    </View>
  )
}

export default Challenge