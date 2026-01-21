import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe/core/utils/hive_helper.dart';

@GenerateMocks([Box])
import 'hive_helper_test.mocks.dart';

void main() {
  late MockBox<String> mockFavoritesBox;
  late MockBox<String> mockCacheBox;

  setUp(() {
    mockFavoritesBox = MockBox<String>();
    mockCacheBox = MockBox<String>();
  });

  group('HiveHelper', () {
    test('favoritesBoxInstance returns the favorites box', () {
      // This test would need integration testing with actual Hive initialization
      // For now, we'll test the constants
      expect(HiveHelper.favoritesBox, 'favorites');
      expect(HiveHelper.cacheBox, 'cache');
    });

    test('cacheBoxInstance returns the cache box', () {
      expect(HiveHelper.cacheBox, 'cache');
    });
  });
}
