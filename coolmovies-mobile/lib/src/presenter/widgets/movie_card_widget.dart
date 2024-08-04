import "package:flutter/material.dart";

import "../../domain/movie.dart";

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
    required this.size,
  });

  final Movie movie;
  final VoidCallback onTap;
  final Size size;

  static const _borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      movie.imageUrl,
      height: size.height,
      width: size.width,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.high,
      loadingBuilder: (_, image, loadingProgress) {
        if (loadingProgress == null) return image;
        return const Center(child: CircularProgressIndicator());
      },
    );
    final imageWidget = ClipRRect(
      borderRadius: _borderRadius,
      child: image,
    );

    final title = Text(
      movie.title,
      style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[300]),
      overflow: TextOverflow.ellipsis,
    );

    final cover = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 50,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: _borderRadius,
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Align(alignment: Alignment.bottomLeft, child: title),
      // child: title,
    );

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        InkWell(onTap: () => onTap(), child: imageWidget),
        cover,
      ],
    );
  }
}
