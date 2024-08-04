import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../core/error.dart";
import "../../domain/movie.dart";
import "../../repository/movie_repository.dart";
import "state_status.dart";

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(super.initialState, this._repo);
  MovieCubit.init(this._repo) : super(MovieState(status: StateStatus.initial));

  final MovieRepository _repo;

  Future<void> fetchAll() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final movies = await _repo.fetchAll();
      emit(state.copyWith(status: StateStatus.loaded, movies: movies));
    } catch (e, st) {
      final failure = Failure(e, st);
      if (kDebugMode) debugPrint(failure.toString());
      emit(state.copyWith(status: StateStatus.error, error: failure));
    }
  }
}

class MovieState {
  MovieState({
    required this.status,
    this.movies = const [],
    this.error,
  });

  final StateStatus status;
  final List<Movie> movies;
  final Failure? error;

  MovieState copyWith({
    StateStatus? status,
    List<Movie>? movies,
    Failure? error,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      error: error ?? this.error,
    );
  }
}
