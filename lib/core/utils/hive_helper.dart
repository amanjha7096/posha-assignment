import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String favoritesBox = 'favorites';
  static const String cacheBox = 'cache';

  static late Box<String> _favoritesBox;
  static late Box<String> _cacheBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _favoritesBox = await Hive.openBox<String>(favoritesBox);
    _cacheBox = await Hive.openBox<String>(cacheBox);
  }

  static Box<String> get favoritesBoxInstance => _favoritesBox;
  static Box<String> get cacheBoxInstance => _cacheBox;

  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }
}
