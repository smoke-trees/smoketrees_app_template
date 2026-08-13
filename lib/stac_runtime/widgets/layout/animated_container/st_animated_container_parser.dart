import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import '../conditional/st_conditional.dart';

import 'st_animated_container.dart';

class StAnimatedContainerParser extends StacParser<StAnimatedContainer> {
  @override
  String get type => 'animated_container';

  @override
  StAnimatedContainer getModel(Map<String, dynamic> json) =>
      StAnimatedContainer.fromJson(json);

  @override
  Widget parse(BuildContext context, StAnimatedContainer model) {
    final resolvedDecoration = model.decorationWhen != null
        ? StConditional.resolve<StacBoxDecoration>(
            model.decorationWhen,
            whenTrue: model.decorationWhenTrue,
            whenFalse: model.decorationWhenFalse,
          )
        : model.decoration;

    return AnimatedContainer(
      duration: Duration(milliseconds: model.durationMs),
      curve: Curves.easeInOut,
      width: model.width,
      height: model.height,
      padding: model.padding?.parse,
      margin: model.margin?.parse,
      alignment: _resolveAlignment(model.alignment),
      decoration: resolvedDecoration?.parse(context),
      child: model.child == null
          ? null
          : Stac.fromJson(model.child!.toJson(), context),
    );
  }

  Alignment? _resolveAlignment(String? alignment) {
    switch (alignment) {
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      default:
        return null;
    }
  }
}
