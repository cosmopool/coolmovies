import "../domain/movie.dart";

enum MovieStatus { initial, loading, loaded, error }

class MovieState {
  MovieState({
    required this.status,
    this.movies = const [],
    this.errorMessage,
  });

  final MovieStatus status;
  final List<Movie> movies;
  final String? errorMessage;

  MovieState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    String? errorMessage,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
