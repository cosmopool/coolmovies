import "package:flutter/material.dart";

import "../../domain/movie.dart";

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.network(
        movie.imageUrl,
        fit: BoxFit.fitHeight,
        filterQuality: FilterQuality.high,
        loadingBuilder: (_, image, loadingProgress) {
          if (loadingProgress == null) return image;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
