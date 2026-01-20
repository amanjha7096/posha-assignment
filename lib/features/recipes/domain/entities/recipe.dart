class Recipe {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? imageUrl;
  final String? youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  const Recipe({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    this.imageUrl,
    this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  bool get hasVideo => youtubeUrl != null && youtubeUrl!.isNotEmpty;
}
