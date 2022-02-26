import 'package:clean_arc/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsigned int', () {
    test('should return an int when the string represent an unsigned int',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInt(str);
      // assert
      expect(result, const Right(123));
    });
    
    test(
        'should return a Failure when the string is not an int',
       ()async{
         // arrange

         const str = 'abc';
         // act
         final result = inputConverter.stringToUnsignedInt(str);
         // assert
         expect(result,  Left(InvalidInputFailure()));
        
      }
    );
    test(
        'should return a Failure when the string is a negative int',
            ()async{
          // arrange

          const str = '-123';
          // act
          final result = inputConverter.stringToUnsignedInt(str);
          // assert
          expect(result,  Left(InvalidInputFailure()));

        }
    );
  });
}
