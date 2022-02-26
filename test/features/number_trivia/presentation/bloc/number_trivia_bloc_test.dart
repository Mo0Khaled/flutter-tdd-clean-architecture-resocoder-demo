import 'package:clean_arc/core/utils/input_converter.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_converete_number_trivia_usecase.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:clean_arc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTriviaUseCase,
  GetRandomNumberTriviaUseCase,
  InputConverter,
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTriviaUseCase mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTriviaUseCase();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTriviaUseCase();
    print(mockGetConcreteNumberTrivia);
    bloc = NumberTriviaBloc(
      inputConverter: mockInputConverter,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    );
  });

  test("initial state should be initial", () {
    // assert
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group("getTriviaForConcreteNumber", () {
    const tNumberString = '12';
    const tNumberParsed = 1;
    const tTrivia = NumberTrivia(text: 'text', number: 1);
    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(const Right(tNumberParsed));
    test(
        'should call the input converter to validate and convert a string to unsigned int',
            () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => const Right(tTrivia));
          // act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInt(any));
          // assert
          verify(mockInputConverter.stringToUnsignedInt(tNumberString));
        });

    test('should emit error state when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Left(InvalidInputFailure()));
      // act
      final expected = [
        const NumberTriviaFailure(
          errorMessage: INVALID_INPUT_FAILURE_MESSAGE,
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      // assert

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
    test('should get data from the use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => const Right(tTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });
  });
}