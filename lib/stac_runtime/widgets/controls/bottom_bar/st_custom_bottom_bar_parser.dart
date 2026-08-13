import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'custom_bottom_bar.dart';
import 'st_custom_bottom_bar.dart';

class StCustomBottomBarParser extends StacParser<StCustomBottomBar> {
  @override
  String get type => 'custom_bottom_bar';

  @override
  StCustomBottomBar getModel(Map<String, dynamic> json) =>
      StCustomBottomBar.fromJson(json);

  @override
  Widget parse(BuildContext context, StCustomBottomBar model) {
    return _CustomBottomBarWidget(model: model);
  }
}

class _CustomBottomBarWidget extends StatefulWidget {
  final StCustomBottomBar model;
  const _CustomBottomBarWidget({required this.model});

  @override
  State<_CustomBottomBarWidget> createState() => _CustomBottomBarWidgetState();
}

class _CustomBottomBarWidgetState extends State<_CustomBottomBarWidget> {
  void _onTap(int index) {
    NavigationScope.of(context)?.controller.index = index;
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final currentIndex = NavigationScope.of(context)?.index ?? 0;

    return CustomBottomBar(
      model: model,
      currentIndex: currentIndex,
      onTap: (index) => _onTap(index),
    );
  }
}
