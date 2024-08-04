import "package:flutter/material.dart";

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
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: child,
        );
      },
      home: const HomePage(title: "Coolmovies"),
    );
  }
}
