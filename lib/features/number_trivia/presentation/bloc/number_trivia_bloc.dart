import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_arc/core/exceptions/failuers.dart';
import 'package:clean_arc/core/usecases/usecase.dart';
import 'package:clean_arc/core/utils/input_converter.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_converete_number_trivia_usecase.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - Number must be an integer and above 0 ';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String UNEXPECTED_ERROR = 'Unexpected Error';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTrivia;
  final GetRandomNumberTriviaUseCase getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);

      await Future.sync(
        () => inputEither.fold(
          (failure) => emit(const NumberTriviaFailure(
              errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
            emit(NumberTriviaLoading());

            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
          },
        ),
      );
    });

    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      },
    );
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
          Either<Failure, NumberTrivia> failureOrTrivia) =>
      failureOrTrivia.fold(
        (failure) => emit(
          NumberTriviaFailure(
            errorMessage: _mapFailureToMessage(failure),
          ),
        ),
        (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
      );

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR;
    }
  }
}
