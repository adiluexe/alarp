import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { SolarIcon } from 'react-native-solar-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';
import { LinearIconName } from 'react-native-solar-icons/dist/icons';

export interface BodyRegion {
  id: string;
  name: string;
  description: string;
  exercises: number;
  icon: LinearIconName;
}

interface BodyRegionCardProps {
  region: BodyRegion;
  isSelected: boolean;
  index: number;
  onPress: (regionId: string) => void;
}

const BodyRegionCard = ({ region, isSelected, index, onPress }: BodyRegionCardProps) => {
  return (
    <Animated.View
      entering={FadeInDown.delay(index * 50).duration(400)}
      className="w-[48%]"
    >
      <TouchableOpacity
        onPress={() => onPress(region.id)}
        className={`p-4 rounded-xl border ${
          isSelected 
            ? 'bg-primary-50/20 border-primary-200' 
            : 'bg-white border-gray-100'
        }`}
      >
        <View className="flex-row items-start">
          <View className={`p-2 rounded-lg mr-3 ${
            isSelected 
              ? 'bg-primary-100/30' 
              : 'bg-background-50/10'
          }`}>
            <SolarIcon 
              name={region.icon} 
              type="linear" 
              size={20} 
              color={isSelected ? "#4478bb" : "#294870"} 
            />
          </View>
          <View className="flex-1">
            <Text className={`text-sm font-chillax-medium ${
              isSelected ? 'text-primary-500' : 'text-text-200'
            }`}>
              {region.name}
            </Text>
            <View className="flex-row items-center mt-1">
              <SolarIcon name="NotebookMinimalistic" type="linear" size={12} color="#8fa8d6" />
              <Text className="text-xs text-text-400 ml-1">
                {region.exercises} exercises
              </Text>
            </View>
          </View>
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
};

export default BodyRegionCard;