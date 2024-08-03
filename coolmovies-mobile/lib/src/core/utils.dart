import "package:flutter/material.dart";

abstract class Utils {
  static Size safeSizeArea(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final height = size.height - padding.top - padding.bottom;
    // final width = (size.width - padding.left - padding.right) / 2;
    return Size(size.width, height);
  }
}
