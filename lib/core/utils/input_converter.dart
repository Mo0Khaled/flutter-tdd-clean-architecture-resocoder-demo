import 'package:clean_arc/core/exceptions/failuers.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final temp = int.parse(str);
      if (temp < 0) {
        throw const FormatException();
      }
      return Right(temp);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
