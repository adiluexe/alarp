import React, { useRef, useEffect, useState } from 'react';
import { View } from 'react-native';
import { GLView } from 'expo-gl';
import { Renderer, loadObjAsync, loadMtlAsync } from 'expo-three';
import * as THREE from 'three';
import { Asset } from 'expo-asset';

type ModelViewerProps = {
  rotationX: number;
  rotationY: number;
  beamCenterX: number;
  beamCenterY: number;
  beamAngle: number;
};

// Define custom interface for expo-gl's WebGLRenderingContext with Expo's extensions
interface ExpoGLRenderingContext extends WebGLRenderingContext {
  endFrameEXP?: () => void;
}

export default function ModelViewer({ 
  rotationX, 
  rotationY, 
  beamCenterX, 
  beamCenterY, 
  beamAngle 
}: ModelViewerProps) {
  const [renderer, setRenderer] = useState<Renderer | null>(null);
  const [scene] = useState(() => new THREE.Scene());
  const [camera] = useState(() => 
    new THREE.PerspectiveCamera(75, 1, 0.1, 1000)
  );
  
  // Refs for animation
  const requestId = useRef<number | null>(null);
  const modelRef = useRef<THREE.Group | null>(null);
  const beamRef = useRef<THREE.Group | null>(null);
  
  // Setup the scene once
  useEffect(() => {
    // Add lights
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(1, 1, 1);
    scene.add(directionalLight);
    
    // Set camera position
    camera.position.z = 2;
    
    // Create beam indicator
    const beamGroup = new THREE.Group();
    
    // Beam center dot
    const dotGeometry = new THREE.SphereGeometry(0.03, 16, 16);
    const dotMaterial = new THREE.MeshBasicMaterial({ color: 0xffff00 });
    const dot = new THREE.Mesh(dotGeometry, dotMaterial);
    beamGroup.add(dot);
    
    // Beam ring
    const ringGeometry = new THREE.RingGeometry(0.05, 0.07, 32);
    const ringMaterial = new THREE.MeshBasicMaterial({ color: 0xff0000 });
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
    
    beamGroup.position.z = 1;
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
        const scale = 1 / maxDim;
        
        object.position.set(-center.x, -center.y, -center.z);
        object.scale.setScalar(scale);
        
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
        modelRef.current.rotation.x = THREE.MathUtils.degToRad(rotationX);
        modelRef.current.rotation.y = THREE.MathUtils.degToRad(rotationY);
      }
      
      if (beamRef.current) {
        // Convert from percentage (0-100) to position in scene
        const x = (beamCenterX / 50 - 1);
        const y = (1 - beamCenterY / 50);
        
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
  
  return (
    <View className="flex-1 bg-background-50/10">
      <GLView className="flex-1" onContextCreate={onContextCreate} />
    </View>
  );
}