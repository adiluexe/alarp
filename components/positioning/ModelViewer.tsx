import React, { useRef, useEffect, useState } from 'react';
import { View, PanResponder, GestureResponderEvent, TouchableOpacity, Text } from 'react-native';
import { GLView } from 'expo-gl';
import { Renderer, loadObjAsync, loadMtlAsync } from 'expo-three';
import * as THREE from 'three';
import { Asset } from 'expo-asset';
import { SolarIcon } from 'react-native-solar-icons';

type ModelViewerProps = {
  rotationX: number;
  setRotationX: (value: number) => void;
  rotationY: number;
  setRotationY: (value: number) => void;
  beamCenterX: number;
  setBeamCenterX: (value: number) => void;
  beamCenterY: number;
  setBeamCenterY: (value: number) => void;
  beamAngle: number;
  setBeamAngle: (value: number) => void;
};

// Define custom interface for expo-gl's WebGLRenderingContext with Expo's extensions
interface ExpoGLRenderingContext extends WebGLRenderingContext {
  endFrameEXP?: () => void;
}

export default function ModelViewer({ 
  rotationX, setRotationX,
  rotationY, setRotationY,
  beamCenterX, setBeamCenterX,
  beamCenterY, setBeamCenterY,
  beamAngle, setBeamAngle
}: ModelViewerProps) {
  const [renderer, setRenderer] = useState<Renderer | null>(null);
  const [scene] = useState(() => new THREE.Scene());
  const [camera] = useState(() => 
    // Create camera with better positioning for a top-down view
    new THREE.PerspectiveCamera(60, 1, 0.1, 1000)
  );
  
  // Track interaction mode
  const [interactionMode, setInteractionMode] = useState<'model' | 'beam'>('model');
  
  // Refs for animation
  const requestId = useRef<number | null>(null);
  const modelRef = useRef<THREE.Group | null>(null);
  const beamRef = useRef<THREE.Group | null>(null);
  
  // Track touch handling
  const lastTouchX = useRef(0);
  const lastTouchY = useRef(0);
  
  // Set up the PanResponder for touch interactions
  const panResponder = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onPanResponderGrant: (evt: GestureResponderEvent) => {
        // Store initial touch position
        lastTouchX.current = evt.nativeEvent.locationX;
        lastTouchY.current = evt.nativeEvent.locationY;
      },
      onPanResponderMove: (evt: GestureResponderEvent) => {
        const { locationX, locationY } = evt.nativeEvent;
        const deltaX = locationX - lastTouchX.current;
        const deltaY = locationY - lastTouchY.current;
        
        if (interactionMode === 'model') {
          // Adjust model rotation based on touch movement
          // Fix: Call setRotation with the new value directly, not a callback function
          setRotationY(rotationY + deltaX * 0.5);
          setRotationX(rotationX - deltaY * 0.5);
        } else {
          // Adjust beam position based on touch movement
          const newBeamX = Math.max(0, Math.min(100, beamCenterX + deltaX * 0.5));
          const newBeamY = Math.max(0, Math.min(100, beamCenterY + deltaY * 0.5));
          setBeamCenterX(newBeamX);
          setBeamCenterY(newBeamY);
        }
        
        // Update last touch position
        lastTouchX.current = locationX;
        lastTouchY.current = locationY;
      },
    })
  ).current;
  
  // Setup the scene once
  useEffect(() => {
    // Add lights
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(0, 5, 5); // Light from above and slightly in front
    scene.add(directionalLight);
    
    // Set camera position for better viewing angle
    camera.position.set(0, 0, 3);
    camera.lookAt(0, 0, 0);
    
    // Add a grid for reference - smaller and positioned properly
    const gridHelper = new THREE.GridHelper(1.5, 15, 0x888888, 0xcccccc);
    gridHelper.rotation.x = Math.PI / 2; // Rotate grid to be horizontal for top view
    scene.add(gridHelper);
    
    // Create beam indicator
    const beamGroup = new THREE.Group();
    
    // Beam center dot
    const dotGeometry = new THREE.SphereGeometry(0.03, 16, 16);
    const dotMaterial = new THREE.MeshBasicMaterial({ color: 0xffff00 });
    const dot = new THREE.Mesh(dotGeometry, dotMaterial);
    beamGroup.add(dot);
    
    // Beam ring
    const ringGeometry = new THREE.RingGeometry(0.05, 0.07, 32);
    const ringMaterial = new THREE.MeshBasicMaterial({ 
      color: 0xff0000,
      side: THREE.DoubleSide // Make visible from both sides
    });
    const ring = new THREE.Mesh(ringGeometry, ringMaterial);
    beamGroup.add(ring);
    
    // Beam line
    const lineGeometry = new THREE.CylinderGeometry(0.01, 0.01, 1, 8);
    const lineMaterial = new THREE.MeshBasicMaterial({ 
      color: 0xff0000,
      transparent: true,
      opacity: 0.6
    });
    const line = new THREE.Mesh(lineGeometry, lineMaterial);
    line.position.z = -0.5;
    line.rotation.x = Math.PI / 2;
    beamGroup.add(line);
    
    beamGroup.position.z = 0.01; // Slightly above the model to ensure visibility
    scene.add(beamGroup);
    beamRef.current = beamGroup;

    return () => {
      if (requestId.current) {
        cancelAnimationFrame(requestId.current);
      }
    };
  }, []);
  
  // Load the 3D model
  useEffect(() => {
    async function loadModel() {
      try {
        // Load MTL first
        const mtlAsset = Asset.fromModule(require('../../assets/models/skeletonarm.mtl'));
        await mtlAsset.downloadAsync();
        
        // Type assertion to make TypeScript happy with the onAssetRequested parameter
        const materialsParams = {
          asset: mtlAsset,
          onAssetRequested: (assetName: string) => {
            console.log('Requesting asset:', assetName);
            return null;
          }
        };
        
        const materials = await loadMtlAsync(materialsParams);
        materials.preload();
        
        // Then load OBJ with materials
        const objAsset = Asset.fromModule(require('../../assets/models/skeletonarm.obj'));
        await objAsset.downloadAsync();
        
        // Type assertion for loadObjAsync parameters
        const objParams = {
          asset: objAsset,
          materials,
          onAssetRequested: (assetName: string) => {
            console.log('Requesting asset:', assetName);
            return null;
          }
        };
        
        const object = await loadObjAsync(objParams);
        
        // Center and scale the model
        const box = new THREE.Box3().setFromObject(object);
        const center = box.getCenter(new THREE.Vector3());
        const size = box.getSize(new THREE.Vector3());
        
        const maxDim = Math.max(size.x, size.y, size.z);
        const scale = 0.8 / maxDim; // Slightly smaller scale to fit better in view
        
        // Center the model and position it in the center of the screen
        object.position.set(-center.x, -center.y, -center.z);
        object.scale.setScalar(scale);
        
        // Properly position and rotate the model to be visible in the center
        object.position.y = 0;
        
        // Set initial rotation - rotate to lie flat for top-down view but keep visible
        object.rotation.x = Math.PI / 2;
        object.rotation.z = Math.PI; // This helps orient the arm properly
        
        scene.add(object);
        modelRef.current = object;
      } catch (error) {
        console.error('Error loading model:', error);
      }
    }
    
    loadModel();
  }, []);
  
  // Handle context creation for GL View
  const onContextCreate = async (gl: ExpoGLRenderingContext) => {
    const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;
    
    // Create a new renderer
    const renderer = new Renderer({ gl });
    renderer.setSize(width, height);
    renderer.setClearColor(0xf0f0f0);
    setRenderer(renderer);
    
    // Set correct camera aspect ratio
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    
    // Start render loop
    const render = () => {
      if (modelRef.current) {
        // Apply rotation from controls - keep the X rotation offset to maintain visibility
        modelRef.current.rotation.x = Math.PI / 2 + THREE.MathUtils.degToRad(rotationX);
        modelRef.current.rotation.z = Math.PI + THREE.MathUtils.degToRad(rotationY);
      }
      
      if (beamRef.current) {
        // Convert from percentage (0-100) to position in scene
        const x = (beamCenterX / 50 - 1) * 0.75; // Scale to fit better
        const y = (1 - beamCenterY / 50) * 0.75; // Scale to fit better
        
        beamRef.current.position.x = x;
        beamRef.current.position.y = y;
        beamRef.current.rotation.z = THREE.MathUtils.degToRad(beamAngle);
      }
      
      renderer.render(scene, camera);
      
      // Safely call Expo's endFrameEXP method
      if (gl.endFrameEXP) {
        gl.endFrameEXP();
      }
      
      requestId.current = requestAnimationFrame(render);
    };
    
    render();
  };
  
  // Toggle between model and beam control modes
  const toggleInteractionMode = () => {
    setInteractionMode(prevMode => prevMode === 'model' ? 'beam' : 'model');
  };
  
  return (
    <View className="flex-1 bg-background-950 relative">
      <View className="absolute top-4 right-4 z-10 bg-white/80 rounded-full px-3 py-1.5">
        <Text className="text-xs font-satoshi-medium text-primary-500">
          {interactionMode === 'model' ? 'Model Control' : 'Beam Control'}
        </Text>
      </View>
      
      <TouchableOpacity 
        className="absolute bottom-4 right-4 z-10 bg-primary-500 rounded-full p-3"
        onPress={toggleInteractionMode}
      >
        <SolarIcon 
          name={interactionMode === 'model' ? 'Minimize' : 'Target'} 
          type="linear" 
          size={24} 
          color="white" 
        />
      </TouchableOpacity>
      
      <View 
        className="flex-1" 
        {...panResponder.panHandlers}
      >
        <GLView className="flex-1" onContextCreate={onContextCreate} />
      </View>
    </View>
  );
}