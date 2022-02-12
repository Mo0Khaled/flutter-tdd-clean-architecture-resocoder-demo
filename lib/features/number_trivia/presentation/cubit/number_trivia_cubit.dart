import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_state.dart';

class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  NumberTriviaCubit() : super(NumberTriviaInitial());
}
