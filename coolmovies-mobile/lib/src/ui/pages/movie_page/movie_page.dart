import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../bloc/movie_cubit.dart";
import "../../../bloc/movie_state.dart";
import "../../../core/di.dart";
import "../../../core/navigation.dart";
import "../../../core/utils.dart";
import "../../../domain/movie.dart";
import "../../../domain/user.dart";
import "../../widgets/review_widget.dart";

class MoviePage extends StatefulWidget {
  const MoviePage({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> with Navigation {
  final movieCubit = getIt.get<MovieCubit>();
  late final _controller = ScrollController();

  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    movieCubit.fetchAll();
    _controller.addListener(_updateOffset);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_updateOffset);
    _controller.dispose();
  }

  void _updateOffset() {
    setState(() => scrollOffset = _controller.offset);
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils.safeSizeArea(context);
    final appBarHeight = size.height * .7;

    final imageWidget = ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment(0, 0.3),
          end: Alignment(0, 1),
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Hero(
        tag: widget.movie.id,
        child: Image.network(
          widget.movie.imageUrl,
          width: size.width,
          height: appBarHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
      ),
    );

    final value = Utils.normalize(
      scrollOffset,
      min: appBarHeight * 0.6,
      max: appBarHeight * 0.9,
    );
    final appBarColor = Color.lerp(
      Colors.transparent,
      AppBarTheme.of(context).backgroundColor,
      value,
    );
    final appBarTitle = Opacity(
      opacity: value,
      child: Text(widget.movie.title),
    );

    return BlocProvider(
      create: (_) => movieCubit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: appBarTitle,
        ),
        body: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                imageWidget,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
