import "package:flutter/material.dart";

import "../../core/navigation.dart";
import "../../core/utils.dart";
import "../../domain/movie.dart";
import "../pages/movie_info_page.dart";
import "movie_card_widget.dart";

class MovieGridWidget extends StatefulWidget {
  const MovieGridWidget({
    super.key,
    required this.movies,
  });

  final List<Movie> movies;

  @override
  State<MovieGridWidget> createState() => _MovieGridWidgetState();
}

class _MovieGridWidgetState extends State<MovieGridWidget> with Navigation {
  @override
  Widget build(BuildContext context) {
    final safeWidth = Utils.safeSizeArea(context).width;
    final size = Size(safeWidth, safeWidth * 1.5);
    const axisSpacing = 10.0;

    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: axisSpacing,
            crossAxisSpacing: axisSpacing,
            childAspectRatio: size.width / size.height,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final movie = widget.movies[index];
              return MovieCardWidget(
                onTap: () => pushPage(MovieInfoPage(movie: movie)),
                movie: movie,
                size: Size(size.width - axisSpacing, size.height),
              );
            },
            childCount: widget.movies.length,
          ),
        ),
      ],
    );
  }
}
