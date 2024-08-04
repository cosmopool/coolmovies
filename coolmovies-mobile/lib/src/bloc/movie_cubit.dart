import "package:flutter_bloc/flutter_bloc.dart";

import "../domain/movie.dart";
import "../repository/movies_repository.dart";
import "movie_state.dart";

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(super.initialState, this._repo);
  MovieCubit.init(this._repo) : super(MovieState(status: StateStatus.initial));

  final MoviesRepository _repo;

  Future<void> fetchAll() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final movies = await _repo.fetchAll();
      emit(state.copyWith(status: StateStatus.loaded, movies: movies));
    } catch (e) {
      emit(
        state.copyWith(status: StateStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
      );
    }
  }
}
