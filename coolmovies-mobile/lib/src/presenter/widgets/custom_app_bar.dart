import "package:flutter/material.dart";

import "back_button_widget.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.showBackButton = true,
    this.centerTitle,
    this.actions,
  });

  final Widget? title;
  final Color? backgroundColor;
  final bool showBackButton;
  final bool? centerTitle;
  final List<Widget>? actions;

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
      leading: showBackButton ? const BackButtonWidget() : null,
      actions: actions,
      centerTitle: centerTitle,
      title: title,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      bottom: line,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
