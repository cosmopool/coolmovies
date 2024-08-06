import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../core/di.dart";
import "../../core/navigation.dart";
import "../../core/utils.dart";
import "../../domain/movie.dart";
import "../../domain/review.dart";
import "../bloc/review_cubit.dart";
import "../bloc/state_status.dart";
import "../bloc/user_cubit.dart";
import "../widgets/alert_dialog.dart";
import "../widgets/button_widget.dart";
import "../widgets/default_page_widget.dart";
import "../widgets/review_widget.dart";
import "choose_profile_page.dart";
import "write_review_page.dart";

class MovieInfoPage extends StatefulWidget {
  const MovieInfoPage({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> with Navigation {
  final reviewCubit = getIt.get<ReviewCubit>();
  final _userCubit = getIt.get<UserCubit>();
  late final _controller = ScrollController();

  double scrollOffset = 0;

  static const padding = EdgeInsets.symmetric(horizontal: 24);
  late final colors = Theme.of(context).colorScheme;

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

    final cover = ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment(0, 0.4),
          end: Alignment(0, 0.9),
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.network(
        widget.movie.imageUrl,
        width: size.width,
        height: appBarHeight,
        fit: BoxFit.cover,
      ),
    );

    final subTitleStyle = TextStyle(
      fontWeight: FontWeight.w300,
      color: colors.onSurfaceVariant,
    );

    final director = Text(
      "Director: ${widget.movie.director}",
      style: subTitleStyle,
    );
    final dotSeparator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text("•", style: subTitleStyle),
    );
    final releaseYear = Text(
      widget.movie.releaseDate.year.toString(),
      style: subTitleStyle,
    );
    final info = Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [releaseYear, dotSeparator, director],
      ),
    );

    final value = Utils.normalize(
      scrollOffset,
      min: appBarHeight * 0.8,
      max: appBarHeight,
    );
    final appBarTitle = Opacity(
      opacity: value,
      child: Text(
        widget.movie.title,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );

    final createReviewButton = ButtonWidget(
      onPressed: _onWriteReview,
      text: "Write Review",
    );

    return DefaultPageWidget<ReviewState>(
      appBarTitle: appBarTitle,
      appBarBgColor: Color.lerp(null, colors.surface, value),
      bloc: reviewCubit,
      builder: (context, state) {
        final reviews =
            state.reviews.where((e) => e.movieId == widget.movie.id).toList();

        final headerSliver = SliverList(
          delegate: SliverChildListDelegate([
            cover,
            info,
            const SizedBox(height: 32),
            createReviewButton,
            const SizedBox(height: 12),
          ]),
        );

        final reviewList = SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => _buildReviewCard(reviews[index]),
            childCount: reviews.length,
          ),
        );

        return CustomScrollView(
          controller: _controller,
          slivers: [
            headerSliver,
            reviewList,
          ],
        );
        // );
      },
    );
  }

  Widget _buildReviewCard(Review review) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (_, state) {
        if (state.status == StateStatus.error) {
          return Center(child: Text(state.error!.exception.toString()));
        }

        final user = state.users.firstWhereOrNull((u) => u.id == review.userId);
        if (user == null && _userCubit.isReadyToFetch) _userCubit.fetchAll();
        return ReviewWidget(review: review, user: user);
      },
    );
  }

  void _showNoUserSelectedDialog() {
    return CustomDialog.alert(
      context,
      onPressed: () {
        Navigator.of(context).pop();
        pushPage(ChooseProfilePage(movie: widget.movie));
      },
      title: "No active user!",
      content: "You must select a user to be able to write a review!",
      buttonLable: "Select User",
    );
  }

  void _onWriteReview() {
    final user = _userCubit.state.current;
    if (user == null) return _showNoUserSelectedDialog();
    final page = WriteReviewPage(
      user: user,
      movie: widget.movie,
    );

    pushPage(page, NavAnimation.bottomToTop);
  }
}
