# Template Widgets - Widgets to Add

This document lists widgets from `health_app_agent` that are **NOT** in the template and should be added to `smoketrees_app_template` for future project headstart.

---

## Widgets to Add

### 1. StDropdownButtonFormField

**What it does:** A data-driven `DropdownButtonFormField` whose menu items are built from a template. Supports fetching items from an API endpoint, inline items, or an action key. Each item is rendered via a Stac template with `{{key}}` placeholder injection. Includes loading/error/empty states and form integration.

**Preferable Location:** `lib/stac_runtime/widgets/controls/dropdown_button_form_field/`

**Files to create:**
- `st_dropdown_button_form_field.dart` (StacWidget model)
- `st_dropdown_button_form_field_parser.dart` (Parser + rendering widget)

**Model Code:**
```dart
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
```

**Parser Code:**
```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../utils/action_registry.dart';
import '../../../utils/inject_data.dart';
import 'st_dropdown_button_form_field.dart';

class StDropdownButtonFormFieldParser
    extends StacParser<StDropdownButtonFormField> {
  final Dio dio;

  StDropdownButtonFormFieldParser({Dio? dio}) : dio = dio ?? Dio();

  @override
  String get type => 'st_dropdown_button_form_field';

  @override
  StDropdownButtonFormField getModel(Map<String, dynamic> json) =>
      StDropdownButtonFormField.fromJson(json);

  @override
  Widget parse(BuildContext context, StDropdownButtonFormField model) {
    return _DataDropdownFormField(model: model, dio: dio);
  }
}

class _DataDropdownFormField extends StatefulWidget {
  const _DataDropdownFormField({required this.model, required this.dio});

  final StDropdownButtonFormField model;
  final Dio dio;

  @override
  State<_DataDropdownFormField> createState() => _DataDropdownFormFieldState();
}

class _DataDropdownFormFieldState extends State<_DataDropdownFormField> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.model.initialValue;
    _itemsFuture = _loadItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.model.id;
      if (id != null && _value != null) {
        final formScope = StacFormScope.of(context);
        formScope?.formData[id] = _value!;
      }
    });
  }

  Future<List<Map<String, dynamic>>> _loadItems() async {
    final model = widget.model;
    dynamic data;
    if (model.actionKey case final String key when key.isNotEmpty) {
      data = await ActionRegistry.call(context, key);
    } else if (model.endpoint case final String url when url.isNotEmpty) {
      data = (await widget.dio.get(url)).data;
    } else {
      data = model.items ?? const <Map<String, dynamic>>[];
    }

    if (data is Map<String, dynamic>) {
      data = data['data'];
    }
    if (data is! List) {
      throw const FormatException('Dropdown data must be a list');
    }
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Widget _stateWidget(Map<String, dynamic>? json, Widget fallback) {
    return json == null ? fallback : Stac.fromJson(json, context) ?? fallback;
  }

  Future<void> _handleChanged(String? value, Map<String, dynamic> item) async {
    setState(() => _value = value);
    final id = widget.model.id;
    if (id != null) {
      final formScope = StacFormScope.of(context);
      formScope?.formData[id] = value ?? '';
    }
    final action = widget.model.onChanged;
    if (action != null) {
      final data = <String, dynamic>{...item, 'value': value};
      await Stac.onCallFromJson(injectData(action.toJson(), data), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _stateWidget(
            model.loadingWidget,
            const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return _stateWidget(
            model.errorWidget,
            const Text('Failed to load dropdown items'),
          );
        }
        final items = snapshot.data ?? const <Map<String, dynamic>>[];
        if (items.isEmpty) {
          return _stateWidget(model.emptyWidget, const SizedBox.shrink());
        }
        final values = items
            .map((item) => item[model.valueKey]?.toString())
            .whereType<String>();
        final selected = values.contains(_value) ? _value : null;
        return DropdownButtonFormField<String>(
          initialValue: selected,
          hint: model.hint == null ? null : Text(model.hint!),
          decoration: InputDecoration(
            labelText: model.labelText,
            helperText: model.helperText,
            errorText: model.errorText,
          ).applyDefaults(model.inputDecorationTheme.parse(context)),
          isExpanded: model.isExpanded,
          isDense: model.isDense,
          menuMaxHeight: model.menuMaxHeight,
          items: [
            for (final item in items)
              if (item[model.valueKey] != null)
                DropdownMenuItem<String>(
                  value: item[model.valueKey].toString(),
                  child: Stac.fromJson(
                        injectData(model.itemTemplate, item),
                        context,
                      ) ??
                      const SizedBox.shrink(),
                ),
          ],
          onChanged: (value) {
            final item = items.firstWhere(
              (item) => item[model.valueKey]?.toString() == value,
              orElse: () => <String, dynamic>{},
            );
            _handleChanged(value, item);
          },
        );
      },
    );
  }
}
```

---

### 2. StGenericDataList (Generic version of HealthHabitsList)

**What it does:** A generic data-driven list widget that fetches data from an endpoint, inline items, or action key, then renders each item via a child template with `{{key}}` placeholder injection. Supports loading/error/empty states. This is the reusable pattern behind `HealthHabitsList`.

**Preferable Location:** `lib/stac_runtime/widgets/collections/generic_data_list/`

**Files to create:**
- `st_generic_data_list.dart` (StacWidget model)
- `st_generic_data_list_parser.dart` (Parser + rendering widget)

**Model Code:**
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_generic_data_list.g.dart';

/// A generic data-driven list that renders items via a child template.
/// Supports endpoint, inline items, or actionKey data sources.
/// Placeholders like `{{key}}` in childTemplate are replaced with
/// the fetched/inline/action data at runtime.
@JsonSerializable(explicitToJson: true)
class StGenericDataList extends StacWidget {
  const StGenericDataList({
    this.endpoint,
    this.items,
    this.actionKey,
    required this.childTemplate,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
  });

  final String? endpoint;
  final List<Map<String, dynamic>>? items;
  final String? actionKey;
  final Map<String, dynamic> childTemplate;
  final Map<String, dynamic>? loadingWidget;
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic>? emptyWidget;

  @override
  String get type => 'st_generic_data_list';

  factory StGenericDataList.fromJson(Map<String, dynamic> json) =>
      _$StGenericDataListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StGenericDataListToJson(this);
}
```

**Parser Code:**
```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../utils/action_registry.dart';
import '../../../utils/inject_data.dart';
import 'st_generic_data_list.dart';

class StGenericDataListParser extends StacParser<StGenericDataList> {
  final Dio dio;

  StGenericDataListParser({Dio? dio}) : dio = dio ?? Dio();

  @override
  String get type => 'st_generic_data_list';

  @override
  StGenericDataList getModel(Map<String, dynamic> json) =>
      StGenericDataList.fromJson(json);

  @override
  Widget parse(BuildContext context, StGenericDataList model) {
    if (model.actionKey != null && model.actionKey!.isNotEmpty) {
      return _buildWithAction(context, model);
    }
    if (model.endpoint == null || model.endpoint!.isEmpty) {
      return _buildWithItems(context, model, model.items ?? const []);
    }
    return _buildWithEndpoint(context, model);
  }

  Widget _buildWithAction(BuildContext context, StGenericDataList model) {
    return FutureBuilder<dynamic>(
      future: ActionRegistry.call(context, model.actionKey!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _stateWidget(model.loadingWidget, context) ??
              const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _stateWidget(model.errorWidget, context) ??
              const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data;
        if (data == null) {
          return _stateWidget(model.emptyWidget, context) ?? const SizedBox();
        }
        if (data is List) {
          final items = data.cast<Map<String, dynamic>>();
          return _buildList(context, model, items);
        }
        final mapData = data is Map<String, dynamic> ? data : {'data': data};
        final resolvedJson = injectData(model.childTemplate, mapData);
        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  Widget _buildWithItems(
    BuildContext context,
    StGenericDataList model,
    List<Map<String, dynamic>> items,
  ) {
    if (items.isEmpty) {
      return _stateWidget(model.emptyWidget, context) ?? const SizedBox();
    }
    if (items.length == 1) {
      final resolvedJson = injectData(model.childTemplate, items.first);
      return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
    }
    return _buildList(context, model, items);
  }

  Widget _buildList(
    BuildContext context,
    StGenericDataList model,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++)
          Builder(
            builder: (context) {
              final itemWithIndex = <String, dynamic>{...items[i], 'index': i};
              final resolvedJson = injectData(model.childTemplate, itemWithIndex);
              return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
            },
          ),
      ],
    );
  }

  Widget _buildWithEndpoint(BuildContext context, StGenericDataList model) {
    return FutureBuilder<dynamic>(
      future: dio.get(model.endpoint!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _stateWidget(model.loadingWidget, context) ??
              const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _stateWidget(model.errorWidget, context) ??
              const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data!.data;
        final Map<String, dynamic> mapData =
            data is Map<String, dynamic> ? data : {'data': data as Object};
        final resolvedJson = injectData(model.childTemplate, mapData);
        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  Widget? _stateWidget(Map<String, dynamic>? json, BuildContext context) {
    return json == null ? null : Stac.fromJson(json, context);
  }
}
```

---

### 3. StReactiveWrapper (Generic version of StReactiveHabitCard)

**What it does:** A generic wrapper that reactively rebuilds its child when specific data changes, without rebuilding the entire list. Wraps child in an `Obx` that watches a specific item by ID and resolves `{{placeholder}}` tokens with computed values.

**Preferable Location:** `lib/stac_runtime/widgets/layout/reactive_wrapper/`

**Files to create:**
- `st_reactive_wrapper.dart` (StacWidget model)
- `st_reactive_wrapper_parser.dart` (Parser)

**Model Code:**
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_reactive_wrapper.g.dart';

/// A wrapper that reactively rebuilds its child when data changes.
/// Watches a specific item by [id] from a registered data source
/// and resolves {{placeholder}} tokens with computed values.
@JsonSerializable(explicitToJson: true)
class StReactiveWrapper extends StacWidget {
  const StReactiveWrapper({
    required this.id,
    required this.child,
    required this.dataSourceKey,
  });

  /// The item id to watch for changes.
  final String id;

  /// The Stac widget tree to render with placeholder injection.
  final StacWidget child;

  /// Key identifying the data source to watch (registered in DataRegistry).
  final String dataSourceKey;

  @override
  String get type => 'st_reactive_wrapper';

  factory StReactiveWrapper.fromJson(Map<String, dynamic> json) =>
      _$StReactiveWrapperFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StReactiveWrapperToJson(this);
}
```

**Parser Code:**
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import '../../../utils/inject_data.dart';
import 'st_reactive_wrapper.dart';

class StReactiveWrapperParser extends StacParser<StReactiveWrapper> {
  @override
  String get type => 'st_reactive_wrapper';

  @override
  StReactiveWrapper getModel(Map<String, dynamic> json) =>
      StReactiveWrapper.fromJson(json);

  @override
  Widget parse(BuildContext context, StReactiveWrapper model) {
    return Obx(() {
      // DataSourceRegistry must be registered by the app to provide
      // reactive data streams. Example:
      // DataRegistry.register('habits', () => HealthHabitsController.to.habits);
      final dataSource = DataRegistry.get(model.dataSourceKey);
      if (dataSource == null) return const SizedBox();

      final items = dataSource();
      if (items is! List) return const SizedBox();

      final match = items.where((item) =>
          item is Map<String, dynamic> && item['id'] == model.id);
      if (match.isEmpty) return const SizedBox();

      final item = match.first as Map<String, dynamic>;
      final childJson = model.child.toJson();
      final resolvedJson = injectData(childJson, item);
      return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
    });
  }
}

/// Registry for reactive data sources.
/// Register your GetX observables here.
class DataRegistry {
  DataRegistry._();

  static final Map<String, Function> _sources = {};

  static void register(String key, Function source) {
    _sources[key] = source;
  }

  static Function? get(String key) => _sources[key];
}
```

---

### 4. StProgressHeader (Generic version of HealthProgressHeader)

**What it does:** A configurable progress header showing a circular progress indicator with percentage, count text, and motivational message. Generic version that accepts data via parameters instead of hardcoded state.

**Preferable Location:** `lib/stac_runtime/widgets/layout/progress_header/`

**Files to create:**
- `st_progress_header.dart` (StacWidget model)
- `st_progress_header_parser.dart` (Parser)

**Model Code:**
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_progress_header.g.dart';

/// A progress header showing circular progress with count and message.
@JsonSerializable(explicitToJson: true)
class StProgressHeader extends StacWidget {
  const StProgressHeader({
    required this.total,
    required this.completed,
    this.backgroundColor,
    this.progressColor,
    this.completedMessages,
    this.zeroMessages,
    this.partialMessages,
  });

  final int total;
  final int completed;
  final String? backgroundColor;
  final String? progressColor;
  final List<String>? completedMessages;
  final List<String>? zeroMessages;
  final List<String>? partialMessages;

  @override
  String get type => 'st_progress_header';

  factory StProgressHeader.fromJson(Map<String, dynamic> json) =>
      _$StProgressHeaderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StProgressHeaderToJson(this);
}
```

**Parser Code:**
```dart
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_progress_header.dart';

class StProgressHeaderParser extends StacParser<StProgressHeader> {
  @override
  String get type => 'st_progress_header';

  @override
  StProgressHeader getModel(Map<String, dynamic> json) =>
      StProgressHeader.fromJson(json);

  @override
  Widget parse(BuildContext context, StProgressHeader model) {
    final progress = model.total > 0 ? model.completed / model.total : 0.0;
    final bgColor = _parseColor(model.backgroundColor) ?? const Color(0xFF176B53);
    final progColor = _parseColor(model.progressColor) ?? const Color(0xFFFFC857);

    String message;
    if (model.completed == 0) {
      message = _pickMessage(model.zeroMessages, 'A fresh start is a good start.');
    } else if (model.completed >= model.total) {
      message = _pickMessage(model.completedMessages, 'A beautifully consistent day.');
    } else {
      message = _pickMessage(model.partialMessages, 'You are building a rhythm.');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white24,
                  color: progColor,
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.completed} of ${model.total} complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFD5EEE1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _pickMessage(List<String>? messages, String fallback) {
    if (messages == null || messages.isEmpty) return fallback;
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
```

---

## Summary

| # | Widget | Location | Purpose |
|---|--------|----------|---------|
| 1 | `StDropdownButtonFormField` | `lib/stac_runtime/widgets/controls/dropdown_button_form_field/` | Data-driven dropdown with template rendering |
| 2 | `StGenericDataList` | `lib/stac_runtime/widgets/collections/generic_data_list/` | Generic data list with template injection |
| 3 | `StReactiveWrapper` | `lib/stac_runtime/widgets/layout/reactive_wrapper/` | Reactive rebuild wrapper for individual items |
| 4 | `StProgressHeader` | `lib/stac_runtime/widgets/layout/progress_header/` | Configurable progress header with circular indicator |

## Registration

After adding these widgets, register them in the Stac parser registry:

```dart
StacDirectory.instance.addParser(StDropdownButtonFormFieldParser());
StacDirectory.instance.addParser(StGenericDataListParser());
StacDirectory.instance.addParser(StReactiveWrapperParser());
StacDirectory.instance.addParser(StProgressHeaderParser());
```

## Notes

- **Health-specific widgets** (`AddHabitForm`, `HealthHabitCard`, `HealthProgressHeader`, `StReactiveHabitCard`, `HealthHabitsList`) are domain-specific and should NOT be added to the template. Instead, their **generic versions** above should be used.
- The `inject_data.dart` and `action_registry.dart` utilities already exist in the template.
- All new widgets follow the existing Stac parser pattern: Model class + Parser class + optional internal rendering widget.
- Run `dart run build_runner build` after adding models to generate the `.g.dart` files.
