import 'dart:convert';

import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_locale_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_locale_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocaleDataSourceImpl dataSourceImpl;

  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocaleDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached')));
    test(
        'should return numberTrivia from shared pref when there is a one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached'));
      // act
      final result = await dataSourceImpl.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a cacheException when there is no cache value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSourceImpl.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test trivia");
    test('should call shared pref to cache the data ', () async {
      final expectedJsonString = json.encode( tNumberTriviaModel.toJson());

      when(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString))
          .thenAnswer((_) async => true);
      // act
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
