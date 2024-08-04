import "package:graphql_flutter/graphql_flutter.dart";

import "../domain/movie.dart";
import "../mappers/movie_mapper.dart";

class MovieRepository {
  MovieRepository(this._client);

  final GraphQLClient _client;

  Future<List<Movie>> fetchAll() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(r"""
          query AllMovies {
            allMovies {
              nodes {
                id
                imgUrl
                movieDirectorId
                userCreatorId
                title
                releaseDate
                nodeId
                userByUserCreatorId {
                  id
                  name
                  nodeId
                }
              }
            }
          }
        """),
      ),
    );

    if (result.hasException) throw result.exception!;
    if (result.data == null) return [];

    final movies = <Movie>[];
    final moviesJson = result.data!["allMovies"]["nodes"] as List;
    for (var json in moviesJson) {
      if (json == null) continue;
      final movie = MovieMapper.fromMap(json);
      movies.add(movie);
    }
    return movies;
  }
}
