class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;

  const Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
  });
}
