import "package:flutter/material.dart";

import "../../core/di.dart";
import "../../core/navigation.dart";
import "../bloc/movie_cubit.dart";
import "../bloc/state_status.dart";
import "../widgets/default_page_widget.dart";
import "../widgets/movie_grid_widget.dart";

class AllMoviesPage extends StatefulWidget {
  const AllMoviesPage({super.key, required this.title});

  final String title;

  @override
  State<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> with Navigation {
  final MovieCubit movieCubit = getIt.get<MovieCubit>();

  @override
  void initState() {
    super.initState();
    movieCubit.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget<MovieState>.home(
      appBarTitle: Text(widget.title),
      bloc: movieCubit,
      builder: (context, state) {
        switch (state.status) {
          case StateStatus.initial:
            // TODO: add shimmer on loading
            return const Center(child: CircularProgressIndicator());
          case StateStatus.loading:
            // TODO: add shimmer on loading
            return const Center(child: CircularProgressIndicator());
          case StateStatus.loaded:
            return MovieGridWidget(movies: state.movies);
          case StateStatus.error:
            return Center(child: Text(state.error!.exception.toString()));
        }
      },
    );
  }
}
