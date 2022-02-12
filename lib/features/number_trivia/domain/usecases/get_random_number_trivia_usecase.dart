import '../../../../core/exceptions/failuers.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NumberTrivia,NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
