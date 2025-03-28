import { Link } from "expo-router";
import { Text, View, ScrollView, TouchableOpacity, SafeAreaView } from "react-native";
import { SolarIcon } from 'react-native-solar-icons';
import { BoldIconName } from "react-native-solar-icons/dist/icons";

export default function Index() {
  // Define the card types with proper typing
  type NavigationCard = {
    title: string;
    description: string;
    icon: BoldIconName; // Use the correct type for SolarIcon's name prop
    path: "/learn" | "/practice" | "/challenge"; // Explicitly define allowed path values
    color: string;
  };

  const navigationCards: NavigationCard[] = [
    {
      title: "Learn",
      description: "Access educational modules for different body regions",
      icon: "NotebookMinimalistic",
      path: "/learn",
      color: "bg-primary-500",
    },
    {
      title: "Practice",
      description: "Apply radiographic positioning techniques in a structured environment",
      icon: "Target",
      path: "/practice",
      color: "bg-secondary-500",
    },
    {
      title: "Challenge",
      description: "Test your skills with gamified assessments",
      icon: "Cup",
      path: "/challenge", 
      color: "bg-accent-500",
    },
  ];

  return (
    <SafeAreaView className="flex-1 bg-white">
      <ScrollView className="flex-1 px-6">
        <View className="mt-12 mb-8">
          <Text className="text-5xl text-primary-500 font-chillax-bold mb-2">ALARP</Text>
          <Text className="text-text-200 text-lg font-satoshi-medium mt-1 mb-4">
            Master radiographic positioning techniques through interactive simulations
          </Text>
          <Text className="text-text-300 font-satoshi leading-relaxed">
            ALARP helps radiography students practice and perfect positioning techniques in a safe, 
            virtual environment. Choose from the options below to start your learning journey.
          </Text>
        </View>
        
        <View className="space-y-5 mb-10 gap-5">
          {navigationCards.map((card, index) => (
            <Link key={index} href={card.path} asChild>
              <TouchableOpacity 
                activeOpacity={0.7}
                className={`${card.color} rounded-2xl p-5 flex-row items-center shadow-sm`}
              >
                <View className="bg-white/20 rounded-xl p-3 mr-4">
                  <SolarIcon 
                    name={card.icon} 
                    type="bold" 
                    size={28} 
                    color="white" 
                  />
                </View>
                <View className="flex-1">
                  <Text className="text-white font-chillax-bold text-xl mb-1">
                    {card.title}
                  </Text>
                  <Text className="text-white/90 font-satoshi text-sm">
                    {card.description}
                  </Text>
                </View>
                <SolarIcon 
                  name="ArrowRight"
                  type="linear" 
                  size={22} 
                  color="white" 
                />
              </TouchableOpacity>
            </Link>
          ))}
        </View>
        
        <View className="bg-background-50/5 border border-background-200/20 rounded-xl p-5 mb-8">
          <View className="flex-row items-center mb-3">
            <SolarIcon name="InfoSquare" type="linear" size={20} color="#365896" />
            <Text className="text-text-400 font-chillax-medium ml-2 text-base">
              What is ALARP?
            </Text>
          </View>
          <Text className="text-text-300 font-satoshi leading-relaxed">
            ALARP (As Low As Reasonably Practicable) is a principle that aims to minimize radiation 
            exposure during medical imaging. This app helps you practice proper positioning techniques 
            to ensure optimal image quality while maintaining patient safety.
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
