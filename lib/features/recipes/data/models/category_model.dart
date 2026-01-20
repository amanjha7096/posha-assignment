import '../../domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory'].toString(),
      name: json['strCategory'].toString(),
      imageUrl: json['strCategoryThumb']?.toString(),
      description: json['strCategoryDescription']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': id,
      'strCategory': name,
      'strCategoryThumb': imageUrl,
      'strCategoryDescription': description,
    };
  }

  Category toEntity() => Category(
        id: id,
        name: name,
        imageUrl: imageUrl,
        description: description,
      );
}

class CategoryResponse {
  final List<CategoryModel> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final categories = json['categories'];
    if (categories == null || categories is! List) {
      return CategoryResponse(categories: []);
    }

    final categoryList = categories
        .map((category) => CategoryModel.fromJson(category as Map<String, dynamic>))
        .toList();

    return CategoryResponse(categories: categoryList);
  }
}
