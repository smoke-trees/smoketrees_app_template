import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import '../../to_do.dart'; // adjust to your actual ToDo model import
import '../to_do_tile.dart';

import 'st_to_do_tile.dart';

class StToDoTileParser extends StacParser<StToDoTile> {
  @override
  String get type => 'to_do_tile';

  @override
  StToDoTile getModel(Map<String, dynamic> json) => StToDoTile.fromJson(json);

  @override
  Widget parse(BuildContext context, StToDoTile model) {
    final isCompleted = _resolveCompleted(model.completed);

    final todo = ToDo(
      id: model.id,
      title: model.title,
      description: model.description,
      serialNumber: _resolveSerialNumber(model.serialNumber),
      completed: isCompleted,
    );

    return ToDoTile(
      todo: todo,
      serialNumberMarkWidth: model.serialNumberMarkWidth ?? 44,
      serialNumberMarkHeight: model.serialNumberMarkHeight ?? 44,
      completeColor: model.completeColor?.toColor(context),
      deleteColor: model.deleteColor?.toColor(context),
      onToggleComplete: model.onToggleComplete == null
          ? null
          : () => _dispatchToggle(context, model, isCompleted),
      onDelete: model.onDelete == null
          ? null
          : () => _dispatchDelete(context, model),
    );
  }

  Future<void> _dispatchToggle(
    BuildContext context,
    StToDoTile model,
    bool isCompleted,
  ) async {
    final resolved = _injectData(model.onToggleComplete!.toJson(), {
      'id': model.id,
      'completed': !isCompleted,
    });
    await Stac.onCallFromJson(resolved, context);
  }

  Future<void> _dispatchDelete(BuildContext context, StToDoTile model) async {
    final resolved = _injectData(model.onDelete!.toJson(), {'id': model.id});
    await Stac.onCallFromJson(resolved, context);
  }

  bool _resolveCompleted(dynamic completed) {
    if (completed is bool) return completed;
    if (completed is String) return completed.toLowerCase() == 'true';
    return false;
  }

  int? _resolveSerialNumber(dynamic serialNumber) {
    if (serialNumber is int) return serialNumber;
    if (serialNumber is String) return int.tryParse(serialNumber);
    return null;
  }

  /// Same placeholder-injection helper used by the reorderable list
  /// builder, so `{{id}}` / `{{completed}}` inside the action JSON get
  /// resolved with values computed at tap time (not at list-build time).
  dynamic _injectData(dynamic node, Map<String, dynamic> data) {
    if (node is String) {
      final match = RegExp(r'^\{\{(\w+)\}\}$').firstMatch(node);
      if (match != null) {
        final value = data[match.group(1)];
        return value == null ? node : value.toString();
      }
      return node.replaceAllMapped(
        RegExp(r'\{\{(\w+)\}\}'),
        (m) => data[m.group(1)]?.toString() ?? m.group(0)!,
      );
    }
    if (node is Map<String, dynamic>) {
      return node.map((k, v) => MapEntry(k, _injectData(v, data)));
    }
    if (node is List) {
      return node.map((e) => _injectData(e, data)).toList();
    }
    return node;
  }
}
