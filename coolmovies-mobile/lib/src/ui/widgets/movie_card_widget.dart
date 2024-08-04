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

  static const double _width = 130;

  @override
  Widget build(BuildContext context) {
    final image = Hero(
      tag: movie.id,
      child: Image.network(
        movie.imageUrl,
        fit: BoxFit.cover,
        height: 200,
        width: _width,
        filterQuality: FilterQuality.high,
        loadingBuilder: (_, image, loadingProgress) {
          if (loadingProgress == null) return image;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: image,
    );

    final title = SizedBox(
      height: 50,
      width: _width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          movie.title,
          overflow: TextOverflow.fade,
        ),
      ),
    );

    return Column(
      children: [
        InkWell(onTap: () => onTap(), child: imageWidget),
        title,
      ],
    );
  }
}
