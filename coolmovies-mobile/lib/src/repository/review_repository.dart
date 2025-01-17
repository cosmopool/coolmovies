import "package:graphql_flutter/graphql_flutter.dart";

import "../domain/movie.dart";
import "../domain/review.dart";
import "../mappers/review_mapper.dart";

class ReviewRepository {
  ReviewRepository(this._client);

  final GraphQLClient _client;

  Future<List<Review>> fetchAllByMovie(Movie movie) async {
    final result = await _client.query(
      QueryOptions(
        document: gql("""
          query AllMovieReviews {
              allMovieReviews(
                filter: {movieId: {equalTo: "${movie.id}"}}
              ) {
                nodes {
                  title
                  body
                  rating
                  movieId
                  userReviewerId
                }
              }
          }
        """),
      ),
    );

    if (result.hasException) throw result.exception!;
    if (result.data == null) return [];

    final reviews = <Review>[];
    final reviewsJson = result.data!["allMovieReviews"]["nodes"] as List;
    for (var json in reviewsJson) {
      if (json == null) continue;
      reviews.add(ReviewMapper.fromMap(json));
    }
    return reviews;
  }

  Future<void> createReview(Review review) async {
    assert(review.title.isNotEmpty);
    assert(review.rating > 0 && review.rating <= 5);
    assert(review.movieId.isNotEmpty);
    assert(review.userId.isNotEmpty);

    final result = await _client.mutate(
      MutationOptions(
        document: gql("""
          mutation {
            createMovieReview(input: {
              movieReview: {
                title: "${review.title}",
                body: "${review.body}",
                rating: ${review.rating},
                movieId: "${review.movieId}",
                userReviewerId: "${review.userId}"
              }})
            {
              movieReview {
                id
              }
            }
          }
      """),
      ),
    );

    if (result.hasException) throw result.exception!;

    final reviewId = result.data?["createMovieReview"]["movieReview"]["id"];
    if (reviewId == null) throw "Not able to create this review";
  }
}
