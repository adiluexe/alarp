import React from 'react';
import { View, Text, ScrollView } from 'react-native';
import { SolarIcon } from 'react-native-solar-icons';

type PositioningGuideProps = {
  viewType: string;
};

const PositioningGuide = ({ viewType }: PositioningGuideProps) => {
  // Adjust guide content based on the selected view type
  const getGuideContent = () => {
    switch (viewType) {
      case 'anterior':
        return {
          title: 'Anterior Positioning',
          description: 'For this view, ensure the patient is standing upright with their back against the image receptor. Center the beam at the level of the humerus.',
          keyPoints: [
            'Arms positioned symmetrically',
            'Wrist and hand in neutral position',
            'Elbow extended fully',
            'Proper arm extension and rotation'
          ],
        };
      case 'posterior':
        return {
          title: 'Posterior Positioning',
          description: 'Position the patient facing the image receptor. Center the beam at the level of the humerus.',
          keyPoints: [
            'Arms positioned symmetrically',
            'Wrist and hand in neutral position',
            'Elbow extended fully',
            'Proper arm extension and rotation'
          ],
        };
      case 'lateral':
        return {
          title: 'Lateral Positioning',
          description: 'Position the patient with the lateral aspect of the arm against the image receptor. Center the beam at the mid-humerus.',
          keyPoints: [
            'Arm positioned with lateral aspect against receptor',
            'Elbow joint at 90 degrees',
            'Shoulder and hand aligned properly',
            'Proper rotation of the humerus'
          ],
        };
      case 'oblique':
        return {
          title: 'Oblique Positioning',
          description: 'Position the patient with the arm at a 45-degree angle to the image receptor. Center the beam to include the full humerus.',
          keyPoints: [
            'Arm rotated 45 degrees',
            'Elbow slightly flexed',
            'Hand in natural position',
            'Include entire humerus in the field'
          ],
        };
      default:
        return {
          title: 'Standard Positioning',
          description: 'Select a view type for specific positioning guidance.',
          keyPoints: [
            'Position patient comfortably',
            'Center beam to the region of interest',
            'Ensure proper alignment',
            'Provide clear instructions to the patient'
          ],
        };
    }
  };

  const guideContent = getGuideContent();

  return (
    <ScrollView className="flex-1">
      <View className="bg-primary-900/50 rounded-lg p-3 mb-3">
        <Text className="text-sm font-chillax-medium text-primary-500 mb-1">
          {guideContent.title}
        </Text>
        <Text className="text-xs text-text-300 font-satoshi">
          {guideContent.description}
        </Text>
      </View>
      
      <View className="mb-3">
        <Text className="text-sm font-chillax-medium text-text-400 mb-1.5">
          Key Points
        </Text>
        {guideContent.keyPoints.map((point, index) => (
          <View key={index} className="flex-row items-start mb-1.5">
            <View className="w-4 h-4 rounded-full bg-primary-500 justify-center items-center mr-2 mt-0.5">
              <Text className="text-white text-[10px] font-satoshi-medium">
                {index + 1}
              </Text>
            </View>
            <Text className="text-xs text-text-300 font-satoshi flex-1">
              {point}
            </Text>
          </View>
        ))}
      </View>
      
      <View>
        <Text className="text-sm font-chillax-medium text-text-400 mb-1.5">
          ALARP Principle
        </Text>
        <Text className="text-xs text-text-300 font-satoshi">
          Remember to keep radiation exposure As Low As Reasonably Practicable (ALARP):
        </Text>
        <View className="mt-1">
          <View className="flex-row items-start mb-1">
            <Text className="text-primary-500 mr-1 text-xs">•</Text>
            <Text className="text-xs text-text-300 font-satoshi flex-1">
              Precise positioning reduces repeat exposures
            </Text>
          </View>
          <View className="flex-row items-start mb-1">
            <Text className="text-primary-500 mr-1 text-xs">•</Text>
            <Text className="text-xs text-text-300 font-satoshi flex-1">
              Proper collimation to limit beam area
            </Text>
          </View>
          <View className="flex-row items-start">
            <Text className="text-primary-500 mr-1 text-xs">•</Text>
            <Text className="text-xs text-text-300 font-satoshi flex-1">
              Correct exposure factors for patient size
            </Text>
          </View>
        </View>
      </View>
    </ScrollView>
  );
};

export default PositioningGuide;