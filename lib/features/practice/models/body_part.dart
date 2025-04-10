class BodyPart {
  final String id;
  final String title;
  final String description;
  final List<String> projections;
  final String imageAsset;

  const BodyPart({
    required this.id,
    required this.title,
    required this.description,
    required this.projections,
    required this.imageAsset,
  });
}
