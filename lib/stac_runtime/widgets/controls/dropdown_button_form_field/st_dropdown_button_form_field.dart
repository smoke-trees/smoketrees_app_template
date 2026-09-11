import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_dropdown_button_form_field.g.dart';

@JsonSerializable(explicitToJson: true)
class StDropdownButtonFormField extends StacWidget {
  const StDropdownButtonFormField({
    this.id,
    this.endpoint,
    this.items,
    this.actionKey,
    required this.itemTemplate,
    this.valueKey = 'value',
    this.initialValue,
    this.onChanged,
    this.hint,
    this.inputDecorationTheme,
    this.labelText,
    this.helperText,
    this.errorText,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isExpanded = false,
    this.isDense = false,
    this.menuMaxHeight,
  });

  final String? id;
  final String? endpoint;
  final List<Map<String, dynamic>>? items;
  final String? actionKey;
  final Map<String, dynamic> itemTemplate;
  final String valueKey;
  final String? initialValue;
  @JsonKey(fromJson: _actionFromJson, toJson: _actionToJson)
  final StacAction? onChanged;
  final String? hint;
  @JsonKey(fromJson: _decorationThemeFromJson, toJson: _decorationThemeToJson)
  final StacInputDecorationTheme? inputDecorationTheme;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final Map<String, dynamic>? loadingWidget;
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic>? emptyWidget;
  final bool isExpanded;
  final bool isDense;
  final double? menuMaxHeight;

  @override
  String get type => 'st_dropdown_button_form_field';

  factory StDropdownButtonFormField.fromJson(Map<String, dynamic> json) =>
      _$StDropdownButtonFormFieldFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StDropdownButtonFormFieldToJson(this);
}

StacAction? _actionFromJson(Object? value) =>
    value == null ? null : StacAction.fromJson(value as Map<String, dynamic>);

Map<String, dynamic>? _actionToJson(StacAction? value) => value?.toJson();

StacInputDecorationTheme? _decorationThemeFromJson(Object? value) =>
    value == null
        ? null
        : StacInputDecorationTheme.fromJson(value as Map<String, dynamic>);

Map<String, dynamic>? _decorationThemeToJson(StacInputDecorationTheme? value) =>
    value?.toJson();
