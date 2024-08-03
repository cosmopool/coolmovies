import "package:flutter/material.dart";

abstract class Utils {
  static Size safeSizeArea(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final height = size.height - padding.top - padding.bottom;
    // final width = (size.width - padding.left - padding.right) / 2;
    return Size(size.width, height);
  }

  static double normalize(
    double value, {
    required double max,
    required double min,
  }) {
    if (value < min) return 0;
    if (value > max) return 1;
    return (value - min) / (max - min);
  }
}
