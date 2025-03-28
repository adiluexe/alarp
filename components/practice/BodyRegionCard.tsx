import React from 'react';
import { View, Text, TouchableOpacity, Dimensions } from 'react-native';
import { SolarIcon } from 'react-native-solar-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';
import { LinearIconName } from 'react-native-solar-icons/dist/icons';

// Full width for list layout with proper padding
const screenWidth = Dimensions.get('window').width;
const cardWidth = screenWidth - 32; // Full width minus padding

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
      entering={FadeInDown.delay(index * 50).duration(300)}
      style={{ width: cardWidth }}
      className="mb-3"
    >
      <TouchableOpacity
        onPress={() => onPress(region.id)}
        activeOpacity={0.7}
        style={{ 
          borderWidth: isSelected ? 2 : 1,
          borderColor: isSelected ? '#497fb6' : '#e5e7eb', // Using primary-500 color and a light gray
        }}
        className={`p-4 rounded-xl bg-white shadow-sm`}
      >
        <View className="flex-row items-start">
          {/* Icon on the left */}
          <View className="w-10 h-10 mr-3 items-center justify-center bg-primary-400 rounded-lg overflow-hidden">
            <SolarIcon 
              name={region.icon} 
              type="linear" 
              size={22} 
              color="#ffffff" 
            />
          </View>
          
          {/* Content on the right */}
          <View className="flex-1">
            {/* Title and description */}
            <View>
              <Text 
                className="text-text-950 text-base font-chillax-semibold"
                numberOfLines={1}
              >
                {region.name}
              </Text>
              
              <Text 
                numberOfLines={2}
                className="text-text-400 text-xs font-satoshi mt-1"
              >
                {region.description}
              </Text>
            </View>
            
            {/* Exercise count at bottom */}
            <View className="flex-row items-center mt-2">
              <SolarIcon 
                name="NotebookMinimalistic" 
                type="linear" 
                size={12} 
                color="#365896" 
              />
              <Text className="text-text-400 text-xs ml-2 font-satoshi">
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