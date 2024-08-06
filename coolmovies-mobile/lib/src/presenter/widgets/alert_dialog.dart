import "package:flutter/material.dart";

import "button_widget.dart";

abstract class CustomDialog {
  static void alert(
    BuildContext context, {
    required VoidCallback onPressed,
    required String buttonLable,
    required String title,
    required String content,
  }) {
    final colors = Theme.of(context).colorScheme;

    final titleWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );

    final contentWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Text(content, style: TextStyle(color: colors.onSurface)),
    );

    final btn = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ButtonWidget(
        onPressed: onPressed,
        text: buttonLable,
      ),
    );
    const space = SizedBox(height: 12);

    showDialog(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              space,
              titleWidget,
              const Divider(),
              space,
              contentWidget,
              space,
              const Divider(),
              btn,
            ],
          ),
        ),
      ),
    );
  }
}
