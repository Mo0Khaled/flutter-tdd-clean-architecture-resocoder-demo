part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaEmpty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaFailure extends NumberTriviaState {
  final String errorMessage;

  const NumberTriviaFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}


class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaLoaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}
