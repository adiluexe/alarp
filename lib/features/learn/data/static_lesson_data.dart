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
  const Lesson(
    id: 'shoulder_ap_ext',
    title: 'Shoulder AP (External Rotation)',
    bodyRegion: 'Upper Extremity',
    projectionName: 'AP External Rotation',
    imageUrl: 'assets/images/learn/shoulder_ap_ext.png', // Example path
    content: """
# Shoulder AP - External Rotation

## Overview
This projection provides an AP view of the shoulder joint with the humerus in external rotation, best visualizing the greater tubercle in profile laterally.

## Patient Positioning
*   Patient may be erect or supine.
*   Rotate the body slightly toward the affected side if necessary to place the shoulder in contact with the IR.
*   Abduct the arm slightly, externally rotate the hand (supinate) until the epicondyles of the distal humerus are parallel to the IR.

## Central Ray (CR)
*   CR perpendicular to the IR.
*   Centered approximately 1 inch (2.5 cm) inferior to the coracoid process.

## Image Receptor (IR)
*   10 x 12 inches (24 x 30 cm), crosswise.

## Collimation
*   Collimate to include the entire clavicle, scapula, and proximal humerus.

## Evaluation Criteria
*   Greater tubercle seen in profile laterally.
*   Humeral head seen in profile medially.
*   Outline of the lesser tubercle superimposed over the humeral head.
""",
  ),
  const Lesson(
    id: 'skull', // Matches the bodyPart.id used in navigation
    title: 'Skull Series',
    bodyRegion: 'Head & Neck',
    projectionName: 'Various', // Or specify one like 'PA Caldwell'
    imageUrl:
        'assets/images/practice/skull.png', // Reuse practice image for now
    content: """
# Skull Radiography Guide

## Overview
Skull radiography involves multiple projections to visualize the cranial bones, facial bones, and sinuses. Common projections include PA Caldwell, AP Towne, Lateral, and Submentovertex (SMV).

## General Considerations
*   Remove all metallic objects from the head and neck area.
*   Use appropriate immobilization techniques.
*   Ensure patient comfort and understanding.

## Example: PA Caldwell Projection
*   **Patient Position:** Erect or prone, forehead and nose resting against the IR. Orbitomeatal Line (OML) perpendicular to IR. Midsagittal plane perpendicular.
*   **Central Ray:** Angled 15 degrees caudad, exiting at the nasion.
*   **Evaluation:** Petrous ridges projected in the lower third of the orbits. Equal distance from lateral border of skull to lateral border of orbit on both sides.

## Example: Lateral Projection
*   **Patient Position:** Erect or semi-prone. Affected side closest to IR. Interpupillary line perpendicular to IR. Midsagittal plane parallel to IR. Infraorbitomeatal Line (IOML) perpendicular to the front edge of the IR.
*   **Central Ray:** Perpendicular to IR, centered 2 inches (5 cm) superior to the External Acoustic Meatus (EAM).
*   **Evaluation:** Superimposed orbital roofs, mandibular rami, and EAMs. Sella turcica seen in profile.

*(Add details for other projections like AP Towne, SMV as needed)*
""",
  ),
  // Add more sample lessons as needed
];

/// Utility function to retrieve a lesson by its ID from the static list.
Lesson? getLessonFromStaticSource(String lessonId) {
  try {
    return allStaticLessons.firstWhere((lesson) => lesson.id == lessonId);
  } catch (e) {
    // Return null if no lesson with the given ID is found
    return null;
  }
}
