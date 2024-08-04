import "package:flutter/material.dart";

import "back_button_widget.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor,
  });

  final Widget? title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final alpha = backgroundColor?.alpha;
    const lineSize = Size.fromHeight(0.5);
    final line = PreferredSize(
      preferredSize: lineSize,
      child: Container(
        color: alpha == null ? null : colors.outlineVariant.withAlpha(alpha),
        height: lineSize.height,
      ),
    );

    return AppBar(
      leading: const BackButtonWidget(),
      title: title,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? colors.surface,
      bottom: line,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
