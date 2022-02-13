import 'package:clean_arc/core/exceptions/exception.dart';
import 'package:clean_arc/core/platform/networrk_info.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_locale_data_source%20copy.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arc/core/exceptions/failuers.dart';
import 'package:clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

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
    networkInfo.isConnected;
    try {
      final remoteTrivia =
          await remoteDataSource.getConcreteNumberTrivia(number);
      await localeDataSource.cacheNumberTrivia(remoteTrivia);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return Right(await remoteDataSource.getRandomNumberTrivia());
  }
}
