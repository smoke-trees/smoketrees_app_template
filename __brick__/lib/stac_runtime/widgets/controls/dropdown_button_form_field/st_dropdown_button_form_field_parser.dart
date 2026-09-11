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
