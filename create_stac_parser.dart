import 'dart:io';

void main(List<String> args) async {
  final injectDataFlag = args.contains('--inject-data');
  final positionalArgs = args.where((a) => !a.startsWith('--')).toList();

  if (positionalArgs.isEmpty) {
    stderr.writeln(
      'Usage: dart run create_stac_parser.dart <Name> [category] [subdir...] [--inject-data]',
    );
    stderr.writeln(
      'Example: dart run create_stac_parser.dart MyWidget layout custom',
    );
    stderr.writeln(
      'Example: dart run create_stac_parser.dart ProductTile collections --inject-data',
    );
    exitCode = 64;
    return;
  }

  final name = positionalArgs.first;
  if (!RegExp(r'^[A-Z][A-Za-z0-9]*$').hasMatch(name)) {
    stderr.writeln(
      'Name must be a PascalCase Dart identifier, such as MyWidget.',
    );
    exitCode = 64;
    return;
  }

  final root = File.fromUri(Platform.script).parent;
  Directory.current = root;
  final snake = _snakeCase(name);
  final type = 'st_$snake';
  final pathParts = _pathParts(
    positionalArgs.skip(1),
    defaultCategory: 'layout',
  );
  final relativeDirectory = [
    'lib',
    'stac_runtime',
    'widgets',
    ...pathParts,
    snake,
  ];
  Directory(_join(relativeDirectory)).createSync(recursive: true);
  final packagePath = [
    'stac_runtime',
    'widgets',
    ...pathParts,
    snake,
    'st_$snake',
  ].join('/');

  final model = File(_join([...relativeDirectory, 'st_$snake.dart']));
  final parser = File(_join([...relativeDirectory, 'st_${snake}_parser.dart']));
  final generated = File(_join([...relativeDirectory, 'st_$snake.g.dart']));

  if (injectDataFlag) {
    model.writeAsStringSync(
      '''import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_$snake.g.dart';

/// Data model for the "$type" Stac widget type.
///
/// Supports data injection via [endpoint], [items], or [actionKey].
/// Placeholders like `{{key}}` in [childTemplate] are replaced with
/// the fetched/inline/action data at runtime.
@JsonSerializable(explicitToJson: true)
class $name extends StacWidget {
  const $name({
    this.endpoint,
    this.items,
    this.actionKey,
    required this.childTemplate,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
  });

  /// API endpoint to fetch data from. When null, [items] or [actionKey] is used.
  final String? endpoint;

  /// Inline item data used when [endpoint] is null.
  final List<Map<String, dynamic>>? items;

  /// Action key registered in [ActionRegistry] to fetch data.
  /// When provided, calls the action and injects the result into [childTemplate].
  /// Returns `Map<String, dynamic>` for single item or `List<Map<String, dynamic>>` for list.
  final String? actionKey;

  /// Stac widget template rendered with injected data.
  /// Placeholders like `{{key}}` are replaced with fetched/inline/action values.
  final Map<String, dynamic> childTemplate;

  /// Stac widget JSON shown while loading.
  final Map<String, dynamic>? loadingWidget;

  /// Stac widget JSON shown when the fetch fails.
  final Map<String, dynamic>? errorWidget;

  /// Stac widget JSON shown when the resolved data is empty.
  final Map<String, dynamic>? emptyWidget;

  @override
  String get type => '$type';

  factory $name.fromJson(Map<String, dynamic> json) =>
      _\$${name}FromJson(json);

  @override
  Map<String, dynamic> toJson() => _\$${name}ToJson(this);
}
''',
    );

    parser.writeAsStringSync('''import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../utils/action_registry.dart';
import '../../../utils/inject_data.dart';
import 'st_$snake.dart';

/// Parses the "$type" Stac widget type.
///
/// Supports data injection: fetches data from [endpoint], uses inline [items],
/// or calls an [ActionRegistry] action by [actionKey], then injects it into
/// [childTemplate] via `{{key}}` placeholders.
class ${name}Parser extends StacParser<$name> {
  final Dio dio;

  ${name}Parser({Dio? dio}) : dio = dio ?? Dio();

  @override
  String get type => '$type';

  @override
  $name getModel(Map<String, dynamic> json) => $name.fromJson(json);

  @override
  Widget parse(BuildContext context, $name model) {
    if (model.actionKey != null && model.actionKey!.isNotEmpty) {
      return _buildWithAction(context, model);
    }
    if (model.endpoint == null || model.endpoint!.isEmpty) {
      return _buildWithItems(context, model, model.items ?? const []);
    }
    return _buildWithEndpoint(context, model);
  }

  Widget _buildWithAction(BuildContext context, $name model) {
    return FutureBuilder<dynamic>(
      future: ActionRegistry.call(context, model.actionKey!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return model.loadingWidget != null
              ? Stac.fromJson(model.loadingWidget, context) ?? const SizedBox()
              : const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return model.errorWidget != null
              ? Stac.fromJson(model.errorWidget, context) ?? const SizedBox()
              : const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data;
        if (data == null) {
          return model.emptyWidget != null
              ? Stac.fromJson(model.emptyWidget, context) ?? const SizedBox()
              : const SizedBox();
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
    $name model,
    List<Map<String, dynamic>> items,
  ) {
    if (items.isEmpty) {
      return model.emptyWidget != null
          ? Stac.fromJson(model.emptyWidget, context) ?? const SizedBox()
          : const SizedBox();
    }
    if(items.length == 1) {
      final resolvedJson = injectData(model.childTemplate, items.first);
      return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
    }
    return _buildList(context, model, items);
  }

  Widget _buildList(
    BuildContext context,
    $name model,
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

  Widget _buildWithEndpoint(BuildContext context, $name model) {
    return FutureBuilder<Response>(
      future: dio.get(model.endpoint!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return model.loadingWidget != null
              ? Stac.fromJson(model.loadingWidget, context) ?? const SizedBox()
              : const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return model.errorWidget != null
              ? Stac.fromJson(model.errorWidget, context) ?? const SizedBox()
              : const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data!.data;
        final Map<String, dynamic> mapData =
            data is Map<String, dynamic> ? data : {'data': data};
        final resolvedJson = injectData(model.childTemplate, mapData);
        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }
}
''');
  } else {
    model.writeAsStringSync(
      '''import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_$snake.g.dart';

/// Data model for the "$type" Stac widget type.
@JsonSerializable(explicitToJson: true)
class $name extends StacWidget {
  const $name({
    this.child,
  });

  final StacWidget? child;

  @override
  String get type => '$type';

  factory $name.fromJson(Map<String, dynamic> json) =>
      _\$${name}FromJson(json);

  @override
  Map<String, dynamic> toJson() => _\$${name}ToJson(this);
}
''',
    );

    parser.writeAsStringSync('''import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_$snake.dart';

/// Parses the "$type" Stac widget type.
class ${name}Parser extends StacParser<$name> {
  @override
  String get type => '$type';

  @override
  $name getModel(Map<String, dynamic> json) => $name.fromJson(json);

  @override
  Widget parse(BuildContext context, $name model) {
    return SizedBox(child: model.child?.parse(context));
  }
}
''');
  }

  _insertAfter(
    File(_join(['lib', 'smoketrees_app_template.dart'])),
    "export 'stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart';",
    ["export '$packagePath.dart';", "export '${packagePath}_parser.dart';"],
  );
  _insertAfter(
    File(_join(['lib', 'stac_runtime', 'stac_registry.dart'])),
    '    WildcardPageParser(),',
    ['    ${name}Parser(),'],
  );

  stdout.writeln("Created custom Stac parser '$name'");
  if (injectDataFlag) {
    stdout.writeln(
      '  Mode:    inject-data (with endpoint/items and childTemplate)',
    );
  }
  stdout.writeln('  Model:   ${model.path}');
  stdout.writeln('  Parser:  ${parser.path}');
  await _runBuildRunner(generated, "part of 'st_$snake.dart';");
}

String _snakeCase(String value) => value
    .replaceAllMapped(
      RegExp(r'([A-Z]+)([A-Z][a-z])'),
      (match) => '${match[1]}_${match[2]}',
    )
    .replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (match) => '${match[1]}_${match[2]}',
    )
    .toLowerCase();

List<String> _pathParts(
  Iterable<String> values, {
  required String defaultCategory,
}) {
  final parts = values
      .expand((value) => value.split(RegExp(r'[\\/]')))
      .where((value) => value.isNotEmpty)
      .toList();
  if (parts.isEmpty) return [defaultCategory];
  if (parts.any((part) => part == '.' || part == '..')) {
    throw ArgumentError('Category and subdirectories cannot contain . or ..');
  }
  return parts;
}

String _join(Iterable<String> parts) => parts.join(Platform.pathSeparator);

void _insertAfter(File file, String anchor, List<String> additions) {
  var contents = file.readAsStringSync();
  final missing = additions.where((line) => !contents.contains(line)).toList();
  if (missing.isEmpty) return;
  if (!contents.contains(anchor)) {
    throw StateError(
      'Could not find registration anchor in ${file.path}: $anchor',
    );
  }
  contents = contents.replaceFirst(anchor, '$anchor\n${missing.join('\n')}');
  file.writeAsStringSync(contents);
}

Future<void> _runBuildRunner(File generated, String partDirective) async {
  generated.deleteSyncIfExists();
  try {
    final result = await Process.start(
      'fvm',
      ['dart', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    final code = await result.exitCode;
    if (code != 0) exitCode = code;
  } on ProcessException {
    generated.writeAsStringSync('''// GENERATED CODE - DO NOT MODIFY BY HAND

$partDirective

// Run `fvm dart run build_runner build --delete-conflicting-outputs`.
''');
    stderr.writeln(
      'fvm was not found. A placeholder was created; run build_runner manually.',
    );
  }
}

extension on File {
  void deleteSyncIfExists() {
    if (existsSync()) deleteSync();
  }
}
