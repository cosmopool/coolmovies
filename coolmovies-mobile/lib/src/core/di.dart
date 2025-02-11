import "dart:io";

import "package:get_it/get_it.dart";
import "package:graphql_flutter/graphql_flutter.dart";

import "../presenter/bloc/movie_cubit.dart";
import "../presenter/bloc/review_cubit.dart";
import "../presenter/bloc/state_status.dart";
import "../presenter/bloc/user_cubit.dart";
import "../repository/movie_repository.dart";
import "../repository/review_repository.dart";
import "../repository/user_repository.dart";

final getIt = GetIt.instance;

void setupDependencyInjection() {
  final httpLink = HttpLink(
    Platform.isAndroid
        ? "http://10.0.2.2:5001/graphql"
        : "http://localhost:5001/graphql",
  );
  final graphQLClient = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  getIt.registerSingleton(graphQLClient);
  getIt.registerLazySingleton(() => MovieRepository(getIt()));
  getIt.registerLazySingleton(() => ReviewRepository(getIt()));
  getIt.registerLazySingleton(() => UserRepository(getIt()));
  getIt.registerSingleton(MovieState(status: StateStatus.initial));
  getIt.registerSingleton(ReviewState(status: ReviewStatus.initial));
  getIt.registerSingleton(UserState(status: StateStatus.initial));
  getIt.registerLazySingleton(() => MovieCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => ReviewCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => UserCubit(getIt(), getIt()));
}
