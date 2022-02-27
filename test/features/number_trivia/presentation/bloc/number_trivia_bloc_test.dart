import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:clean_arc/core/exceptions/failuers.dart';
import 'package:clean_arc/core/usecases/usecase.dart';
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
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tTrivia));
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
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading,loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => const Right(tTrivia));
      // assert
      final expected = [
        NumberTriviaLoading(),
        const NumberTriviaLoaded(trivia: tTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading,failure] when  gotten data fails',
            () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async =>  Left(ServerFailure()));
          // assert
          final expected = [
            NumberTriviaLoading(),
             const NumberTriviaFailure(errorMessage:SERVER_FAILURE_MESSAGE ),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        });

    test('should emit [Loading,failure] with a proper message for the error when getting data fails',
            () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async =>  Left(CacheFailure()));
          // assert
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaFailure(errorMessage:CACHE_FAILURE_MESSAGE ),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'text', number: 1);

    test(
      'should get data from the random use case',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert late
        final expected = [
          NumberTriviaLoading(),
          const NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert late
        final expected = [
          NumberTriviaLoading(),
          const NumberTriviaFailure(errorMessage: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert late
        final expected = [
          NumberTriviaLoading(),
          const NumberTriviaFailure(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
