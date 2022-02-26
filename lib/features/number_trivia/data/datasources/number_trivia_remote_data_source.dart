import 'dart:convert';
import 'dart:io';
import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:http/http.dart' as http;
import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const String BASE_URL = 'http://numbersapi.com/';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>_getTriviaFromUrl('$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String path) async {
    final url = Uri.parse(BASE_URL + path);
    final response = await httpClient.get(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return NumberTriviaModel.fromJson(decodedResponse);
    } else {
      throw ServerException();
    }
  }
}
