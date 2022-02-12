import 'package:clean_arc/core/usecases/usecase.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetRandomNumberTriviaUseCase usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(text: "text", number: 1);
  test('should get random number trivia', () async {
    // arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
