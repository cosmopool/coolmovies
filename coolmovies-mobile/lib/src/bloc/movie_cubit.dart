import "package:flutter_bloc/flutter_bloc.dart";

import "../repository/movies_repository.dart";
import "movie_state.dart";

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(super.initialState, this._repo);
  MovieCubit.init(this._repo) : super(MovieState(status: MovieStatus.initial));

  final MoviesRepository _repo;

  Future<void> fetchAll() async {
    emit(state.copyWith(status: MovieStatus.loading));
    try {
      final movies = await _repo.fetchAll();
      emit(state.copyWith(status: MovieStatus.loaded, movies: movies));
    } catch (e) {
      emit(
        state.copyWith(
          status: MovieStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
