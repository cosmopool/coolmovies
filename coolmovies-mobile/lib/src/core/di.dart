import "dart:io";

import "package:get_it/get_it.dart";
import "package:graphql_flutter/graphql_flutter.dart";

import "../bloc/movie_cubit.dart";
import "../repository/movies_repository.dart";

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
  getIt.registerSingleton(MovieState(status: StateStatus.initial));
  getIt.registerLazySingleton(() => MoviesRepository(getIt()));
  getIt.registerFactory<MovieCubit>(() => MovieCubit(getIt(), getIt()));
}
