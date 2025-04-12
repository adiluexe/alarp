// Placeholder image path
const String _placeholderImage = 'assets/images/alarp_icon.png';

class BodyPart {
  final String id;
  final String title;
  final String description;
  final String imageAsset; // Path to the image asset
  final List<String>
  projections; // List of projection names (e.g., 'AP', 'Lateral')

  const BodyPart({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.projections,
  });

  // --- Static Data Example (Update your actual data source) ---

  // Upper Extremity
  static const BodyPart hand = BodyPart(
    id: 'hand',
    title: 'Hand',
    description: 'Practice positioning for hand radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['PA', 'Oblique', 'Lateral'],
  );
  static const BodyPart wrist = BodyPart(
    id: 'wrist',
    title: 'Wrist',
    description: 'Practice positioning for wrist radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['PA', 'Oblique', 'Lateral'],
  );
  static const BodyPart forearm = BodyPart(
    id: 'forearm',
    title: 'Forearm',
    description: 'Practice positioning for forearm radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['AP', 'Lateral'],
  );
  // ... Add all other body parts using _placeholderImage ...
  static const BodyPart elbow = BodyPart(
    id: 'elbow',
    title: 'Elbow',
    description: 'Practice positioning for elbow radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['AP', 'Lateral', 'Oblique'],
  );
  static const BodyPart humerus = BodyPart(
    id: 'humerus',
    title: 'Humerus',
    description: 'Practice positioning for humerus radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['AP', 'Lateral'],
  );
  static const BodyPart shoulder = BodyPart(
    id: 'shoulder',
    title: 'Shoulder',
    description: 'Practice positioning for shoulder radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['AP Internal', 'AP External', 'Grashey'],
  );

  // Head & Neck
  static const BodyPart skull = BodyPart(
    id: 'skull',
    title: 'Skull',
    description: 'Practice positioning for skull radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['AP', 'Lateral', 'Townes'],
  );
  static const BodyPart facialBones = BodyPart(
    id: 'facial_bones',
    title: 'Facial Bones',
    description: 'Practice positioning for facial bone radiographs.',
    imageAsset: _placeholderImage, // Use placeholder
    projections: ['Waters', 'Lateral', 'Caldwell'],
  );
  // ... Add all other body parts using _placeholderImage ...
}
