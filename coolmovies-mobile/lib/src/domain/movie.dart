import "package:equatable/equatable.dart";

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.imageUrl,
    required this.movieDirectorId,
    required this.userCreatorId,
    required this.title,
    required this.releaseDate,
    required this.nodeId,
    required this.director,
  });

  final String id;
  final String imageUrl;
  final String movieDirectorId;
  final String userCreatorId;
  final String title;
  final DateTime releaseDate;
  final String nodeId;
  final String director;

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        movieDirectorId,
        userCreatorId,
        title,
        releaseDate,
        nodeId,
        director,
      ];

  @override
  bool get stringify => true;
}
