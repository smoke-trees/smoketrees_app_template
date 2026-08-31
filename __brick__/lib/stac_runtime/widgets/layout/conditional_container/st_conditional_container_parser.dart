import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import '../conditional/st_conditional.dart';

import 'st_conditional_container.dart';

class StConditionalContainerParser extends StacParser<StConditionalContainer> {
  @override
  String get type => 'conditional_container';

  @override
  StConditionalContainer getModel(Map<String, dynamic> json) =>
      StConditionalContainer.fromJson(json);

  @override
  Widget parse(BuildContext context, StConditionalContainer model) {
    final resolvedDecoration = StConditional.isTruthy(model.when)
        ? model.decorationWhenTrue
        : model.decorationWhenFalse;

    final container = StacContainer(
      width: model.width,
      height: model.height,
      padding: model.padding,
      margin: model.margin,
      alignment: model.alignment,
      decoration: resolvedDecoration,
      child: model.child,
    );

    return Stac.fromJson(container.toJson(), context) ?? const SizedBox();
  }
}
