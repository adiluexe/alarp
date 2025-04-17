import '../models/lesson.dart';

/// Static list of sample lessons for the MVP.
final List<Lesson> allStaticLessons = [
  const Lesson(
    id: 'chest_pa',
    title: 'Chest PA Projection',
    bodyRegion: 'Thorax',
    projectionName: 'PA',
    imageUrl: 'assets/images/learn/chest_pa_example.png', // Example path
    modelPath: 'assets/models/chest_pa_model.glb', // Example path
    content: """
# Chest PA Projection Guide

## Overview
The Posteroanterior (PA) chest projection is a standard radiographic view used to evaluate the lungs, heart, and surrounding structures.

## Patient Positioning
*   Patient stands erect, facing the image receptor (IR).
*   Chin raised, resting on top of the IR holder.
*   Hands placed on lower hips, palms out, elbows partially flexed.
*   Shoulders rotated forward against the IR to move scapulae laterally from the lung fields.
*   Weight evenly distributed on both feet.

## Central Ray (CR)
*   CR perpendicular to the IR.
*   Centered to the midsagittal plane at the level of T7 (inferior angle of scapulae).

## Image Receptor (IR)
*   14 x 17 inches (35 x 43 cm), lengthwise or crosswise.
*   Top of IR approximately 1.5 to 2 inches (4 to 5 cm) above the shoulders.

## Collimation
*   Collimate laterally to the outer skin margins.
*   Collimate superiorly to the level of the vertebra prominens (C7).
*   Collimate inferiorly to the level of the costophrenic angles.

## Evaluation Criteria
*   Entire lungs included from apices to costophrenic angles.
*   No rotation (sternal ends of clavicles equidistant from the vertebral column).
*   Scapulae outside the lung fields.
*   Sharp outlines of heart and diaphragm.
*   Full inspiration (minimum of 10 posterior ribs visible above the diaphragm).
""",
  ),

  // --- Upper Extremity Lessons (Consolidated) ---
  const Lesson(
    id: 'shoulder', // Matches BodyPart ID
    title: 'Shoulder Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/shoulder.png', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Shoulder Radiography Guide

## Overview
This guide covers common radiographic projections for the shoulder joint.

## General Considerations
*   Remove radiopaque items from the shoulder area.
*   Immobilize the patient as needed.
*   Use appropriate shielding.

## AP (External Rotation)
*   **Patient Position:** *(Details for Shoulder AP External Rotation go here)*
*   **Central Ray (CR):** *(Details for Shoulder AP External Rotation go here)*
*   **Evaluation Criteria:** *(Details for Shoulder AP External Rotation go here)*

## AP (Internal Rotation)
*   **Patient Position:** *(Details for Shoulder AP Internal Rotation go here)*
*   **Central Ray (CR):** *(Details for Shoulder AP Internal Rotation go here)*
*   **Evaluation Criteria:** *(Details for Shoulder AP Internal Rotation go here)*

## AP (Neutral Rotation)
*   **Patient Position:** *(Details for Shoulder AP Neutral Rotation go here)*
*   **Central Ray (CR):** *(Details for Shoulder AP Neutral Rotation go here)*
*   **Evaluation Criteria:** *(Details for Shoulder AP Neutral Rotation go here)*

## Scapular Y
*   **Patient Position:** *(Details for Shoulder Scapular Y go here)*
*   **Central Ray (CR):** *(Details for Shoulder Scapular Y go here)*
*   **Evaluation Criteria:** *(Details for Shoulder Scapular Y go here)*

## Transthoracic
*   **Patient Position:** *(Details for Shoulder Transthoracic go here)*
*   **Central Ray (CR):** *(Details for Shoulder Transthoracic go here)*
*   **Evaluation Criteria:** *(Details for Shoulder Transthoracic go here)*
""",
  ),

  const Lesson(
    id: 'humerus', // Matches BodyPart ID
    title: 'Humerus Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/humerus.png', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Humerus Radiography Guide

## Overview
This guide covers standard AP and Lateral projections of the humerus.

## General Considerations
*   Ensure both shoulder and elbow joints are included if possible, or take separate images if necessary.
*   Consider patient condition (trauma vs. non-trauma).

## AP (Upright/Supine)
*   **Patient Position:** *(Details for Humerus AP go here)*
*   **Central Ray (CR):** *(Details for Humerus AP go here)*
*   **Evaluation Criteria:** *(Details for Humerus AP go here)*

## Lateral (Upright/Supine)
*   **Patient Position:** *(Details for Humerus Lateral go here)*
*   **Central Ray (CR):** *(Details for Humerus Lateral go here)*
*   **Evaluation Criteria:** *(Details for Humerus Lateral go here)*
""",
  ),

  const Lesson(
    id: 'elbow', // Matches BodyPart ID
    title: 'Elbow Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/elbow.png', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Elbow Radiography Guide

## Overview
This guide covers standard projections for the elbow joint.

## General Considerations
*   Flexion/extension limitations may require modifications.
*   Assess for fat pad signs indicating effusion or fracture.

## AP
*   **Patient Position:** *(Details for Elbow AP go here)*
*   **Central Ray (CR):** *(Details for Elbow AP go here)*
*   **Evaluation Criteria:** *(Details for Elbow AP go here)*

## AP Oblique (Lateral Rotation)
*   **Patient Position:** *(Details for Elbow AP Oblique Lateral Rotation go here)*
*   **Central Ray (CR):** *(Details for Elbow AP Oblique Lateral Rotation go here)*
*   **Evaluation Criteria:** *(Details for Elbow AP Oblique Lateral Rotation go here)*

## AP Oblique (Medial Rotation)
*   **Patient Position:** *(Details for Elbow AP Oblique Medial Rotation go here)*
*   **Central Ray (CR):** *(Details for Elbow AP Oblique Medial Rotation go here)*
*   **Evaluation Criteria:** *(Details for Elbow AP Oblique Medial Rotation go here)*

## Lateral
*   **Patient Position:** *(Details for Elbow Lateral go here)*
*   **Central Ray (CR):** *(Details for Elbow Lateral go here)*
*   **Evaluation Criteria:** *(Details for Elbow Lateral go here)*
""",
  ),

  const Lesson(
    id: 'forearm', // Matches BodyPart ID
    title: 'Forearm Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/forearm/forearm_ap.jpeg', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Forearm Radiography Guide

## Overview
Standard forearm radiography includes AP and Lateral projections to visualize the radius, ulna, and surrounding soft tissues.

## General Considerations
*   Remove any radiopaque objects (watches, bracelets).
*   Ensure both wrist and elbow joints are included.

## AP Projection
*   **Patient Position:** Seated at the end of the table, arm extended. Supinate the hand (palm up). Ensure wrist and elbow joints are included. Epicondyles should be parallel to the Image Receptor (IR).
*   **Central Ray:** Perpendicular to the mid-forearm.
*   **Collimation:** Include wrist and elbow joints, collimate to skin margins laterally.
*   **Evaluation:** Elbow and wrist joints visible. Slight overlap of radial head, neck, and tuberosity over the proximal ulna. No elongation or foreshortening of bones.

## Lateral Projection
*   **Patient Position:** Seated, elbow flexed 90 degrees, shoulder, elbow, and wrist on the same plane. Place the ulnar (medial) aspect of the forearm and hand against the IR. Ensure wrist and elbow joints are included.
*   **Central Ray:** Perpendicular to the mid-forearm.
*   **Collimation:** Include wrist and elbow joints, collimate to skin margins anteriorly and posteriorly.
*   **Evaluation:** Elbow and wrist joints visible. Elbow flexed 90 degrees. Superimposition of the radius and ulna at their distal ends. Superimposition of the radial head over the coronoid process.
""",
  ),

  const Lesson(
    id: 'wrist', // Matches BodyPart ID
    title: 'Wrist Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/wrist.png', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Wrist Radiography Guide

## Overview
This guide covers common projections for the wrist joint and carpal bones.

## General Considerations
*   Remove watches, rings, and bracelets.
*   Note any patient pain or limited mobility.

## AP
*   **Patient Position:** *(Details for Wrist AP go here)*
*   **Central Ray (CR):** *(Details for Wrist AP go here)*
*   **Evaluation Criteria:** *(Details for Wrist AP go here)*

## AP Oblique (Medial Rotation)
*   **Patient Position:** *(Details for Wrist AP Oblique Medial Rotation go here)*
*   **Central Ray (CR):** *(Details for Wrist AP Oblique Medial Rotation go here)*
*   **Evaluation Criteria:** *(Details for Wrist AP Oblique Medial Rotation go here)*

## Lateral
*   **Patient Position:** *(Details for Wrist Lateral go here)*
*   **Central Ray (CR):** *(Details for Wrist Lateral go here)*
*   **Evaluation Criteria:** *(Details for Wrist Lateral go here)*

## PA
*   **Patient Position:** *(Details for Wrist PA go here)*
*   **Central Ray (CR):** *(Details for Wrist PA go here)*
*   **Evaluation Criteria:** *(Details for Wrist PA go here)*

## PA Oblique
*   **Patient Position:** *(Details for Wrist PA Oblique go here)*
*   **Central Ray (CR):** *(Details for Wrist PA Oblique go here)*
*   **Evaluation Criteria:** *(Details for Wrist PA Oblique go here)*

## PA (Radial Deviation)
*   **Patient Position:** *(Details for Wrist PA Radial Deviation go here)*
*   **Central Ray (CR):** *(Details for Wrist PA Radial Deviation go here)*
*   **Evaluation Criteria:** *(Details for Wrist PA Radial Deviation go here)*

## PA (Ulnar Deviation) / Scaphoid View
*   **Patient Position:** *(Details for Wrist PA Ulnar Deviation go here)*
*   **Central Ray (CR):** *(Details for Wrist PA Ulnar Deviation go here)*
*   **Evaluation Criteria:** *(Details for Wrist PA Ulnar Deviation go here)*
""",
  ),

  const Lesson(
    id: 'hand', // Matches BodyPart ID
    title: 'Hand Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/hand.png', // General image
    modelPath: 'assets/models/test.glb', // Placeholder
    content: """
# Hand Radiography Guide

## Overview
This guide covers standard projections for the hand, including fingers and thumb.

## General Considerations
*   Remove all rings.
*   Place lead shield over patient's lap.

## Lateral
*   **Patient Position:** *(Details for Hand Lateral go here)*
*   **Central Ray (CR):** *(Details for Hand Lateral go here)*
*   **Evaluation Criteria:** *(Details for Hand Lateral go here)*

## Norgaard (Ball-Catcher's)
*   **Patient Position:** *(Details for Hand Norgaard go here)*
*   **Central Ray (CR):** *(Details for Hand Norgaard go here)*
*   **Evaluation Criteria:** *(Details for Hand Norgaard go here)*

## PA
*   **Patient Position:** *(Details for Hand PA go here)*
*   **Central Ray (CR):** *(Details for Hand PA go here)*
*   **Evaluation Criteria:** *(Details for Hand PA go here)*

## PA Oblique
*   **Patient Position:** *(Details for Hand PA Oblique go here)*
*   **Central Ray (CR):** *(Details for Hand PA Oblique go here)*
*   **Evaluation Criteria:** *(Details for Hand PA Oblique go here)*
""",
  ),

  // --- Other Body Regions ---
  const Lesson(
    id: 'skull', // Matches the bodyPart.id used in navigation
    title: 'Skull Radiography',
    bodyRegion: 'Head',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/skull.png', // General image
    modelPath: 'assets/models/skull_model.glb', // Placeholder
    content: """
# Skull Radiography Guide

## Overview
This guide covers standard projections for the skull.

## General Considerations
*   Remove any radiopaque objects (glasses, earrings).
*   Immobilize the patient as needed.

## AP
*   **Patient Position:** *(Details for Skull AP go here)*
*   **Central Ray (CR):** *(Details for Skull AP go here)*
*   **Evaluation Criteria:** *(Details for Skull AP go here)*

## Lateral
*   **Patient Position:** *(Details for Skull Lateral go here)*
*   **Central Ray (CR):** *(Details for Skull Lateral go here)*
*   **Evaluation Criteria:** *(Details for Skull Lateral go here)*

## PA
*   **Patient Position:** *(Details for Skull PA go here)*
*   **Central Ray (CR):** *(Details for Skull PA go here)*
*   **Evaluation Criteria:** *(Details for Skull PA go here)*
""",
  ),
];

/// Utility function to retrieve a lesson by its ID from the static list.
Lesson? getLessonFromStaticSource(String lessonId) {
  try {
    // Use firstWhereOrNull for cleaner null handling
    return allStaticLessons.firstWhere((lesson) => lesson.id == lessonId);
  } catch (e) {
    // Return null if no lesson with the given ID is found
    print('Lesson with ID $lessonId not found.'); // Added print statement
    return null;
  }
}
