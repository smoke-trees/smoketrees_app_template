import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run create_stac_parser.dart <Name> [category] [subdir...]',
    );
    stderr.writeln(
      'Example: dart run create_stac_parser.dart MyWidget layout custom',
    );
    exitCode = 64;
    return;
  }

  final name = args.first;
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
  final pathParts = _pathParts(args.skip(1), defaultCategory: 'layout');
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

  _insertAfter(
    File(_join(['lib', '{{project_name.snakeCase()}}.dart'])),
    "export 'stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart';",
    ["export '$packagePath.dart';", "export '${packagePath}_parser.dart';"],
  );
  _insertAfter(
    File(_join(['lib', 'stac_runtime', 'stac_registry.dart'])),
    '    WildcardPageParser(),',
    ['    ${name}Parser(),'],
  );

  stdout.writeln("Created custom Stac parser '$name'");
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
