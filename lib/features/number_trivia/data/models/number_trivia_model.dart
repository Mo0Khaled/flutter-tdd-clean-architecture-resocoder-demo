import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> map) =>
      NumberTriviaModel(
        text: map['text'],
        number: (map['number'] as num).toInt(),
      );

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
