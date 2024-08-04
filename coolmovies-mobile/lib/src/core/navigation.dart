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
  void navigateTo(Widget page, Offset begin, Offset end) {
    final animatedDestination = PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
    Navigator.of(context).push(animatedDestination);
  }

  void pushPage(Widget page, [NavAnimation? animation]) {
    switch (animation) {
      case NavAnimation.bottomToTop:
        return navigateTo(page, const Offset(0.0, 1.0), Offset.zero);

      case NavAnimation.fadeIn:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
        return;

      case NavAnimation.rightToLeft: // set rightToLeft as default
      default:
        return navigateTo(page, const Offset(1.0, 0.0), Offset.zero);
    }
  }
}
