import "package:flutter/material.dart";

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonSize = 20.0;
    final colors = Theme.of(context).colorScheme;

    final icon = FittedBox(
      fit: BoxFit.scaleDown,
      child: Icon(Icons.arrow_back_ios_new_rounded, color: colors.onSurface),
    );

    final background = Container(
      height: buttonSize,
      width: buttonSize,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(.6),
      ),
      child: icon,
    );

    return InkWell(
      onTap: Navigator.of(context).pop,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: background,
      ),
    );
  }
}
