import "dart:convert";

import "../domain/movie.dart";

abstract class DirectorKeys {
  static const kName = "name";
  static const kDirector = "movieDirectorByMovieDirectorId";
}

abstract class MovieMapper {
  static const kId = "id";
  static const kImageUrl = "imgUrl";
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
      kReleaseDate: movie.releaseDate.toString(),
      kNodeId: movie.nodeId,
      DirectorKeys.kDirector: movie.director,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map[kId] as String,
      imageUrl: map[kImageUrl] as String,
      movieDirectorId: map[kMovieDirectorId] as String,
      userCreatorId: map[kUserCreatorId] as String,
      title: map[kTitle] as String,
      releaseDate: DateTime.parse(map[kReleaseDate] as String),
      nodeId: map[kNodeId] as String,
      director:
          map[DirectorKeys.kDirector][DirectorKeys.kName] as String,
    );
  }

  static String toJson(Movie movie) => json.encode(toMap(movie));

  static fromJson(String source) {
    return fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
