import "package:equatable/equatable.dart";

class Review extends Equatable {
  const Review({
    required this.title,
    required this.body,
    required this.rating,
    required this.movieId,
  });

  final String title;
  final String body;
  final int rating;
  final String movieId;

  @override
  List<Object> get props => [title, body, rating, movieId];

  @override
  bool get stringify => true;
}
