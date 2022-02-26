import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_converete_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTriviaUseCase useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: "cece");
  test('should get trivia number from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // act
    final result = await useCase.call(const Params(number: tNumber));
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
