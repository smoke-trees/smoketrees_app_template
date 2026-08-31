import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'main_button.dart';
import 'st_main_button.dart';

typedef StacActionKeyResolver =
    Future<void> Function(BuildContext context, String actionKey);

class StMainButtonParser extends StacParser<StMainButton> {
  const StMainButtonParser({this.onActionKey});

  final StacActionKeyResolver? onActionKey;

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
          final action = model.onPressed;
          if (action != null) {
            await action.parse(context);
            return;
          }

          final actionKey = model.actionKey;
          if (actionKey != null && onActionKey != null) {
            await onActionKey!(context, actionKey);
          }
        } catch (error, stackTrace) {
          debugPrint('StMainButton action failed: $error\n$stackTrace');
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
