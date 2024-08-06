import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../core/error.dart";
import "../../domain/movie.dart";
import "../../domain/review.dart";
import "../../repository/review_repository.dart";

enum ReviewStatus { initial, loading, loaded, creating, created, error }

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(super.initialState, this._repo);
  ReviewCubit.init(this._repo)
      : super(ReviewState(status: ReviewStatus.initial));

  final ReviewRepository _repo;

  void _emitError(Failure failure) =>
      emit(state.copyWith(status: ReviewStatus.error, error: failure));

  Future<void> fetchAllByMovie(Movie movie) async {
    if (isClosed) return;

    emit(state.copyWith(status: ReviewStatus.loading));
    try {
      final reviews = await _repo.fetchAllByMovie(movie);
      reviews.sort((a, b) => b.rating.compareTo(a.rating));
      emit(state.copyWith(status: ReviewStatus.loaded, reviews: reviews));
    } catch (e, st) {
      final failure = Failure(e, st);
      if (kDebugMode) debugPrint(failure.toString());
      _emitError(failure);
    }
  }

  Future<void> create(Review review) async {
    if (isClosed) return;

    emit(state.copyWith(status: ReviewStatus.creating));
    try {
      await _repo.createReview(review);
      final reviews = [...state.reviews];
      reviews.add(review);
      emit(state.copyWith(status: ReviewStatus.created, reviews: reviews));
    } catch (e, st) {
      final failure = Failure(e, st);
      if (kDebugMode) debugPrint(failure.toString());
      _emitError(failure);
    }
  }

  void disposeScreen() => emit(state.copyWith(status: ReviewStatus.loaded));
}

class ReviewState {
  ReviewState({
    required this.status,
    this.reviews = const [],
    this.error,
  });

  final ReviewStatus status;
  final List<Review> reviews;
  final Failure? error;

  ReviewState copyWith({
    ReviewStatus? status,
    List<Review>? reviews,
    Failure? error,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      error: error ?? this.error,
    );
  }
}
