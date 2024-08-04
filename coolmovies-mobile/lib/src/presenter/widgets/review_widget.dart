import "package:flutter/material.dart";

import "../../domain/review.dart";
import "../../domain/user.dart";

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.review,
    required this.user,
  });

  final Review review;
  final User user;

  static const borderRadius = BorderRadius.all(Radius.circular(8));
  static const _space = 12.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const space = SizedBox(width: _space, height: _space);

    final rating = Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colors.primary,
      ),
      child: Center(
        child: Text(
          review.rating.toString(),
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final title = Text(
      review.title,
      style: TextStyle(
        color: colors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final header = Row(children: [rating, space, title]);

    final bodyTextStyle = TextStyle(color: colors.onSurface);
    final body = Text(review.body, style: bodyTextStyle);
    final reviewer = Text(user.name, style: bodyTextStyle);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: _space),
      child: Container(
        padding: const EdgeInsets.all(_space),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colors.surfaceContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            space,
            body,
            space,
            const Divider(),
            space,
            reviewer,
          ],
        ),
      ),
    );
  }
}
