import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocaleDataSource {

  
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}
