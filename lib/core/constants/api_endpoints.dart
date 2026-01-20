class ApiEndpoints {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Recipes
  static const String searchMeals = '$baseUrl/search.php';
  static const String getMealDetails = '$baseUrl/lookup.php';

  // Categories
  static const String getCategories = '$baseUrl/categories.php';

  // Areas
  static const String getAreas = '$baseUrl/list.php';

  // Filter
  static const String filterByCategory = '$baseUrl/filter.php';
  static const String filterByArea = '$baseUrl/filter.php';
}
