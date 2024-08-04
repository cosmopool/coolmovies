import "dart:io";

import "package:get_it/get_it.dart";
import "package:graphql_flutter/graphql_flutter.dart";

import "../presenter/bloc/movie_cubit.dart";
import "../presenter/bloc/review_cubit.dart";
import "../presenter/bloc/state_status.dart";
import "../repository/movie_repository.dart";
import "../repository/review_repository.dart";

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
  getIt.registerLazySingleton(() => MoviesRepository(getIt()));
  getIt.registerLazySingleton(() => ReviewRepository(getIt()));
  getIt.registerSingleton(MovieState(status: StateStatus.initial));
  getIt.registerSingleton(ReviewState(status: StateStatus.initial));
  getIt.registerFactory<MovieCubit>(() => MovieCubit(getIt(), getIt()));
  getIt.registerFactory<ReviewCubit>(() => ReviewCubit(getIt(), getIt()));
}
