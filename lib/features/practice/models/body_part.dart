// Placeholder image path
const String _placeholderImage = 'assets/images/alarp_icon.png';

class BodyPart {
  final String id;
  final String title;
  final String description;
  final String imageAsset; // Default/fallback image
  final List<String> projections;
  // New: Map of projection name to specific image asset path
  final Map<String, String>? projectionImages;

  const BodyPart({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset, // Keep as fallback
    required this.projections,
    this.projectionImages, // Add to constructor
  });
}
