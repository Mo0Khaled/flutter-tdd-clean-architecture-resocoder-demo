import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:clean_arc/core/platform/networrk_info.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_locale_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/core/exceptions/failuers.dart';
import 'package:clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocaleDataSource localeDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localeDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return (await _getNumberTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number)));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
 return (await _getNumberTrivia(
        () => remoteDataSource.getRandomNumberTrivia()));
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandomNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final trivia = await getConcreteOrRandomNumber();
        await localeDataSource.cacheNumberTrivia(trivia);
        return Right(trivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localeTrivia = await localeDataSource.getLastNumberTrivia();
        return Right(localeTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
