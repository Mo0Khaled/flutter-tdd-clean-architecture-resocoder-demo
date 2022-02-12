import 'dart:convert';

import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test");

  test('should be as subclass of numberTrivia entity', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test('should retrun a valid model when the json number is an integar',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should retrun a valid model when the json number is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia_double"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      const expectedMap = {
        "text": "test",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
