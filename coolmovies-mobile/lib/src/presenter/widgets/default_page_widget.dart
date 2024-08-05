import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "custom_app_bar.dart";

class DefaultPageWidget<CubitState> extends StatelessWidget {
  const DefaultPageWidget({
    super.key,
    required this.bloc,
    required this.builder,
    required this.appBarTitle,
    this.appBarBgColor,
    this.useSafeArea = true,
    this.showBackButton = true,
    this.extendBodyBehindAppBar = true,
    this.centerAppBarTitle = false,
    this.showGradientBackground = false,
    this.actions,
  });

  factory DefaultPageWidget.home({
    Widget? appBarTitle,
    List<Widget>? actions,
    required Cubit<CubitState> bloc,
    required Widget Function(BuildContext, CubitState) builder,
  }) {
    return DefaultPageWidget(
      bloc: bloc,
      builder: builder,
      appBarTitle: appBarTitle,
      useSafeArea: false,
      showBackButton: false,
      extendBodyBehindAppBar: true,
      centerAppBarTitle: true,
      appBarBgColor: Colors.transparent,
      showGradientBackground: true,
      actions: actions,
    );
  }

  final Widget? appBarTitle;
  final Color? appBarBgColor;
  final bool useSafeArea;
  final bool showBackButton;
  final bool extendBodyBehindAppBar;
  final bool centerAppBarTitle;
  final Cubit<CubitState> bloc;
  final Widget Function(BuildContext, CubitState) builder;
  final bool showGradientBackground;
  final List<Widget>? actions;

  static const borderRadius = Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    final blocBuilder = BlocBuilder<Cubit<CubitState>, CubitState>(
      builder: builder,
      bloc: bloc,
    );

    final colors = Theme.of(context).colorScheme;
    final gradientBackground = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.topCenter,
          begin: const Alignment(0, 0.0),
          colors: [
            colors.surface,
            colors.surfaceContainer,
          ],
        ),
      ),
      child: blocBuilder,
    );

    final scaffold = Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
        backgroundColor: appBarBgColor,
        showBackButton: showBackButton,
        centerTitle: centerAppBarTitle,
        actions: actions,
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: showGradientBackground ? gradientBackground : blocBuilder,
    );

    if (!useSafeArea) return scaffold;

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        child: scaffold,
      ),
    );
  }
}
