import React, { useState, useEffect } from "react";
import { View, Text, SafeAreaView, ScrollView } from "react-native";
import { router } from "expo-router";
import { LinearIconName } from "react-native-solar-icons/dist/icons";

// Import components
import DifficultySelector, {
  Difficulty,
} from "../../components/practice/DifficultySelector";
import BodyRegionCard, {
  BodyRegion,
} from "../../components/practice/BodyRegionCard";
import ExerciseCard, { Exercise } from "../../components/practice/ExerciseCard";
import EmptyExercises from "../../components/practice/EmptyExercises";

// Mock data for body regions
const bodyRegions: BodyRegion[] = [
  {
    id: "chest",
    name: "Chest",
    description: "Practice positioning for chest radiography",
    exercises: 4,
    icon: "BookMinimalistic" as LinearIconName,
  },
  {
    id: "upper-extremities",
    name: "Upper Extremities",
    description:
      "Hand, wrist, forearm, elbow, humerus and shoulder positioning",
    exercises: 8,
    icon: "BookMinimalistic" as LinearIconName,
  },
  {
    id: "lower-extremities",
    name: "Lower Extremities",
    description: "Foot, ankle, lower leg, knee, femur and hip positioning",
    exercises: 6,
    icon: "BookMinimalistic" as LinearIconName,
  },
  {
    id: "skull",
    name: "Skull",
    description: "Practice positioning for skull radiography",
    exercises: 5,
    icon: "BookMinimalistic" as LinearIconName,
  },
  {
    id: "spine",
    name: "Spine",
    description: "Cervical, thoracic and lumbar spine positioning",
    exercises: 7,
    icon: "BookMinimalistic" as LinearIconName,
  },
];

// Mock data for practice exercises
const exercises = [
  {
    id: "chest-pa",
    title: "Chest PA",
    description: "Practice proper positioning for PA chest radiographs.",
    region: "chest",
    difficulty: "beginner",
    lastPracticed: "2 days ago",
    timeEstimate: "5 mins",
    stepByStep: true,
  },
  {
    id: "chest-lateral",
    title: "Chest Lateral",
    description: "Practice lateral positioning for chest radiographs.",
    region: "chest",
    difficulty: "beginner",
    lastPracticed: "5 days ago",
    timeEstimate: "5 mins",
    stepByStep: true,
  },
  {
    id: "hand-pa",
    title: "Hand PA",
    description:
      "Practice proper hand positioning for clear metacarpal visualization.",
    region: "upper-extremities",
    difficulty: "beginner",
    lastPracticed: null,
    timeEstimate: "3 mins",
    stepByStep: true,
  },
  {
    id: "knee-ap",
    title: "Knee AP",
    description: "Practice AP knee positioning with correct centering.",
    region: "lower-extremities",
    difficulty: "intermediate",
    lastPracticed: "1 week ago",
    timeEstimate: "6 mins",
    stepByStep: false,
  },
  {
    id: "c-spine",
    title: "Cervical Spine",
    description: "Practice C-spine positioning with proper alignment.",
    region: "spine",
    difficulty: "advanced",
    lastPracticed: null,
    timeEstimate: "8 mins",
    stepByStep: false,
  },
  {
    id: "skull-lateral",
    title: "Skull Lateral",
    description: "Practice lateral skull positioning techniques.",
    region: "skull",
    difficulty: "advanced",
    lastPracticed: "3 days ago",
    timeEstimate: "7 mins",
    stepByStep: false,
  },
];

const Practice = () => {
  const [selectedDifficulty, setSelectedDifficulty] =
    useState<Difficulty>("beginner");
  const [selectedRegion, setSelectedRegion] = useState<string | null>(null);
  const [recentlyPracticed, setRecentlyPracticed] = useState<Exercise[]>([]);

  useEffect(() => {
    // Filter recently practiced exercises
    const recent = exercises
      .filter((ex) => ex.lastPracticed !== null)
      .sort((a, b) => {
        if (!a.lastPracticed) return 1;
        if (!b.lastPracticed) return -1;
        return a.lastPracticed.localeCompare(b.lastPracticed);
      })
      .slice(0, 3);

    setRecentlyPracticed(recent);
  }, []);

  const filteredExercises = exercises.filter(
    (exercise) =>
      exercise.difficulty === selectedDifficulty &&
      (selectedRegion ? exercise.region === selectedRegion : true)
  );

  const handleExerciseClick = (exerciseId: string) => {
    // Will be implemented later with router.push
    console.log(`Navigate to exercise: ${exerciseId}`);
  };

  const handleRegionClick = (regionId: string) => {
    setSelectedRegion(regionId === selectedRegion ? null : regionId);
  };

  return (
    <SafeAreaView className="flex-1 bg-white">
      <ScrollView className="flex-1 px-6">
        <View className="mt-12 mb-6">
          <Text className="text-4xl text-primary-500 font-chillax-bold mb-2">
            Practice
          </Text>
          <Text className="text-text-300 font-satoshi leading-relaxed">
            Apply radiographic positioning techniques in a structured
            environment with real-time feedback.
          </Text>
        </View>

        {/* Difficulty Level Selection */}
        <View className="mb-6">
          <Text className="text-sm font-satoshi-medium text-text-300 mb-3">
            Difficulty Level
          </Text>
          <DifficultySelector
            selectedDifficulty={selectedDifficulty}
            onChange={setSelectedDifficulty}
          />
        </View>

        {/* Body Region Selection */}
        <View className="mb-8">
          <Text className="text-sm font-satoshi-medium text-text-300 mb-4">
            Body Regions
          </Text>
          <View>
            {bodyRegions.map((region, index) => (
              <BodyRegionCard
                key={region.id}
                region={region}
                index={index}
                isSelected={selectedRegion === region.id}
                onPress={handleRegionClick}
              />
            ))}
          </View>
        </View>

        {/* Recently Practiced */}
        {recentlyPracticed.length > 0 && (
          <View className="mb-6">
            <Text className="text-sm font-satoshi-medium text-text-300 mb-3">
              Recently Practiced
            </Text>
            <View className="space-y-3">
              {recentlyPracticed.map((exercise, index) => (
                <ExerciseCard
                  key={exercise.id}
                  exercise={exercise}
                  index={index}
                  onPress={handleExerciseClick}
                  compact={true}
                />
              ))}
            </View>
          </View>
        )}

        {/* Exercise List */}
        <View className="mb-10">
          <Text className="text-sm font-satoshi-medium text-text-300 mb-3">
            {selectedRegion
              ? `${
                  bodyRegions.find((r) => r.id === selectedRegion)?.name || ""
                } Exercises`
              : `${
                  selectedDifficulty.charAt(0).toUpperCase() +
                  selectedDifficulty.slice(1)
                } Exercises`}
          </Text>

          {filteredExercises.length > 0 ? (
            <View className="space-y-4">
              {filteredExercises.map((exercise, index) => (
                <ExerciseCard
                  key={exercise.id}
                  exercise={exercise}
                  index={index}
                  onPress={handleExerciseClick}
                />
              ))}
            </View>
          ) : (
            <EmptyExercises
              selectedRegion={selectedRegion}
              selectedDifficulty={selectedDifficulty}
              bodyRegions={bodyRegions}
            />
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default Practice;
