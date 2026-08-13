import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_dismissible.dart';

class StDismissibleParser extends StacParser<StDismissible> {
  @override
  String get type => 'dismissible';

  @override
  StDismissible getModel(Map<String, dynamic> json) =>
      StDismissible.fromJson(json);

  @override
  Widget parse(BuildContext context, StDismissible model) {
    return Dismissible(
      key: ValueKey(model.keyValue ?? UniqueKey().toString()),
      direction: _resolveDirection(model.direction),
      background: model.background == null
          ? null
          : Stac.fromJson(model.background!.toJson(), context),
      secondaryBackground: model.secondaryBackground == null
          ? null
          : Stac.fromJson(model.secondaryBackground!.toJson(), context),
      confirmDismiss: (direction) => _confirmDismiss(context, model, direction),
      onDismissed: (direction) => _onDismissed(context, model, direction),
      child: model.child == null
          ? const SizedBox()
          : Stac.fromJson(model.child!.toJson(), context) ?? const SizedBox(),
    );
  }

  Future<bool> _confirmDismiss(
    BuildContext context,
    StDismissible model,
    DismissDirection direction,
  ) async {
    if (direction == DismissDirection.startToEnd) {
      if (model.onStartToEnd != null) {
        await Stac.onCallFromJson(model.onStartToEnd!.toJson(), context);
      }
      return false; // snap back â€” this direction never removes the child
    }

    if (direction == DismissDirection.endToStart) {
      if (model.confirmDialog == null) return true;
      return _showConfirmDialog(context, model.confirmDialog!);
    }

    return false;
  }

  Future<bool> _showConfirmDialog(
    BuildContext context,
    StDismissibleConfirmDialog dialog,
  ) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(dialog.title),
        content: Text(dialog.message),
        actions: [
          TextButton(
            onPressed: () {
              result = false;
              Navigator.of(dialogContext).pop();
            },
            child: Text(dialog.cancelLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  dialog.confirmColor?.toColor(context) ?? Colors.redAccent,
            ),
            onPressed: () {
              result = true;
              Navigator.of(dialogContext).pop();
            },
            child: Text(dialog.confirmLabel),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> _onDismissed(
    BuildContext context,
    StDismissible model,
    DismissDirection direction,
  ) async {
    if (direction == DismissDirection.endToStart &&
        model.onEndToStart != null) {
      await Stac.onCallFromJson(model.onEndToStart!.toJson(), context);
    }
  }

  DismissDirection _resolveDirection(String direction) {
    switch (direction) {
      case 'startToEnd':
        return DismissDirection.startToEnd;
      case 'endToStart':
        return DismissDirection.endToStart;
      case 'vertical':
        return DismissDirection.vertical;
      case 'up':
        return DismissDirection.up;
      case 'down':
        return DismissDirection.down;
      case 'none':
        return DismissDirection.none;
      case 'horizontal':
      default:
        return DismissDirection.horizontal;
    }
  }
}
