import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../bloc/movie_cubit.dart";
import "../../bloc/state_status.dart";
import "../../../core/di.dart";
import "../../../core/navigation.dart";
import "../../widgets/movie_grid_widget.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Navigation {
  final MovieCubit movieCubit = getIt.get<MovieCubit>();

  @override
  void initState() {
    super.initState();
    movieCubit.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => movieCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<MovieCubit, MovieState>(
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
          ),
        ),
      ),
    );
  }
}
