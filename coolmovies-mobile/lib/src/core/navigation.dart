import "package:flutter/material.dart";

/// Wrapper of [Navigator] that facilitates pushing new pages
mixin Navigation {
  BuildContext get context;

  /// A wrapper of Navigator.of(context).push that pushes [page] to the route
  /// ```dart
  /// Navigator.of(context).push(
  ///   MaterialPageRoute(builder: (context) => page),
  /// );
  /// ```
  void navigateTo(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
