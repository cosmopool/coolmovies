import "dart:convert";

import "../domain/movie.dart";

abstract class MovieMapper {
  static const kId = "id";
  static const kImageUrl = "imageUrl";
  static const kMovieDirectorId = "movieDirectorId";
  static const kUserCreatorId = "userCreatorId";
  static const kTitle = "title";
  static const kReleaseDate = "releaseDate";
  static const kNodeId = "nodeId";

  static Map<String, dynamic> toMap(Movie movie) {
    return <String, dynamic>{
      kId: movie.id,
      kImageUrl: movie.imageUrl,
      kMovieDirectorId: movie.movieDirectorId,
      kUserCreatorId: movie.userCreatorId,
      kTitle: movie.title,
      kReleaseDate: movie.releaseDate.millisecondsSinceEpoch,
      kNodeId: movie.nodeId,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map[kId] as String,
      imageUrl: map[kImageUrl] as String,
      movieDirectorId: map[kMovieDirectorId] as String,
      userCreatorId: map[kUserCreatorId] as String,
      title: map[kTitle] as String,
      releaseDate:
          DateTime.fromMillisecondsSinceEpoch(map[kReleaseDate] as int),
      nodeId: map[kNodeId] as String,
    );
  }

  static String toJson(Movie movie) => json.encode(toMap(movie));

  static fromJson(String source) {
    return fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
