import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';

export type Difficulty = 'beginner' | 'intermediate' | 'advanced';

interface DifficultySelectorProps {
  selectedDifficulty: Difficulty;
  onChange: (difficulty: Difficulty) => void;
}

const DifficultySelector = ({ selectedDifficulty, onChange }: DifficultySelectorProps) => {
  return (
    <View className="flex-row bg-background-50/10 p-1 rounded-lg">
      {(['beginner', 'intermediate', 'advanced'] as Difficulty[]).map((difficulty) => (
        <TouchableOpacity
          key={difficulty}
          onPress={() => onChange(difficulty)}
          className={`flex-1 py-3 rounded-md ${
            selectedDifficulty === difficulty 
              ? 'bg-primary-500' 
              : 'bg-transparent'
          }`}
        >
          <Text 
            className={`text-center font-chillax-medium text-sm ${
              selectedDifficulty === difficulty 
                ? 'text-white' 
                : 'text-text-300'
            }`}
          >
            {difficulty.charAt(0).toUpperCase() + difficulty.slice(1)}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
};

export default DifficultySelector;