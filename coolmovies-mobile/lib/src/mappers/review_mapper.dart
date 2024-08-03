import "dart:convert";

import "../domain/review.dart";

abstract class ReviewMapper {
  static const kTitle = "title";
  static const kBody = "body";
  static const kRating = "rating";
  static const kMovieId = "movieId";

  static Map<String, dynamic> toMap(Review review) {
    return <String, dynamic>{
      kTitle: review.title,
      kBody: review.body,
      kRating: review.rating,
      kMovieId: review.movieId,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return Review(
      title: map[kTitle] as String,
      body: map[kBody] as String,
      rating: map[kRating] as int,
      movieId: map[kMovieId] as String,
    );
  }

  static String toJson(Review review) => json.encode(toMap(review));

  static fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
