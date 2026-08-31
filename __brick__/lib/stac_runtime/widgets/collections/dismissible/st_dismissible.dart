import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_dismissible.g.dart';

/// Generic [Dismissible] wrapper. Both swipe directions are optional and
/// behave independently:
///
/// - `startToEnd` (left swipe) never actually removes the child â€” it fires
///   [onStartToEnd] and snaps back. Use this for a non-destructive action
///   like "toggle complete".
/// - `endToStart` (right swipe) shows [confirmDialog] (if provided) before
///   removing the child, then fires [onEndToStart] once actually dismissed.
///   Omit [confirmDialog] to dismiss immediately without confirmation.
///
/// ```json
/// {
///   "type": "dismissible",
///   "keyValue": "dismiss-{{id}}",
///   "direction": "horizontal",
///   "background": { "type": "container", "...": "..." },
///   "secondaryBackground": { "type": "container", "...": "..." },
///   "confirmDialog": {
///     "title": "Delete this to-do?",
///     "message": "{{title}} will be removed.",
///     "cancelLabel": "Cancel",
///     "confirmLabel": "Delete"
///   },
///   "onStartToEnd": { "actionType": "toggle_to_do", "id": "{{id}}" },
///   "onEndToStart": { "actionType": "delete_to_do", "id": "{{id}}" },
///   "child": { "type": "animated_container", "...": "..." }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StDismissible extends StacWidget {
  const StDismissible({
    this.keyValue,
    this.direction = 'horizontal',
    this.background,
    this.secondaryBackground,
    this.confirmDialog,
    this.onStartToEnd,
    this.onEndToStart,
    this.child,
  });

  /// String used to build the widget's [ValueKey]. Should be unique per item
  /// (e.g. `'dismiss-{{id}}'`).
  final String? keyValue;

  /// One of: horizontal, vertical, startToEnd, endToStart, up, down, none.
  final String direction;

  final StacWidget? background;
  final StacWidget? secondaryBackground;
  final StDismissibleConfirmDialog? confirmDialog;

  /// Fired on a startToEnd swipe. The swipe always snaps back â€” the child
  /// is never actually removed on this direction.
  final StacAction? onStartToEnd;

  /// Fired after an endToStart swipe is confirmed (or immediately if
  /// [confirmDialog] is null) and the child has been dismissed.
  final StacAction? onEndToStart;

  final StacWidget? child;

  @override
  String get type => 'dismissible';

  factory StDismissible.fromJson(Map<String, dynamic> json) =>
      _$StDismissibleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StDismissibleToJson(this);
}

/// Confirmation dialog shown before an `endToStart` swipe actually removes
/// the item. [message] supports `{{key}}` placeholders â€” since it's nested
/// inside an already-injected item template, placeholders here are resolved
/// by the same pass that resolves the rest of the item.
@JsonSerializable(explicitToJson: true)
class StDismissibleConfirmDialog {
  const StDismissibleConfirmDialog({
    required this.title,
    required this.message,
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'Confirm',
    this.confirmColor,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final StacColor? confirmColor;

  factory StDismissibleConfirmDialog.fromJson(Map<String, dynamic> json) =>
      _$StDismissibleConfirmDialogFromJson(json);

  Map<String, dynamic> toJson() => _$StDismissibleConfirmDialogToJson(this);
}
