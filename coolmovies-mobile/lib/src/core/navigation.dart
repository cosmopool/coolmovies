import "package:flutter/material.dart";

enum NavAnimation { rightToLeft, bottomToTop, fadeIn }

/// Wrapper of [Navigator] that facilitates pushing new pages
mixin Navigation {
  BuildContext get context;

  /// A wrapper of Navigator.of(context).push that pushes [page] to the route
  /// ```dart
  /// Navigator.of(context).push(
  ///   MaterialPageRoute(builder: (context) => page),
  /// );
  /// ```
  void _navigateTo(
    Widget page,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
        transitionsBuilder,
  ) {
    final animatedDestination = PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (ctx, animation, animation2, child) {
        return transitionsBuilder(ctx, animation, animation2, child);
      },
    );
    Navigator.of(context).push(animatedDestination);
  }

  void pushPage(Widget page, [NavAnimation? animation]) {
    switch (animation) {
      case NavAnimation.bottomToTop:
        return _navigateTo(
          page,
          (_, animation, __, child) {
            final tween =
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
            final position = animation.drive(tween);
            return SlideTransition(
              position: position,
              child: child,
            );
          },
        );

      case NavAnimation.fadeIn:
        return _navigateTo(
          page,
          (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case NavAnimation.rightToLeft: // set rightToLeft as default
      default:
        return _navigateTo(
          page,
          (_, animation, __, child) {
            final tween =
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
            final position = animation.drive(tween);
            return SlideTransition(
              position: position,
              child: child,
            );
          },
        );
    }
  }
}
