import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../domain/movie.dart";
import "../domain/review.dart";
import "../repository/review_repository.dart";
import "state_status.dart";

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(super.initialState, this._repo);
  ReviewCubit.init(this._repo)
      : super(ReviewState(status: StateStatus.initial));

  final ReviewRepository _repo;

  Future<void> fetchAllByMovie(Movie movie) async {
    if (isClosed) return;

    emit(state.copyWith(status: StateStatus.loading));
    try {
      final reviews = await _repo.fetchAllByMovie(movie);
      emit(state.copyWith(status: StateStatus.loaded, reviews: reviews));
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      emit(
        state.copyWith(status: StateStatus.error, errorMessage: e.toString()),
      );
    }
  }
}

class ReviewState {
  ReviewState({
    required this.status,
    this.reviews = const [],
    this.errorMessage,
  });

  final StateStatus status;
  final List<Review> reviews;
  final String? errorMessage;

  ReviewState copyWith({
    StateStatus? status,
    List<Review>? reviews,
    String? errorMessage,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
