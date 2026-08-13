import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../../shared/buttons/main_button.dart';
import '../../../../utils/console_logger.dart';
import '../../../actions/action_registry.dart';
import 'st_main_button.dart';

class StMainButtonParser extends StacParser<StMainButton> {
  @override
  StMainButton getModel(Map<String, dynamic> json) =>
      StMainButton.fromJson(json);

  @override
  Widget parse(BuildContext context, StMainButton model) {
    var textStyle = model.textStyle != null
        ? StacTextStyle.fromJson(model.textStyle!.toJson())
        : null;
    return MainButton(
      onTap: () async {
        try {
          if (model.onPressed != null) {
            // New path Ã¢â‚¬â€ the action IS the JSON, written directly in Dart
            // or authored raw as JSON; no registry lookup needed.
            await model.onPressed?.parse(context);
            return;
          }
          // Legacy path Ã¢â‚¬â€ kept for existing screens still using actionKey.
          final action = ActionRegistry.resolve(model.actionKey);
          if (action != null) {
            await action(context);
          } else {
            ConsoleLogger.warn('No action registered for key: ${model.actionKey}');
          }
        } catch (e) {
          ConsoleLogger.error('Error in action: $e');
        }
      },
      title: model.title,
      textStyle: textStyle?.parse(context),
      padding: EdgeInsets.only(
        left: model.padding.left ?? 0,
        right: model.padding.right ?? 0,
        top: model.padding.top ?? 0,
        bottom: model.padding.bottom ?? 0,
      ),
      disabled: model.disabled,
      showLoader: model.showLoader,
      isOutlined: model.isOutlined,
      borderRadius: model.borderRadius,
      color: model.color?.toColor(context),
      textColor: model.textColor?.toColor(context),
      width: model.width,
      borderSide: BorderSide(
        color: model.borderSide?.color?.toColor(context) ?? Colors.black,
        width: model.borderSide?.width ?? 0,
        style: getBorderStyle(model.borderSide),
      ),
      loadingColor: model.loadingColor?.toColor(context),
      fontSize: model.fontSize,
    );
  }

  BorderStyle getBorderStyle(StacBorderSide? borderSide) {
    if (borderSide == null) {
      return BorderStyle.solid;
    }
    switch (borderSide.borderStyle) {
      case StacBorderStyle.solid:
        return BorderStyle.solid;
      case StacBorderStyle.none:
        return BorderStyle.none;
      default:
        return BorderStyle.solid;
    }
  }

  @override
  String get type => 'main_button';
}
