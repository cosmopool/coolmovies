import "package:equatable/equatable.dart";

class Review extends Equatable {
  const Review({
    required this.title,
    required this.body,
    required this.rating,
    required this.movieId,
    required this.userId,
  });

  final String title;
  final String body;
  final int rating;
  final String movieId;
  final String userId;

  @override
  List<Object> get props => [title, body, rating, movieId, userId];

  @override
  bool get stringify => true;
}
