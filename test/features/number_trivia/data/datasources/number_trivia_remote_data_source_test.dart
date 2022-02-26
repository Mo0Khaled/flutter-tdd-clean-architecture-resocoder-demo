import 'dart:convert';

import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClient;
  setUp(() {
    mockClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockClient);
  });
  void setUpMockHttpClientSuccess() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('trivia'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response('some thing went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached')));
    test(
        'should perform a GET request on a url with number being the endpoint and with app/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess();
      // act
      remoteDataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('$BASE_URL$tNumber'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return numberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess();
      // act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw an ServerException when the response code is 404 or other',
        () async {
      // arrange
          setUpMockHttpClientFailure();
      // act
      final call = remoteDataSource.getConcreteNumberTrivia;
      // assert

      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached')));
    test(
        'should perform a GET request on a url with number being the endpoint and with app/json header',
            () async {
          // arrange
          setUpMockHttpClientSuccess();
          // act
          remoteDataSource.getRandomNumberTrivia();
          // assert
          verify(mockClient.get(Uri.parse('${BASE_URL}random'), headers: {
            'Content-Type': 'application/json',
          }));
        });

    test('should return numberTrivia when the response code is 200 (success)',
            () async {
          // arrange
          setUpMockHttpClientSuccess();
          // act
          final result = await remoteDataSource.getRandomNumberTrivia();

          // assert
          expect(result, equals(tNumberTriviaModel));
        });
    test(
        'should throw an ServerException when the response code is 404 or other',
            () async {
          // arrange
          setUpMockHttpClientFailure();
          // act
          final call = remoteDataSource.getRandomNumberTrivia;
          // assert

          expect(() => call(), throwsA(isInstanceOf<ServerException>()));
        });
  });
}
