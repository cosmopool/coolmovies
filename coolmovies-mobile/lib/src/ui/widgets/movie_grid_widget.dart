import "package:flutter/material.dart";

import "../../core/navigation.dart";
import "../../core/utils.dart";
import "../../domain/movie.dart";
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
    final itemSize = Utils.safeSizeArea(context);

    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: itemSize.width / itemSize.height,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final movie = widget.movies[index];
              return MovieCardWidget(
                onTap: () {},
                movie: movie,
              );
            },
            childCount: widget.movies.length,
          ),
        ),
      ],
    );
  }
}
