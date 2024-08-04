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
  });

  factory DefaultPageWidget.home({
    required Widget appBarTitle,
    required Cubit<CubitState> bloc,
    required Widget Function(BuildContext, CubitState) builder,
  }) {
    return DefaultPageWidget(
      bloc: bloc,
      builder: builder,
      appBarTitle: appBarTitle,
      useSafeArea: false,
      showBackButton: false,
      extendBodyBehindAppBar: false,
    );
  }

  final Widget appBarTitle;
  final Color? appBarBgColor;
  final bool useSafeArea;
  final bool showBackButton;
  final bool extendBodyBehindAppBar;
  final Cubit<CubitState> bloc;
  final Widget Function(BuildContext, CubitState) builder;

  static const borderRadius = Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
        backgroundColor: appBarBgColor,
        showBackButton: showBackButton,
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: BlocBuilder<Cubit<CubitState>, CubitState>(
        builder: builder,
        bloc: bloc,
      ),
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
