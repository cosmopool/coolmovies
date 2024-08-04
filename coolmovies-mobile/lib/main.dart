import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "src/core/custom_behaviour.dart";
import "src/core/di.dart";
import "src/presenter/pages/home_page/home_page.dart";

void main() async {
  setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.figtreeTextTheme(Theme.of(context).textTheme);

    return MaterialApp(
      title: "Coolmovies",
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2D3045),
        brightness: Brightness.dark,
        textTheme: textTheme,
      ),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: child,
        );
      },
      home: const HomePage(title: "coolmovies"),
    );
  }
}
