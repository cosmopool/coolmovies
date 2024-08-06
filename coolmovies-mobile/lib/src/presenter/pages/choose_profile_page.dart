import "package:flutter/material.dart";

import "../../core/di.dart";
import "../../core/navigation.dart";
import "../../domain/movie.dart";
import "../bloc/state_status.dart";
import "../bloc/user_cubit.dart";
import "../widgets/button_widget.dart";
import "../widgets/default_page_widget.dart";
import "write_review_page.dart";

class ChooseProfilePage extends StatefulWidget {
  const ChooseProfilePage({
    super.key,
    this.movie,
  });

  final Movie? movie;

  @override
  State<ChooseProfilePage> createState() => _ChooseProfilePageState();
}

class _ChooseProfilePageState extends State<ChooseProfilePage> with Navigation {
  final _userCubit = getIt<UserCubit>();

  @override
  void initState() {
    super.initState();
    if (_userCubit.state.status == StateStatus.initial) _userCubit.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget<UserState>(
      appBarTitle: const Text("Profiles"),
      useSafeArea: false,
      extendBodyBehindAppBar: true,
      centerAppBarTitle: true,
      appBarBgColor: Colors.transparent,
      showGradientBackground: true,
      bloc: _userCubit,
      builder: (_, state) {
        switch (state.status) {
          case StateStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case StateStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case StateStatus.loaded:
            return _buildPage(context, state);
          case StateStatus.error:
            return Center(child: Text(state.error!.exception.toString()));
        }
      },
    );
  }

  Widget _buildPage(BuildContext context, UserState state) {
    final colors = Theme.of(context).colorScheme;
    const avatarRadius = 58.0;

    final userAvatarList = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.users.length,
      itemBuilder: (_, index) {
        final user = state.users[index];

        final name = Text(
          user.name,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        );

        final avatar = CircleAvatar(
          backgroundColor: colors.primary,
          radius: avatarRadius,
          child: CircleAvatar(
            backgroundColor: colors.inversePrimary,
            radius: user == state.current ? avatarRadius - 6 : avatarRadius,
            child: Icon(
              Icons.supervised_user_circle,
              color: colors.primary.withOpacity(0.05),
              size: (avatarRadius - 6) * 2,
            ),
          ),
        );

        final avatarButton = InkWell(
          onTap: () => _userCubit.setCurrent(user),
          child: avatar,
        );

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              avatarButton,
              const SizedBox(height: 6),
              name,
            ],
          ),
        );
      },
    );

    final createReviewButton = ButtonWidget(
      onPressed: _onWriteReview,
      text: "Write Review",
    );

    final user = _userCubit.state.current;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: avatarRadius * 3, child: userAvatarList),
          const SizedBox(height: 32),
          if (widget.movie != null && user != null) createReviewButton,
        ],
      ),
    );
  }

  void _onWriteReview() {
    final user = _userCubit.state.current;
    if (user == null) return;
    assert(widget.movie != null);

    Navigator.of(context).pop();
    final page = WriteReviewPage(
      user: user,
      movie: widget.movie!,
    );

    pushPage(page, NavAnimation.bottomToTop);
  }
}
