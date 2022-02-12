import '../../../../core/exceptions/failuers.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcereteNumberTriviaUseCase implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcereteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];

}
