import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { SolarIcon } from 'react-native-solar-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';

export interface Exercise {
  id: string;
  title: string;
  description: string;
  region: string;
  difficulty: string;
  lastPracticed: string | null;
  timeEstimate: string;
  stepByStep: boolean;
}

interface ExerciseCardProps {
  exercise: Exercise;
  index: number;
  onPress: (exerciseId: string) => void;
  compact?: boolean;
}

const ExerciseCard = ({ exercise, index, onPress, compact = false }: ExerciseCardProps) => {
  if (compact) {
    // Recently practiced compact card
    return (
      <Animated.View
        entering={FadeInDown.delay(index * 100).duration(400)}
      >
        <TouchableOpacity
          onPress={() => onPress(exercise.id)}
          className="bg-background-50/5 border border-background-100/20 rounded-lg p-3 flex-row items-center justify-between"
        >
          <View>
            <Text className="text-sm font-chillax-medium text-primary-500">
              {exercise.title}
            </Text>
            <Text className="text-xs text-text-400">
              {exercise.lastPracticed}
            </Text>
          </View>
          <View className="flex-row items-center">
            <SolarIcon name="ClockCircle" type="linear" size={14} color="#8fa8d6" />
            <Text className="text-xs text-text-400 ml-1">
              {exercise.timeEstimate}
            </Text>
          </View>
        </TouchableOpacity>
      </Animated.View>
    );
  }

  // Full exercise card
  return (
    <Animated.View
      entering={FadeInDown.delay(index * 100).duration(400)}
    >
      <TouchableOpacity
        onPress={() => onPress(exercise.id)}
        className="bg-white border border-background-100/20 rounded-xl p-4 shadow-sm"
      >
        <View className="flex-row justify-between items-start">
          <View className="flex-1 mr-4">
            <Text className="text-lg font-chillax-medium text-primary-500">
              {exercise.title}
            </Text>
            <Text className="text-sm text-text-300 mt-1">
              {exercise.description}
            </Text>
            
            {exercise.stepByStep && (
              <View className="flex-row items-center mt-2 bg-secondary-50/20 self-start rounded-full px-2 py-1">
                <SolarIcon name="BookMinimalistic" type="linear" size={12} color="#4e49b6" />
                <Text className="text-xs text-secondary-500 ml-1">
                  Step-by-step guidance
                </Text>
              </View>
            )}
          </View>
          
          <View className="items-end">
            <View className="bg-primary-50/20 rounded-full px-2 py-1">
              <Text className="text-xs text-primary-500">
                {exercise.region.split('-').map(word => 
                  word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
              </Text>
            </View>
            <View className="flex-row items-center mt-2">
              <SolarIcon name="ClockCircle" type="linear" size={14} color="#8fa8d6" />
              <Text className="text-xs text-text-400 ml-1">
                {exercise.timeEstimate}
              </Text>
            </View>
          </View>
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
};

export default ExerciseCard;