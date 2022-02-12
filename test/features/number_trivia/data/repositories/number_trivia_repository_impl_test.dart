import 'package:clean_arc/core/platform/networrk_info.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_locale_data_source%20copy.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocaleDataSource, NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNumberTriviaLocaleDataSource mockNumberTriviaLocaleDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocaleDataSource = MockNumberTriviaLocaleDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localeDataSource:mockNumberTriviaLocaleDataSource,
      networkInfo:mockNetworkInfo,
    );
  });
}
