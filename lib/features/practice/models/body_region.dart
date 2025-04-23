import 'package:flutter/material.dart';
import 'body_part.dart';

class BodyRegion {
  final String id;
  final String title;
  final String emoji;
  final int positionCount;
  final Color backgroundColor;
  final List<BodyPart> bodyParts;

  const BodyRegion({
    required this.id,
    required this.title,
    required this.emoji,
    required this.positionCount,
    required this.backgroundColor,
    required this.bodyParts,
  });
}

// Sample data
class BodyRegions {
  static const upperExtremity = BodyRegion(
    id: 'upper_extremity',
    title: 'Upper Extremity',
    emoji: '💪',
    positionCount: 24,
    backgroundColor: Color(0xFFFFAA33),
    bodyParts: [
      BodyPart(
        id: 'shoulder',
        title: 'Shoulder',
        description: 'Positioning for shoulder radiography',
        projections: [
          'AP (External Rotation)',
          'AP (Internal Rotation)',
          'AP (Neutral Rotation)',
          'Scapular Y',
          'Transthoracic',
        ],
        imageAsset: 'assets/images/practice/shoulder.png',
        projectionImages: {
          'AP (External Rotation)':
              'assets/images/practice/shoulder/shoulder_ap_external_rotation.webp',
          'AP (Internal Rotation)':
              'assets/images/practice/shoulder/shoulder_ap_internal_rotation.webp',
          'AP (Neutral Rotation)':
              'assets/images/practice/shoulder/shoulder_ap_neutral_rotation.webp',
          'Scapular Y':
              'assets/images/practice/shoulder/shoulder_scapular_y.webp',
          'Transthoracic':
              'assets/images/practice/shoulder/shoulder_transthoracic.webp',
        },
      ),
      BodyPart(
        id: 'humerus',
        title: 'Humerus',
        description: 'Positioning for humerus radiography',
        projections: ['AP (Upright)', 'Lateral (Upright)'],
        imageAsset: 'assets/images/practice/humerus.png',
        projectionImages: {
          'AP (Upright)':
              'assets/images/practice/humerus/humerus_ap_upright.webp',
          'Lateral (Upright)':
              'assets/images/practice/humerus/humerus_lateral_upright.webp',
        },
      ),
      BodyPart(
        id: 'elbow',
        title: 'Elbow',
        description: 'Positioning for elbow radiography',
        projections: [
          'AP',
          'AP Oblique (Lateral Rotation)',
          'AP Oblique (Medial Rotation)',
          'Lateral',
        ],
        imageAsset: 'assets/images/practice/elbow.png',
        projectionImages: {
          'AP': 'assets/images/practice/elbow/elbow_ap.webp',
          'AP Oblique (Lateral Rotation)':
              'assets/images/practice/elbow/elbow_ap_oblique_lateral_rotation.webp',
          'AP Oblique (Medial Rotation)':
              'assets/images/practice/elbow/elbow_ap_oblique_medial_rotation.webp',
          'Lateral': 'assets/images/practice/elbow/elbow_lateral.webp',
        },
      ),
      BodyPart(
        id: 'forearm',
        title: 'Forearm',
        description: 'Positioning for forearm radiography',
        projections: ['AP', 'Lateral'],
        imageAsset: 'assets/images/practice/forearm/forearm_ap.jpeg',
        projectionImages: {
          'AP': 'assets/images/practice/forearm/forearm_ap.webp',
          'Lateral': 'assets/images/practice/forearm/forearm_lateral.webp',
        },
      ),
      BodyPart(
        id: 'wrist',
        title: 'Wrist',
        description: 'Positioning for wrist radiography',
        projections: [
          'AP',
          'AP Oblique (Medial Rotation)',
          'Lateral',
          'PA',
          'PA Oblique',
          'PA (Radial Deviation)',
          'PA (Ulnar Deviation)',
        ],
        imageAsset: 'assets/images/practice/wrist.png',
        projectionImages: {
          'AP': 'assets/images/practice/wrist/wrist_ap.webp',
          'AP Oblique (Medial Rotation)':
              'assets/images/practice/wrist/wrist_ap_oblique.webp',
          'Lateral': 'assets/images/practice/wrist/wrist_lateral.webp',
          'PA': 'assets/images/practice/wrist/wrist_pa.webp',
          'PA Oblique': 'assets/images/practice/wrist/wrist_pa_oblique.webp',
          'PA (Radial Deviation)':
              'assets/images/practice/wrist/wrist_pa_radial_deviation.webp',
          'PA (Ulnar Deviation)':
              'assets/images/practice/wrist/wrist_pa_ulnar_deviation.webp',
        },
      ),
      BodyPart(
        id: 'hand',
        title: 'Hand',
        description: 'Positioning for hand radiography',
        projections: ['Lateral', 'Norgaard', 'PA', 'PA Oblique'],
        imageAsset: 'assets/images/practice/hand.png',
        projectionImages: {
          'Lateral': 'assets/images/practice/hand/hand_lateral.webp',
          'Norgaard': 'assets/images/practice/hand/hand_norgaard.webp',
          'PA': 'assets/images/practice/hand/hand_pa.webp',
          'PA Oblique': 'assets/images/practice/hand/hand_pa_oblique.webp',
        },
      ),
    ],
  );

  static const headAndNeck = BodyRegion(
    id: 'head_&_neck',
    title: 'Head & Neck',
    emoji: '🧠',
    positionCount: 18,
    backgroundColor: Color(0xFFEB6B9D),
    bodyParts: [
      BodyPart(
        id: 'skull',
        title: 'Skull',
        description: 'Positioning for skull radiography',
        projections: ['PA Caldwell', 'Lateral', 'AP Towne', 'SMV'],
        imageAsset: 'assets/images/practice/skull.png',
      ),
      BodyPart(
        id: 'facial_bones',
        title: 'Facial Bones',
        description: 'Positioning for facial bone radiography',
        projections: ['Waters', 'Lateral', 'PA'],
        imageAsset: 'assets/images/practice/facial_bones.png',
      ),
      // Add more body parts for this region
    ],
  );

  static const thorax = BodyRegion(
    id: 'thorax',
    title: 'Thorax',
    emoji: '🫁',
    positionCount: 12,
    backgroundColor: Color(0xFF5B93EB),
    bodyParts: [
      BodyPart(
        id: 'chest',
        title: 'Chest',
        description: 'Positioning for chest radiography',
        projections: ['PA', 'Lateral', 'AP', 'AP Lordotic'],
        imageAsset: 'assets/images/practice/chest.png',
      ),
      BodyPart(
        id: 'ribs',
        title: 'Ribs',
        description: 'Positioning for rib radiography',
        projections: ['AP', 'Oblique', 'PA'],
        imageAsset: 'assets/images/practice/ribs.png',
      ),
      // Add more body parts for this region
    ],
  );

  static const abdomenAndPelvis = BodyRegion(
    id: 'abdomen_&_pelvis',
    title: 'Abdomen & Pelvis',
    emoji: '🫃',
    positionCount: 15,
    backgroundColor: Color(0xFF53C892),
    bodyParts: [
      BodyPart(
        id: 'abdomen',
        title: 'Abdomen',
        description: 'Positioning for abdominal radiography',
        projections: ['AP Supine', 'AP Upright', 'Lateral'],
        imageAsset: 'assets/images/practice/abdomen.png',
      ),
      BodyPart(
        id: 'pelvis',
        title: 'Pelvis',
        description: 'Positioning for pelvic radiography',
        projections: ['AP', 'Lateral', 'Frog Leg'],
        imageAsset: 'assets/images/practice/pelvis.png',
      ),
      // Add more body parts for this region
    ],
  );

  static const lowerExtremity = BodyRegion(
    id: 'lower_extremity',
    title: 'Lower Extremity',
    emoji: '🦵',
    positionCount: 22,
    backgroundColor: Color(0xFF9474DE),
    bodyParts: [
      BodyPart(
        id: 'hip',
        title: 'Hip',
        description: 'Positioning for hip radiography',
        projections: ['AP', 'Lateral', 'Frog Leg'],
        imageAsset: 'assets/images/practice/hip.png',
      ),
      BodyPart(
        id: 'femur',
        title: 'Femur',
        description: 'Positioning for femur radiography',
        projections: ['AP', 'Lateral'],
        imageAsset: 'assets/images/practice/femur.png',
      ),
      // Add more body parts for this region
    ],
  );

  static const spine = BodyRegion(
    id: 'spine',
    title: 'Spine',
    emoji: '🦴',
    positionCount: 14,
    backgroundColor: Color(0xFF4BC8EB),
    bodyParts: [
      BodyPart(
        id: 'cervical_spine',
        title: 'Cervical Spine',
        description: 'Positioning for cervical spine radiography',
        projections: ['AP', 'Lateral', 'Oblique', 'Odontoid'],
        imageAsset: 'assets/images/practice/c_spine.png',
      ),
      BodyPart(
        id: 'thoracic_spine',
        title: 'Thoracic Spine',
        description: 'Positioning for thoracic spine radiography',
        projections: ['AP', 'Lateral'],
        imageAsset: 'assets/images/practice/t_spine.png',
      ),
      // Add more body parts for this region
    ],
  );

  static const List<BodyRegion> allRegions = [
    headAndNeck,
    thorax,
    abdomenAndPelvis,
    upperExtremity,
    lowerExtremity,
    spine,
  ];

  static BodyRegion getRegionById(String id) {
    return allRegions.firstWhere(
      (region) => region.id == id,
      orElse: () => upperExtremity, // Default fallback
    );
  }
}
