import '../models/lesson.dart';

/// Static list of sample lessons for the MVP.
final List<Lesson> allStaticLessons = [
  // --- Upper Extremity Lessons (Consolidated) ---
  const Lesson(
    id: 'shoulder', // Matches BodyPart ID
    title: 'Shoulder Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/shoulder.png', // General image
    modelPath: 'assets/models/shoulder.glb', // Placeholder
    content: """
# Shoulder Radiography Guide

## Overview
This guide covers common radiographic projections for the shoulder joint.

## General Considerations
*   Remove radiopaque items from the shoulder area.
*   Immobilize the patient as needed.
*   Use appropriate shielding.

## AP Projection (External Rotation Humerus)
*   **IR Size:** 24 x 30 cm crosswise
*   **Patient Position:** Upright / supine position.
*   **Part Position:** Shoulder joint centered to the midline of the grid; center of the IR should be 1 inch (2.5 cm) inferior to the coracoid process; supinate the hand/ externally rotate the entire arm; rotate arm to place epicondyles parallel with the plane of IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** 1 inch (2.5 cm) inferior to coracoid process.
*   **Structures Shown:** Greater tubercle of the humerus, site of the insertion supraspinatus tendon.

## AP Projection (Neutral Rotation Humerus)
*   **IR Size:** 24 x 30 cm crosswise
*   **Patient Position:** Upright / supine position.
*   **Part Position:** Shoulder joint centered to the midline of the grid; center of the IR should be 1 inch (2.5 cm) inferior to the coracoid process; rest palm of the hand against thigh; epicondyles are at 45 degrees to plane of IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** 1 inch (2.5 cm) inferior to coracoid process.
*   **Structures Shown:** Greater tubercle partially demonstrated, posterior part of the supraspinatus insertion.

## AP Projection (Internal Rotation Humerus)
*   **IR Size:** 24 x 30 cm crosswise
*   **Patient Position:** Upright / supine position.
*   **Part Position:** Shoulder joint centered to the midline of the grid; center of the IR should be 1 inch (2.5 cm) inferior to the coracoid process; internally rotate the arm; rest the back of the hand on the hip; adjust arm to place epicondyles perpendicular with the plane of IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** 1 inch (2.5 cm) inferior to coracoid process.
*   **Structures Shown:** Proximal humerus in a true lateral position, site of the insertion of subscapular tendon.

## Transthoracic Lateral Projection (Lawrence Method)
*   **IR Size:** 24 x 30 cm lengthwise
*   **Patient Position:** Upright / supine position.
*   **Part Position:** Raise uninjured arm w/ forearm resting on the head and elevating the shoulders as much as possible; IR centered at the surgical neck of the affected humerus.
*   **Central Ray (CR):** Perpendicular to IR, entering MCP at the level of the surgical neck. (Use 10 to 15 degrees cephalad if patient cannot elevate unaffected shoulder).
*   **Reference Point:** Surgical neck.
*   **Structures Shown:** Lateral image of the shoulder, proximal humerus is projected through the thorax.

## Scapular Y (PA Oblique Projection)
*   **IR Size:** 24 x 30 cm
*   **Patient Position:** Upright (preferred) / recumbent body position.
*   **Part Position:** Position the anterior surface of the affected shoulder against IR; rotate body until MCP forms 45 to 60 degrees to the IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Scapulohumeral joint.
*   **Structures Shown:** Humeral head directly superimposed over the junction of Y (normal shoulder). Anterior (subcoracoid) dislocations: humeral head is beneath coracoid process. Posterior (subacromial) dislocations: projected beneath acromion process.
""",
  ),

  const Lesson(
    id: 'humerus', // Matches BodyPart ID
    title: 'Humerus Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/humerus.png', // General image
    modelPath: 'assets/models/humerus.glb', // Placeholder
    content: """
# Humerus Radiography Guide

## Overview
This guide covers standard AP and Lateral projections of the humerus.

## General Considerations
*   Ensure both shoulder and elbow joints are included if possible, or take separate images if necessary.
*   Consider patient condition (trauma vs. non-trauma).

## AP Projection
*   **IR Size:** Lengthwise: 18x43 cm; 35x 43 cm
*   **Patient Position:** Upright/Seated.
*   **Part Position:** Arm slightly abducted; Hand Supinated. Humeral Epicondyles parallel with IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Mid portion of humerus.
*   **Structures Shown:** AP Projection of Entire Humerus. Epicondyles showed without rotation.

## Lateromedial Projection
*   **IR Size:** Lengthwise: 18x43 cm; 35x 43 cm
*   **Patient Position:** Upright.
*   **Part Position:** Arm internally rotated. Elbow flexed 90 degrees with the palmar surface on the hip. Humeral Epicondyles parallel with IR.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Mid portion of humerus.
*   **Structures Shown:** Lateral Projection of entire Humerus.
""",
  ),

  const Lesson(
    id: 'elbow', // Matches BodyPart ID
    title: 'Elbow Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/elbow.png', // General image
    modelPath: 'assets/models/elbow.glb', // Placeholder
    content: """
# Elbow Radiography Guide

## Overview
This guide covers standard projections for the elbow joint.

## General Considerations
*   Flexion/extension limitations may require modifications.
*   Assess for fat pad signs indicating effusion or fracture.

## AP Projection
*   **IR Size:** 18 x 24 cm single / 24 x 30 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** Elbow extended. Hand supinated. IR center to the elbow joint. IR parallel with the long axis of the part.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Elbow joint.
*   **Structures Shown:** AP projection of the elbow joint. Distal arm. Proximal forearm.

## Lateral Projection (Lateromedial)
*   **IR Size:** 18 x 24 cm single / 24 x 30 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** From supine position flex the elbow 90°. Elbow joint long axis is parallel to the long axis of the forearm.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Elbow joint.
*   **Structures Shown:** Oblique projection of the elbow. Coronoid process free of superimposition. *(Note: Spreadsheet title says Lateral, but description/structures suggest Oblique)*

## AP Oblique (Lateral Rotation)
*   **IR Size:** 8 x 10 inch (18 X 24 cm) single / 24 X 30 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** Extend the limb. Center the midpoint of IR to the elbow. Medially rotate or pronate the hand.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Elbow joint.
*   **Structures Shown:** Coronoid process free of superimposition.

## AP Oblique (Medial Rotation)
*   **IR Size:** 8 x 10 inch (18 X 24 cm) single / 24 X 30 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** Extend patient arm. Rotate hand laterally to face the posterior surface at a 45 degree angle. Center midpoint of the IR to elbow joint.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Elbow joint.
*   **Structures Shown:** Radial head and neck projected free of superimposition of the ulna.
""",
  ),

  const Lesson(
    id: 'forearm', // Matches BodyPart ID
    title: 'Forearm Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/forearm/forearm_ap.jpeg', // General image
    modelPath: 'assets/models/forearm.glb', // Placeholder
    content: """
# Forearm Radiography Guide

## Overview
Standard forearm radiography includes AP and Lateral projections to visualize the radius, ulna, and surrounding soft tissues.

![Example of Forearm AP Positioning](assets/images/lesson_specific/forearm_ap_positioning.png)

## General Considerations
*   Remove any radiopaque objects (watches, bracelets).
*   Ensure both wrist and elbow joints are included.

## AP Projection
*   **IR Size:** 18 x 43 cm single / 35 x 43 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** Hand supinated. Elbow extended. Forearm center in IR. IR long axis parallel to the forearm.
    ![Diagram showing AP Forearm setup](assets/images/lesson_specific/forearm_ap_diagram.png)
*   **Central Ray:** Perpendicular.
*   **Reference Point:** Midpoint of the forearm.
*   **Structures Shown:** AP projection of the forearm demonstrating the elbow joint. Radius and ulna. Proximal row of slightly distorted carpal bones.

## Lateral Projection (Lateromedial)
*   **IR Size:** 18 x 43 cm single / 35 x 43 cm divided
*   **Patient Position:** Seated.
*   **Part Position:** Elbow flex 90°. Forearm center in IR. IR parallel with the long axis of the forearm.
*   **Central Ray:** Perpendicular.
*   **Reference Point:** Midpoint of the forearm.
*   **Structures Shown:** Bones of the forearm. Elbow joint. Proximal row of carpal bones.
""",
  ),

  const Lesson(
    id: 'wrist', // Matches BodyPart ID
    title: 'Wrist Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/wrist.png', // General image
    modelPath: 'assets/models/wrist.glb', // Placeholder
    content: """
# Wrist Radiography Guide

## Overview
This guide covers common projections for the wrist joint and carpal bones.

## General Considerations
*   Remove watches, rings, and bracelets.
*   Note any patient pain or limited mobility.

## PA Projection
*   **IR Size:** 8x10 inch (18x24cm)
*   **Patient Position:** Seated.
*   **Part Position:** Rest the forearm on the table, and center the wrist to the IR. Hand pronated.
*   **Central Ray (CR):** Perpendicular to midcarpal area.
*   **Reference Point:** Midcarpal area.
*   **Structures Shown:** PA projection of the carpals, distal radius and ulna, and proximal metacarpals are shown.

## AP Projection
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Rest the forearm on the table, and center the wrist to the IR. Hand supinated.
*   **Central Ray (CR):** Perpendicular to wrist joint.
*   **Reference Point:** Wrist joint.
*   **Structures Shown:** Better demonstrates the carpal interspaces.

## Lateral Projection (Lateromedial Rotation)
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Flex the elbow 90° to rotate the ulna in true lateral position. Center IR to the carpals.
*   **Central Ray (CR):** Perpendicular to wrist joint.
*   **Reference Point:** Wrist joint.
*   **Structures Shown:** Proximal metacarpals, carpals, and distal radius, and ulna.

## PA Oblique Projection (Lateral Rotation)
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Hand is pronated. Rotate the wrist laterally forming an angle of approx. 45°.
*   **Central Ray (CR):** Perpendicular entering distal to radius.
*   **Reference Point:** Midcarpal area.
*   **Structures Shown:** Lateral side of trapezium and scaphoid.

## AP Oblique Projection (Medial Rotation)
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Hand is supinated. Rotate the wrist medially until it forms an angle of approx. 45°.
*   **Central Ray (CR):** Perpendicular entering the wrist midway between the medial and lateral borders.
*   **Reference Point:** Midcarpal area. *(Note: Spreadsheet also mentions Third MCP joint here, using Midcarpal based on CR)*
*   **Structures Shown:** *(Not specified in spreadsheet for this projection)*

## PA Projection (Ulnar Deviation) / Scaphoid View
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Wrist is pronated; Hand ulnar deviated. Elbow away from the patient’s body.
*   **Central Ray (CR):** Perpendicular. (Angulate 10-15° proximally or distally for clear delineation).
*   **Reference Point:** Scaphoid.
*   **Structures Shown:** Corrects the foreshortening of the scaphoid. Open spaces between adjacent carpals.

## PA Projection (Radial Deviation)
*   **IR Size:** 8x10 inch (18x24 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Wrist is pronated; Hand in extreme radial deviation. Hand cupped over the wrist.
*   **Central Ray (CR):** Perpendicular.
*   **Reference Point:** Midcarpal area.
*   **Structures Shown:** Open interspaces between the carpals on the medial side.
""",
  ),

  const Lesson(
    id: 'hand', // Matches BodyPart ID
    title: 'Hand Radiography',
    bodyRegion: 'Upper Extremity',
    projectionName: 'Various Projections',
    imageUrl: 'assets/images/practice/hand.png', // General image
    modelPath: 'assets/models/hand.glb', // Placeholder
    content: """
# Hand Radiography Guide

## Overview
This guide covers standard projections for the hand, including fingers and thumb.

## General Considerations
*   Remove all rings.
*   Place lead shield over patient's lap.

## PA Projection
*   **IR Size:** 24x30cm (10x12 inches)
*   **Patient Position:** Seated; Forearm resting on table.
*   **Part Position:** Pronate hand; Center IR to MCP joints.
*   **Central Ray (CR):** Perpendicular to 3rd MCP joint.
*   **Reference Point:** Third MCP joint.
*   **Structures Shown:** PA projections of carpals, metacarpals, phalanges, hand inter articulations, distal radius and ulna. Demonstrates PA oblique projection of first digit.

## PA Oblique Projection
*   **IR Size:** 24x30cm (10x12 inches)
*   **Patient Position:** Seated; Forearm resting on table.
*   **Part Position:** From pronation, adjust hand obliquity so that MCP joints form a 45-degree angle with IR plane; Rotate hand externally until fingertips touch IR.
*   **Central Ray (CR):** Perpendicular to 3rd MCP joint.
*   **Reference Point:** *(Not specified, likely 3rd MCP joint)*
*   **Structures Shown:** Shows PA oblique projection of bones and soft tissues of the hand. Investigates fractures and pathologic conditions.

## Lateral Projection (Flexion)
*   **IR Size:** 24x30cm (10x12 inches)
*   **Patient Position:** Seated; Forearm resting on table.
*   **Part Position:** Hand in lateral position with ulnar aspect down. Relax digits to maintain natural arch. Arrange the digits so that they are perfectly superimposed. Position thumb parallel to IR or immobilize if necessary.
*   **Central Ray (CR):** Perpendicular to 2nd MCP.
*   **Reference Point:** Second MCP joint.
*   **Structures Shown:** Shows lateral image of the bony structures and soft tissues of the hand in their normally flexed position. It also demonstrates anterior or posterior displacement in fractures of the metacarpals.

## AP Oblique (Norgaard / Ball-Catcher's)
*   **IR Size:** 24x30cm (10x12 inches)
*   **Patient Position:** Seated.
*   **Part Position:** Radiographed both hands in half-supinate position. Rotated hands to half-supinate position until the dorsal surface of each hand rests against each 45-degree sponge support. Extend fingers and abduct thumbs slightly. (Modified position: Similar hand position except fingers are cupped like catching a ball).
*   **Central Ray (CR):** Perpendicular to MCP joint.
*   **Reference Point:** MCP joint.
*   **Structures Shown:** Shows AP 45-degree oblique projection of both hands.
""",
  ),

  // --- Other Body Regions ---
];

/// Utility function to retrieve a lesson by its ID from the static list.
Lesson? getLessonFromStaticSource(String lessonId) {
  try {
    // Use firstWhereOrNull for cleaner null handling
    // Find the first lesson where the lesson's id matches the provided lessonId
    final lesson = allStaticLessons.firstWhere(
      (lesson) => lesson.id == lessonId,
      // If no lesson is found, return null
      orElse: () {
        print('Lesson with ID $lessonId not found.'); // Log if not found
        // Explicitly return null satisfying the Lesson? return type
        return null as Lesson;
      },
    );
    // Need to handle the case where firstWhere finds an element but it's somehow null
    // This check ensures we always return Lesson?
    return lesson;
  } catch (e) {
    // Catch any other potential errors during the search
    print('Error finding lesson with ID $lessonId: $e');
    return null;
  }
}
