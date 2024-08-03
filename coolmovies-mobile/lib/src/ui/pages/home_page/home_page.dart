import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../bloc/movie_cubit.dart";
import "../../../bloc/movie_state.dart";
import "../../../core/di.dart";
import "../../widgets/movie_card_widget.dart";
import "../../../core/navigation.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Navigation {
  @override
  void initState() {
    super.initState();
    getIt.get<MovieCubit>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<MovieCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              switch (state.status) {
                case MovieStatus.initial:
                  return const Center(child: CircularProgressIndicator());
                case MovieStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case MovieStatus.loaded:
                  return _movieList(state);
                case MovieStatus.error:
                  return Center(child: Text(state.errorMessage!));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _movieList(MovieState state) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, index) => MovieCardWidget(movie: state.movies[index]),
            childCount: state.movies.length,
          ),
        ),
      ],
    );
  }
}
