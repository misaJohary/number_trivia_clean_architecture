import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:n_trivia/core/error/exception.dart';
import 'package:n_trivia/features/number_trivia/data/data_sources/local_data_sources.dart';
import 'package:n_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalDataSourceImp localDataSourceImp;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImp =
        LocalDataSourceImp(sharedPreferences: mockSharedPreferences);
  });

  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  group('getLastNumberTrivia', () {
    test('should return the last number trivia cached', () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => fixture('trivia_cached.json'));

      //act
      final result = await localDataSourceImp.getLastNumberTrivia();

      expect(result, tNumberTriviaModel);
    });

    test('should return a cached exception when the cache data is null',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenAnswer((_) => null);

      //act
      final call = localDataSourceImp.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    test('should cache the number trivia', () async {
      when(mockSharedPreferences.setString(any, json.encode(tNumberTriviaModel.toJson()))).thenAnswer((_) async => true);
      localDataSourceImp.cacheNumberTrivia(tNumberTriviaModel);
      verify(mockSharedPreferences.setString(
          any, json.encode(tNumberTriviaModel.toJson())));
    });
  });
}
