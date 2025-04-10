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
    positionCount: 20,
    backgroundColor: Color(0xFFFFAA33),
    bodyParts: [
      BodyPart(
        id: 'shoulder',
        title: 'Shoulder',
        description: 'Positioning for shoulder radiography',
        projections: [
          'AP (Internal Rotation)',
          'AP (External Rotation)',
          'Axillary',
          'Scapular Y',
        ],
        imageAsset: 'assets/images/practice/shoulder.png',
      ),
      BodyPart(
        id: 'humerus',
        title: 'Humerus',
        description: 'Positioning for humerus radiography',
        projections: ['AP', 'Lateral'],
        imageAsset: 'assets/images/practice/humerus.png',
      ),
      BodyPart(
        id: 'elbow',
        title: 'Elbow',
        description: 'Positioning for elbow radiography',
        projections: ['AP', 'Lateral', 'Oblique'],
        imageAsset: 'assets/images/practice/elbow.png',
      ),
      BodyPart(
        id: 'forearm',
        title: 'Forearm',
        description: 'Positioning for forearm radiography',
        projections: ['AP', 'Lateral'],
        imageAsset: 'assets/images/practice/forearm.png',
      ),
      BodyPart(
        id: 'wrist',
        title: 'Wrist',
        description: 'Positioning for wrist radiography',
        projections: ['PA', 'Lateral', 'Oblique', 'Carpal Tunnel View'],
        imageAsset: 'assets/images/practice/wrist.png',
      ),
      BodyPart(
        id: 'hand',
        title: 'Hand',
        description: 'Positioning for hand radiography',
        projections: ['PA', 'Lateral', 'Oblique'],
        imageAsset: 'assets/images/practice/hand.png',
      ),
      BodyPart(
        id: 'fingers',
        title: 'Fingers/Thumb',
        description: 'Positioning for finger and thumb radiography',
        projections: ['AP', 'Lateral', 'Oblique'],
        imageAsset: 'assets/images/practice/fingers.png',
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
