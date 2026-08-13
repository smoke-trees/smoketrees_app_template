// st_animated_icon_toggle_parser.dart
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_animated_icon_toggle.dart';

class StAnimatedIconToggleParser extends StacParser<StAnimatedIconToggle> {
  @override
  String get type => 'animated_icon_toggle';

  @override
  StAnimatedIconToggle getModel(Map<String, dynamic> json) =>
      StAnimatedIconToggle.fromJson(json);

  @override
  Widget parse(BuildContext context, StAnimatedIconToggle model) {
    final isTrue = _resolveTruthy(model.when);
    final iconName = isTrue
        ? StacIcon(
            icon: model.trueIcon,
            size: model.size,
            color: model.trueColor,
          ).parse(context)
        : StacIcon(
            icon: model.falseIcon,
            size: model.size,
            color: model.falseColor,
          ).parse(context);

    return InkWell(
      borderRadius: BorderRadius.circular(model.size),
      onTap: model.onTap == null
          ? null
          : () => Stac.onCallFromJson(model.onTap!.toJson(), context),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: model.durationMs),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: iconName,
        ),
      ),
    );
  }

  bool _resolveTruthy(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final v = value.trim().toLowerCase();
      return v == 'true' || v == '1' || v == 'yes';
    }
    return false;
  }
}
