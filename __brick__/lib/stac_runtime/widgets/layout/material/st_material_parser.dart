import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_material.dart';

/// Registers the `"material"` type with Stac so JSON payloads can render
/// Flutter's [Material] widget, using the same Stac-native types
/// (StacColor, StacBorderRadius, StacClip, StacTextStyle, StacDuration)
/// as the rest of the DSL.
///
/// Example JSON:
/// ```json
/// {
///   "type": "material",
///   "materialType": "card",
///   "elevation": 4,
///   "color": "#FFFFFF",
///   "shadowColor": "#000000",
///   "borderRadius": { "topLeft": 12, "topRight": 12, "bottomLeft": 12, "bottomRight": 12 },
///   "clipBehavior": "antiAlias",
///   "animationDuration": { "milliseconds": 200 },
///   "child": {
///     "type": "padding",
///     "padding": { "all": 16 },
///     "child": {
///       "type": "text",
///       "data": "Hello, Material!",
///       "style": { "fontSize": 16, "color": "#111111" }
///     }
///   }
/// }
/// ```
///
/// Register alongside your other parsers:
/// ```dart
/// await Stac.initialize(
///   parsers: const [
///     MaterialStacParser(),
///   ],
/// );
/// ```
class StMaterialParser extends StacParser<StMaterial> {
  @override
  String get type => 'st_material';

  @override
  StMaterial getModel(Map<String, dynamic> json) => StMaterial.fromJson(json);

  @override
  Widget parse(BuildContext context, StMaterial model) {
    // Child is resolved recursively through Stac's own StacWidget parsing,
    // so any built-in or custom Stac widget can be nested inside.
    final Widget? child = model.child?.parse(context);

    return Material(
      type: _toMaterialType(model.materialType),
      elevation: model.elevation,
      color: model.color?.toColor(context),
      shadowColor: model.shadowColor?.toColor(context),
      surfaceTintColor: model.surfaceTintColor?.toColor(context),
      textStyle: model.textStyle?.parse(context),
      borderRadius: model.borderRadius?.parse,
      borderOnForeground: model.borderOnForeground,
      clipBehavior: model.clipBehavior.parse,
      animationDuration: model.animationDuration.parse,
      child: child,
    );
  }

  /// Maps the pure-Dart [StacMaterialType] (DSL-safe) back to Flutter's
  /// [MaterialType] at render time.
  MaterialType _toMaterialType(StacMaterialType type) {
    switch (type) {
      case StacMaterialType.canvas:
        return MaterialType.canvas;
      case StacMaterialType.card:
        return MaterialType.card;
      case StacMaterialType.circle:
        return MaterialType.circle;
      case StacMaterialType.button:
        return MaterialType.button;
      case StacMaterialType.transparency:
        return MaterialType.transparency;
    }
  }
}