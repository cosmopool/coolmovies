import "dart:io";

import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";

import "src/ui/pages/home_page/home_page.dart";

void main() async {
  final HttpLink httpLink = HttpLink(
    Platform.isAndroid
        ? "http://10.0.2.2:5001/graphql"
        : "http://localhost:5001/graphql",
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  runApp(GraphQLProvider(client: client, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Coolmovies"),
    );
  }
}
