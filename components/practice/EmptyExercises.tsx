import React from 'react';
import { View, Text } from 'react-native';
import { SolarIcon } from 'react-native-solar-icons';

interface EmptyExercisesProps {
  selectedRegion: string | null;
  selectedDifficulty: string;
  bodyRegions: Array<{ id: string; name: string }>;
}

const EmptyExercises = ({ selectedRegion, selectedDifficulty, bodyRegions }: EmptyExercisesProps) => {
  return (
    <View className="items-center justify-center py-8">
      <SolarIcon name="Magnifer" type="linear" size={40} color="#b4c5e4" />
      <Text className="text-text-400 mt-4 text-center font-satoshi">
        {selectedRegion 
          ? `No ${selectedDifficulty} exercises available for ${bodyRegions.find(r => r.id === selectedRegion)?.name || ''}` 
          : `No exercises available for ${selectedDifficulty} level`}
      </Text>
    </View>
  );
};

export default EmptyExercises;