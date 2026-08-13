import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_to_do_tile.g.dart';

/// Data-driven wrapper around [ToDoTile].
///
/// Meant to be used as the `itemTemplate` of a
/// [StReorderableListViewBuilder] (or any Stac list), with `{{key}}`
/// placeholders resolved from the item's JSON fields â€” including
/// `{{completed}}`, which drives the completed/in-progress styling.
///
/// ```json
/// {
///   "type": "to_do_tile",
///   "id": "{{id}}",
///   "title": "{{title}}",
///   "description": "{{description}}",
///   "serialNumber": "{{serialNumber}}",
///   "completed": "{{completed}}",
///   "onToggleComplete": { "actionType": "toggle_to_do" },
///   "onDelete": { "actionType": "delete_to_do" }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StToDoTile extends StacWidget {
  const StToDoTile({
    this.id,
    this.title,
    this.description,
    this.serialNumber,
    this.completed,
    this.serialNumberMarkWidth,
    this.serialNumberMarkHeight,
    this.completeColor,
    this.deleteColor,
    this.onToggleComplete,
    this.onDelete,
  });

  final String? id;
  final String? title;
  final String? description;

  /// Accepts either a raw `int`/`String` â€” since placeholder injection
  /// stringifies values, this stays loosely typed and is coerced in the
  /// parser (matches how `ToDoTile` just does `.toString()` on it).
  final dynamic serialNumber;

  /// Accepts either a real `bool` (inline `items`) or a `String`
  /// `"true"`/`"false"` (after `{{completed}}` placeholder injection from
  /// an endpoint response).
  final dynamic completed;

  final double? serialNumberMarkWidth;
  final double? serialNumberMarkHeight;
  final String? completeColor;
  final String? deleteColor;

  /// Dispatched on tap / left-swipe. The parser injects a resolved
  /// `{{completed}}` (the *negated* current value) and `{{id}}` into this
  /// action's JSON before dispatching, so your action can read the new
  /// target state directly.
  final StacAction? onToggleComplete;

  /// Dispatched once the delete swipe is confirmed. `{{id}}` is injected
  /// into this action's JSON before dispatching.
  final StacAction? onDelete;

  @override
  String get type => 'to_do_tile';

  factory StToDoTile.fromJson(Map<String, dynamic> json) =>
      _$StToDoTileFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StToDoTileToJson(this);
}
