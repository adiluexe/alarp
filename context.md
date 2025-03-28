# ALARP Development Guide

## 1. Introduction

**Project Overview:** ALARP is a mobile application designed to aid radiography students in mastering radiographic positioning techniques through interactive 3D simulations.

**Purpose of this Guide:** This document outlines the screen structure, features, and development considerations to ensure a cohesive and effective application.

**Target Audience:** Radiography students.

**Development Timeline:** March 22 - April 16, 2025.

## 2. Screen Definitions and Features

### 2.1 Home Screen

**Purpose:** Serves as the application's entry point, providing an overview and navigation to core functionalities.

**Features:**

* Welcome message explaining the app's purpose.
* Three primary navigation cards:
    * Learn: Access to educational modules.
    * Practice: Scenarios for practicing positioning.
    * Challenge: Gamified assessment of skills.

**Technical Considerations:**

* Clean and intuitive UI, adhering to a medical-professional aesthetic (blue color scheme).
* Efficient loading of navigation cards.

### 2.2 Learn Screen

**Purpose:** Provides access to educational content for different body regions.

**Features:**

* Grid or list view of body regions (Chest, Upper Extremities, Lower Extremities, Skull, Spine, Abdomen).
* Brief descriptions of each learning module.
* Visual representation of each body region.

**Technical Considerations:**

* Clear categorization of body regions.
* Optimized image loading for grid/list elements.
* Text scalability for ease of reading.

### 2.3 Practice Screen

**Purpose:** Provides an interactive environment where students can apply radiographic positioning techniques in a structured practice setting.

**Features:**

* Selection of body regions for targeted practice (limited to one implemented region in the current version).
* Difficulty selection (Beginner, Intermediate, Advanced) to accommodate varying skill levels.
* Guided practice scenarios with step-by-step feedback on positioning adjustments.
* Interactive 3D patient model with real-time controls for:
    * Patient rotation (X and Y axes).
    * Beam centering (horizontal and vertical positioning).
    * Beam angle adjustments.
* Immediate visual and textual feedback on positioning accuracy.
* Reference guide displaying ideal positioning standards.

**Technical Considerations:**

* Data persistence to allow students to track and revisit past practice attempts.
* High-performance 3D rendering (Three.js with React Three Fiber) for smooth interaction.
* Intuitive UI/UX for a seamless learning experience.
* Accessibility options such as adjustable text size and contrast settings.

### 2.4 Challenge Mode Screen

**Purpose:** Assesses student proficiency in radiographic positioning through structured challenges.

**Features:**

* Pre-set positioning challenges with increasing difficulty.
* Real-time scoring based on:
    * Positioning accuracy.
    * Minimization of patient repositioning adjustments.
    * Completion time.
* Progress tracking to monitor student improvement over time.

**Technical Considerations:**

* Backend integration for storing challenge results and progress tracking.
* Performance optimization to ensure responsive challenge interactions.

### 2.5 Positioning Screen (Core Gameplay)

**Purpose:** Interactive 3D environment for positioning practice.

**Features:**

* Interactive 3D patient model visualization.
* Controls for:
    * Patient rotation (X and Y axes).
    * Beam centering (horizontal and vertical position).
    * Beam angle.
* Feedback system for positioning accuracy:
    * Visual overlays showing optimal beam angles.
    * Scoring based on accuracy and efficiency.
* Reference positioning guide (visual and textual).

**Technical Considerations:**

* High-performance 3D rendering (Three.js with React Three Fiber).
* Precise control responsiveness.
* Accurate and informative feedback system.
* Clear and accessible reference guide.

## 3. Core Mechanics and Gameplay Elements

**Core Mechanics:**

* Manipulation of a virtual patient/body part to achieve correct positioning.
* Real-time feedback on positioning accuracy.

**Gameplay Elements:**

* Challenge scenarios with varying patient types and radiographic views.
* Scoring system based on:
    * Positioning accuracy.
    * Radiation dose minimization (ALARP principle).
    * Image quality.
* Progression system with increasing complexity.
* Visual overlays for optimal beam angles.

## 4. Development Considerations

**UI/UX Design:**

* Maintain a clean, medical-professional UI with a consistent blue color scheme.
* Ensure intuitive navigation and user-friendly controls.
* Prioritize accessibility and readability.

**3D Visualization:**

* Optimize 3D models for performance on mobile devices.
* Implement level-of-detail (LOD) systems for older devices.
* Ensure accurate and realistic representation of body regions.

**Feedback System:**

* Provide clear and immediate visual and textual feedback.
* Explain the rationale behind correct positioning.
* Implement a scoring system that is fair and informative.

**Gamification:**

* Design engaging challenge scenarios with clear objectives.
* Implement a progression system that rewards improvement.
* Ensure challenges are relevant to radiography practice.

**Content Integration:**

* Collaborate with radiography experts to ensure accuracy.
* Provide clear and concise educational content.
* Include real-world case studies for enhanced learning.

**Testing and Quality Assurance:**

* Conduct thorough testing on various devices and operating systems.
* Gather feedback from radiography students and instructors.
* Prioritize bug fixing and performance optimization.

**Technology Stack:**

* React Native for cross-platform development.
* Three.js with React Three Fiber for 3D visualization.
* Supabase for authentication, database, and analytics.
* TailwindCSS for UI styling.
* Framer Motion for animations.

## 5. Development Phases (as detailed in the Project Charter)

* Phase 1: Setup & Design (March 22-26)
* Phase 2: Core Development (March 27 - April 2)
* Phase 3: Feature Implementation (April 3-9)
* Phase 4: Testing & Refinement (April 10-14)
* Phase 5: Deployment (April 15-16)

## 6. Success Metrics (as detailed in the Project Charter)

* Technical Metrics.
* User Experience Metrics.
* Educational Metrics.

## 7. Risk Assessment & Mitigation (as detailed in the Project Charter)

* 3D performance issues.
* Accuracy concerns.
* Timeline constraints.
* User experience complexity.
* Backend scalability.

## 8. Approval

* Client Representative.
* Development Team Lead.
* Project Manager.