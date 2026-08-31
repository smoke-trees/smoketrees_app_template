import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_conditional.dart';
import 'st_conditional_widget.dart';

class StConditionalWidgetParser extends StacParser<StConditionalWidget> {
  @override
  String get type => 'st_conditional_widget';

  @override
  StConditionalWidget getModel(Map<String, dynamic> json) =>
      StConditionalWidget.fromJson(json);

  @override
  Widget parse(BuildContext context, StConditionalWidget model) {
    final branch = StConditional.resolve<StacWidget>(
      model.when,
      whenTrue: model.whenTrue,
      whenFalse: model.whenFalse,
    );
    return branch == null
        ? const SizedBox()
        : Stac.fromJson(branch.toJson(), context) ?? const SizedBox();
  }
}
