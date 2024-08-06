import "dart:async";

import "package:flutter/material.dart";

import "../../core/di.dart";
import "../../core/navigation.dart";
import "../../domain/movie.dart";
import "../../domain/review.dart";
import "../../domain/user.dart";
import "../bloc/review_cubit.dart";
import "../widgets/alert_dialog.dart";
import "../widgets/default_page_widget.dart";

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({
    super.key,
    required this.user,
    required this.movie,
  });

  final User user;
  final Movie movie;

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> with Navigation {
  final _reviewCubit = getIt<ReviewCubit>();
  late final colors = Theme.of(context).colorScheme;
  int rating = 0;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    _reviewCubit.disposeScreen();
  }

  @override
  Widget build(BuildContext context) {
    final saveReviewButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        onPressed: _createReview,
        icon: const Icon(Icons.check_rounded),
      ),
    );

    return DefaultPageWidget<ReviewState>(
      appBarTitle: const Text("Write a Review"),
      centerAppBarTitle: true,
      bloc: _reviewCubit,
      actions: [saveReviewButton],
      listener: (_, state) => _showReviewCreatedDialog(state),
      listenerChild: _buildPage(),
      builder: (_, state) => const SizedBox.shrink(),
    );
  }

  Widget _buildPage() {
    assert(rating >= 0 && rating <= 5);

    final titleField = TextFormField(
      controller: titleController,
      style: TextStyle(color: colors.onSurface),
      decoration: const InputDecoration(
        hintText: "Title",
        border: OutlineInputBorder(),
      ),
    );

    final contentField = TextFormField(
      controller: contentController,
      keyboardType: TextInputType.multiline,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: colors.onSurface),
      decoration: const InputDecoration(
        hintText: "Review",
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
      expands: true,
      maxLines: null,
    );

    const space = SizedBox(height: 24);
    return GestureDetector(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _stars(),
              space,
              titleField,
              space,
              Expanded(flex: 8, child: contentField),
              const Expanded(flex: 1, child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stars() {
    final stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      late IconData icon;
      if (i > rating) {
        icon = Icons.star_border_rounded;
      } else {
        icon = Icons.star_rounded;
      }

      final star = IconButton(
        onPressed: () => setState(() => rating = i),
        icon: Icon(icon),
      );

      stars.add(star);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }

  void _createReview() {
    final review = Review(
      title: titleController.text,
      body: contentController.text,
      rating: rating,
      movieId: widget.movie.id,
      userId: widget.user.id,
    );
    _reviewCubit.create(review);
  }

  Future<void> _showReviewCreatedDialog(ReviewState state) async {
    if (state.status != ReviewStatus.created) return;

    Navigator.of(context).pop();
    return CustomDialog.alert(
      context,
      onPressed: Navigator.of(context).pop,
      buttonLable: "Nice!",
      title: "Review Published!",
      content: "Your review was saved and published in movie page.",
    );
  }
}
