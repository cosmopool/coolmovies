import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../bloc/review_cubit.dart";
import "../../../core/di.dart";
import "../../../core/navigation.dart";
import "../../../core/utils.dart";
import "../../../domain/movie.dart";
import "../../../domain/user.dart";
import "../../widgets/review_widget.dart";

class MovieInfoPage extends StatefulWidget {
  const MovieInfoPage({
    super.key,
    required this.movie,
    this.director,
  });

  final Movie movie;
  final String? director;

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> with Navigation {
  final reviewCubit = getIt.get<ReviewCubit>();
  late final _controller = ScrollController();

  double scrollOffset = 0;

  static const padding = EdgeInsets.symmetric(horizontal: 24);

  @override
  void initState() {
    super.initState();
    reviewCubit.fetchAllByMovie(widget.movie);
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
    final colors = Theme.of(context).colorScheme;

    final cover = ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment(0, 0.4),
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

    final subTitleStyle = TextStyle(
      fontWeight: FontWeight.w300,
      color: colors.onSurfaceVariant,
    );

    final director = Padding(
      padding: padding,
      child: Text("Director: ${widget.movie.title}", style: subTitleStyle),
    );

    final releaseYear = Text(
      widget.movie.releaseDate.year.toString(),
      style: subTitleStyle,
    );
    const space = SizedBox(width: 12);
    final info = Padding(
      padding: padding,
      child: Row(
        children: [releaseYear, space],
      ),
    );

    final appBarTitle = Opacity(
      opacity: Utils.normalize(
        scrollOffset,
        min: appBarHeight * 0.6,
        max: appBarHeight * 0.9,
      ),
      child: Text(widget.movie.title),
    );

    return BlocProvider(
      create: (_) => reviewCubit,
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          final reviews =
              state.reviews.where((e) => e.movieId == widget.movie.id).toList();

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: appBarHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    collapseMode: CollapseMode.pin,
                    title: appBarTitle,
                    background: cover,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 32),
                    info,
                    if (widget.director != null) director,
                    const SizedBox(height: 32),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      return ReviewWidget(
                        review: reviews[index],
                        // TODO: remove hardcoded user
                        user: const User(
                          id: "asdf",
                          name: "user name",
                          nodeId: "asdfasdf",
                        ),
                      );
                    },
                    childCount: reviews.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
