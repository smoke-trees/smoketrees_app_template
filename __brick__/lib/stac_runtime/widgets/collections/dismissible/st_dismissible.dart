import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_dismissible.g.dart';

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

  final String? keyValue;
  final String direction;
  final StacWidget? background;
  final StacWidget? secondaryBackground;
  final StDismissibleConfirmDialog? confirmDialog;
  final StacAction? onStartToEnd;
  final StacAction? onEndToStart;
  final StacWidget? child;

  @override
  String get type => 'dismissible';

  factory StDismissible.fromJson(Map<String, dynamic> json) =>
      _$StDismissibleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StDismissibleToJson(this);
}

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
