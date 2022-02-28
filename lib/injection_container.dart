import 'package:clean_arc/core/platform/networrk_info.dart';
import 'package:clean_arc/core/utils/input_converter.dart';
import 'package:clean_arc/features/number_trivia/data/datasources/number_trivia_locale_data_source.dart';
import 'package:clean_arc/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_converete_number_trivia_usecase.dart';
import 'package:clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:clean_arc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );
  //! Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));
  //! Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localeDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  //! DataSources
  sl.registerLazySingleton<NumberTriviaLocaleDataSource>(
      () => NumberTriviaLocaleDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(httpClient: sl()));
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());
}
