import React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import Slider from '@react-native-community/slider';
import { SolarIcon } from 'react-native-solar-icons';

type PositioningControlsProps = {
  rotationX: number;
  setRotationX: (value: number) => void;
  rotationY: number;
  setRotationY: (value: number) => void;
  rotationZ: number;
  setRotationZ: (value: number) => void;
  beamCenterX: number;
  setBeamCenterX: (value: number) => void;
  beamCenterY: number;
  setBeamCenterY: (value: number) => void;
  beamAngle: number;
  setBeamAngle: (value: number) => void;
  viewType: string;
  setViewType: (value: string) => void;
  handleCheckPosition: () => void;
};

const PositioningControls = ({
  rotationX,
  setRotationX,
  rotationY,
  setRotationY,
  rotationZ,
  setRotationZ,
  beamCenterX,
  setBeamCenterX,
  beamCenterY,
  setBeamCenterY,
  beamAngle,
  setBeamAngle,
  viewType,
  setViewType,
  handleCheckPosition
}: PositioningControlsProps) => {
  // Reset all controls to default values
  const handleReset = () => {
    setRotationX(0);
    setRotationY(0);
    setRotationZ(0);
    setBeamAngle(0);
    setBeamCenterX(50);
    setBeamCenterY(50);
  };

  // Center the beam
  const handleCenterBeam = () => {
    setBeamCenterX(50);
    setBeamCenterY(50);
  };

  return (
    <ScrollView 
      className="flex-1" 
      showsVerticalScrollIndicator={true} 
      bounces={true}
      contentContainerStyle={{ paddingBottom: 20 }}  // Add padding at bottom
    >
      <View className="py-2 space-y-2.5">
        {/* View Selection */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Standard Views
          </Text>
          <View className="flex-row flex-wrap justify-between">
            <TouchableOpacity 
              className={`py-2 px-3 rounded-md mb-2 ${viewType === 'anterior' ? 'bg-primary-500' : 'bg-white border border-background-200/20'}`}
              onPress={() => {
                setViewType('anterior');
                setRotationX(0);
                setRotationY(0);
                setRotationZ(0);
                setBeamCenterX(50);
                setBeamCenterY(50);
                setBeamAngle(0);
              }}
            >
              <Text className={`text-xs font-satoshi-medium ${viewType === 'anterior' ? 'text-white' : 'text-text-400'}`}>
                Anterior
              </Text>
            </TouchableOpacity>
            
            <TouchableOpacity 
              className={`py-2 px-3 rounded-md mb-2 ${viewType === 'posterior' ? 'bg-primary-500' : 'bg-white border border-background-200/20'}`}
              onPress={() => {
                setViewType('posterior');
                setRotationX(0);
                setRotationY(0);
                setRotationZ(0);
                setBeamCenterX(50);
                setBeamCenterY(50);
                setBeamAngle(0);
              }}
            >
              <Text className={`text-xs font-satoshi-medium ${viewType === 'posterior' ? 'text-white' : 'text-text-400'}`}>
                Posterior
              </Text>
            </TouchableOpacity>

            <TouchableOpacity 
              className={`py-2 px-3 rounded-md mb-2 ${viewType === 'lateral' ? 'bg-primary-500' : 'bg-white border border-background-200/20'}`}
              onPress={() => {
                setViewType('lateral');
                setRotationX(0);
                setRotationY(0);
                setRotationZ(0);
                setBeamCenterX(50);
                setBeamCenterY(50);
                setBeamAngle(0);
              }}
            >
              <Text className={`text-xs font-satoshi-medium ${viewType === 'lateral' ? 'text-white' : 'text-text-400'}`}>
                Lateral
              </Text>
            </TouchableOpacity>

            <TouchableOpacity 
              className={`py-2 px-3 rounded-md mb-2 ${viewType === 'oblique' ? 'bg-primary-500' : 'bg-white border border-background-200/20'}`}
              onPress={() => {
                setViewType('oblique');
                setRotationX(0);
                setRotationY(0);
                setRotationZ(0);
                setBeamCenterX(50);
                setBeamCenterY(50);
                setBeamAngle(0);
              }}
            >
              <Text className={`text-xs font-satoshi-medium ${viewType === 'oblique' ? 'text-white' : 'text-text-400'}`}>
                Oblique
              </Text>
            </TouchableOpacity>
          </View>
        </View>
        
        {/* Patient Rotation X */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Patient Rotation X-Axis: {rotationX}°
          </Text>
          <Slider
            value={rotationX}
            minimumValue={-45}
            maximumValue={45}
            step={1}
            onValueChange={setRotationX}
            minimumTrackTintColor="#4478bb"
            maximumTrackTintColor="#e0e0e0"
            thumbTintColor="#4478bb"
            style={{ height: 40 }}
          />
        </View>
        
        {/* Patient Rotation Y */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Patient Rotation Y-Axis: {rotationY}°
          </Text>
          <Slider
            value={rotationY}
            minimumValue={-45}
            maximumValue={45}
            step={1}
            onValueChange={setRotationY}
            minimumTrackTintColor="#4478bb"
            maximumTrackTintColor="#e0e0e0"
            thumbTintColor="#4478bb"
            style={{ height: 40 }}
          />
        </View>

        {/* Patient Rotation Z */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Patient Rotation Z-Axis (Roll): {rotationZ}°
          </Text>
          <Slider
            value={rotationZ}
            minimumValue={-180}
            maximumValue={180}
            step={1}
            onValueChange={setRotationZ}
            minimumTrackTintColor="#4478bb"
            maximumTrackTintColor="#e0e0e0"
            thumbTintColor="#4478bb"
            style={{ height: 40 }}
          />
        </View>
        
        {/* Beam Angle */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Beam Angle: {beamAngle}°
          </Text>
          <Slider
            value={beamAngle}
            minimumValue={-90}
            maximumValue={90}
            step={1}
            onValueChange={setBeamAngle}
            minimumTrackTintColor="#4478bb"
            maximumTrackTintColor="#e0e0e0"
            thumbTintColor="#4478bb"
            style={{ height: 40 }}
          />
        </View>
        
        {/* Beam Centering */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Beam Centering
          </Text>
          <View className="space-y-3">
            <View>
              <Text className="text-xs text-text-300 mb-1">
                Horizontal: {beamCenterX}%
              </Text>
              <Slider
                value={beamCenterX}
                minimumValue={0}
                maximumValue={100}
                step={1}
                onValueChange={setBeamCenterX}
                minimumTrackTintColor="#4478bb"
                maximumTrackTintColor="#e0e0e0"
                thumbTintColor="#4478bb"
                style={{ height: 40 }}
              />
            </View>
            
            <View>
              <Text className="text-xs text-text-300 mb-1">
                Vertical: {beamCenterY}%
              </Text>
              <Slider
                value={beamCenterY}
                minimumValue={0}
                maximumValue={100}
                step={1}
                onValueChange={setBeamCenterY}
                minimumTrackTintColor="#4478bb"
                maximumTrackTintColor="#e0e0e0"
                thumbTintColor="#4478bb"
                style={{ height: 40 }}
              />
            </View>
          </View>
        </View>
        
        {/* Quick Actions */}
        <View className="mb-3">
          <Text className="text-xs font-satoshi-medium text-text-400 mb-2">
            Quick Actions
          </Text>
          <View className="flex-row justify-between space-x-3">
            <TouchableOpacity 
              className="flex-1 bg-primary-500 py-2.5 rounded-md flex-row items-center justify-center"
              onPress={handleReset}
            >
              <SolarIcon 
                name="Restart"
                type="linear" 
                size={16} 
                color="white" 
                
              />
              <Text className="text-white font-satoshi-medium text-sm">Reset All</Text>
            </TouchableOpacity>
            
            <TouchableOpacity 
              className="flex-1 bg-white border border-background-200/20 py-2.5 rounded-md flex-row items-center justify-center"
              onPress={handleCenterBeam}
            >
              <SolarIcon 
                name="Target" 
                type="linear" 
                size={16} 
                color="#4a4a4a"
                
              />
              <Text className="text-text-300 font-satoshi-medium text-sm">Center Beam</Text>
            </TouchableOpacity>
          </View>
        </View>
        
        {/* Check Position Button */}
        <TouchableOpacity 
          className="bg-primary-500 py-3.5 rounded-lg items-center mt-2"
          onPress={handleCheckPosition}
        >
          <Text className="text-white font-satoshi-medium text-base">
            Check Positioning
          </Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

export default PositioningControls;