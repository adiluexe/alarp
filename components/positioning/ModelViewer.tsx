import React, { useRef, useEffect, useState, useCallback } from 'react';
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
  rotationZ: number;
  setRotationZ: (value: number) => void;
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
  rotationZ, setRotationZ,
  beamCenterX, setBeamCenterX,
  beamCenterY, setBeamCenterY,
  beamAngle, setBeamAngle
}: ModelViewerProps) {
  const [renderer, setRenderer] = useState<Renderer | null>(null);
  const [scene] = useState(() => new THREE.Scene());
  const [camera] = useState(() => 
    // Adjust camera FOV and positioning for better view
    new THREE.PerspectiveCamera(55, 1, 0.1, 1000)
  );
  
  // Track interaction mode
  const [interactionMode, setInteractionMode] = useState<'model' | 'beam'>('model');
  
  // Refs for animation
  const requestId = useRef<number | null>(null);
  const modelRef = useRef<THREE.Group | null>(null);
  const beamRef = useRef<THREE.Group | null>(null);
  const glRef = useRef<ExpoGLRenderingContext | null>(null);
  
  // Track touch handling
  const lastTouchX = useRef(0);
  const lastTouchY = useRef(0);
  
  // Set up the PanResponder for touch interactions
  const panResponder = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onPanResponderGrant: (evt: GestureResponderEvent) => {
        lastTouchX.current = evt.nativeEvent.locationX;
        lastTouchY.current = evt.nativeEvent.locationY;
      },
      onPanResponderMove: (evt: GestureResponderEvent) => {
        const { locationX, locationY } = evt.nativeEvent;
        const deltaX = locationX - lastTouchX.current;
        const deltaY = locationY - lastTouchY.current;
        
        if (interactionMode === 'model') {
          // For model rotation, use two fingers (check touches length)
          if (evt.nativeEvent.touches.length > 1) {
            // Two finger gesture - use for Z-axis rotation
            setRotationZ(rotationZ + deltaX * 0.5);
          } else {
            // Single finger gesture - use for X and Y rotation
            setRotationY(rotationY + deltaX * 0.5);
            setRotationX(rotationX - deltaY * 0.5);
          }
        } else {
          // Beam positioning - more sensitive for precise control
          const newBeamX = Math.max(0, Math.min(100, beamCenterX + deltaX * 0.3));
          const newBeamY = Math.max(0, Math.min(100, beamCenterY + deltaY * 0.3));
          setBeamCenterX(newBeamX);
          setBeamCenterY(newBeamY);
        }
        
        lastTouchX.current = locationX;
        lastTouchY.current = locationY;
      },
    })
  ).current;
  
  // Setup the scene once
  useEffect(() => {
    // Add lights
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.7);
    scene.add(ambientLight);
    
    // Add strong directional light from top for better visibility
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(0, 5, 2);
    scene.add(directionalLight);
    
    // Add a softer fill light from the side
    const fillLight = new THREE.DirectionalLight(0xffffff, 0.5);
    fillLight.position.set(2, 2, 5);
    scene.add(fillLight);
    
    // Set camera position for a better view - higher up and angled down
    camera.position.set(0, 0, 2.5); // Closer to the model (zoom effect)
    camera.lookAt(0, 0, 0);
    
    // Add a grid for reference - smaller and positioned properly
    const gridHelper = new THREE.GridHelper(1.5, 15, 0x888888, 0xcccccc);
    gridHelper.rotation.x = Math.PI / 2; // Rotate grid to be horizontal for top view
    gridHelper.position.y = -0.3; // Move grid down slightly
    scene.add(gridHelper);
    
    // Create beam indicator - make it more visible
    const beamGroup = new THREE.Group();
    
    // Beam center dot
    const dotGeometry = new THREE.SphereGeometry(0.04, 16, 16);
    const dotMaterial = new THREE.MeshBasicMaterial({ color: 0xffff00 });
    const dot = new THREE.Mesh(dotGeometry, dotMaterial);
    beamGroup.add(dot);
    
    // Beam ring
    const ringGeometry = new THREE.RingGeometry(0.06, 0.08, 32);
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
      opacity: 0.7
    });
    const line = new THREE.Mesh(lineGeometry, lineMaterial);
    line.position.z = -0.5;
    line.rotation.x = Math.PI / 2;
    beamGroup.add(line);
    
    beamGroup.position.z = 0.03; // Place slightly above the model
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
        
        // Scale the model larger for better visibility (zoom in)
        const scale = 1.2 / maxDim;
        
        // Center the model properly
        object.position.set(-center.x, -center.y, -center.z);
        object.scale.setScalar(scale);
        
        // Initial positioning for forearm
        object.rotation.x = Math.PI / 2; // Put it flat (bird's eye view)
        
        // Apply a small initial Y rotation to show the forearm better
        object.rotation.y = 0;
        
        // Raise the model so it's above the grid
        object.position.y = 0;
        
        scene.add(object);
        modelRef.current = object;
      } catch (error) {
        console.error('Error loading model:', error);
      }
    }
    
    loadModel();
  }, []);
  
  // Create a render function that depends on state values
  const render = useCallback(() => {
    if (!renderer || !glRef.current) return;
    
    if (modelRef.current) {
      // Reset the rotation to avoid cumulative effects
      modelRef.current.rotation.set(0, 0, 0);
      
      // Apply all rotations in sequence for correct orientation
      // Important: Order matters for rotations
      
      // First make it flat (this establishes our primary viewing plane)
      modelRef.current.rotateX(Math.PI / 2);
      
      // Apply X rotation (tilt forward/backward)
      modelRef.current.rotateY(THREE.MathUtils.degToRad(rotationX));
      
      // Apply Y rotation (rotate left/right on the horizontal plane)
      modelRef.current.rotateZ(THREE.MathUtils.degToRad(rotationY));
      
      // Apply Z rotation (roll around the main axis)
      modelRef.current.rotateX(THREE.MathUtils.degToRad(rotationZ));
    }
    
    if (beamRef.current) {
      // Convert from percentage (0-100) to position in scene
      // Scale down the movement range to fit model better
      const x = (beamCenterX / 50 - 1) * 0.6;
      const y = (1 - beamCenterY / 50) * 0.6;
      
      beamRef.current.position.x = x;
      beamRef.current.position.y = y;
      beamRef.current.rotation.z = THREE.MathUtils.degToRad(beamAngle);
    }
    
    renderer.render(scene, camera);
    
    // Safely call Expo's endFrameEXP method
    if (glRef.current.endFrameEXP) {
      glRef.current.endFrameEXP();
    }
  }, [renderer, rotationX, rotationY, rotationZ, beamCenterX, beamCenterY, beamAngle]);
  
  // Set up the animation loop
  useEffect(() => {
    if (!renderer) return;
    
    const animate = () => {
      render();
      requestId.current = requestAnimationFrame(animate);
    };
    
    requestId.current = requestAnimationFrame(animate);
    
    return () => {
      if (requestId.current) {
        cancelAnimationFrame(requestId.current);
      }
    };
  }, [renderer, render]);
  
  // Handle context creation for GL View
  const onContextCreate = (gl: ExpoGLRenderingContext) => {
    glRef.current = gl;
    const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;
    
    // Create a new renderer
    const renderer = new Renderer({ gl });
    renderer.setSize(width, height);
    renderer.setClearColor(0xf0f0f0);
    setRenderer(renderer);
    
    // Set correct camera aspect ratio
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  };
  
  // Toggle between model and beam control modes
  const toggleInteractionMode = () => {
    setInteractionMode(prevMode => prevMode === 'model' ? 'beam' : 'model');
  };
  
  return (
    <View className="flex-1 bg-background-950 relative">
      <View className="absolute top-4 right-4 z-10 bg-white/90 rounded-full px-3 py-1.5">
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