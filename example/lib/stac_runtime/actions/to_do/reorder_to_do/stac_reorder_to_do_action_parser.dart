import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smoketrees_app_template/shared/snackbars/snackbar.dart';
import 'package:stac/stac.dart';

import '../../../../features/auth/user_controller.dart';
import '../../../../features/todo/to_do_controller.dart';
import 'stac_reorder_to_do_action.dart';

class StacReorderToDoActionParser
    implements StacActionParser<StacReorderToDoAction> {
  const StacReorderToDoActionParser();

  @override
  String get actionType => 'reorder_to_do';

  @override
  StacReorderToDoAction getModel(Map<String, dynamic> json) =>
      StacReorderToDoAction.fromJson(json);

  @override
  FutureOr<dynamic> onCall(
    BuildContext context,
    StacReorderToDoAction model,
  ) async {
    final id = model.id?.toString();
    final toIndex = int.tryParse('${model.toIndex ?? ''}');
    if (id == null || id.isEmpty || toIndex == null) return null;

    final userId = (model.userId?.toString().isNotEmpty ?? false)
        ? model.userId.toString()
        : UserController.to.user?.id ?? '';

    final response = await ToDoController.to.reshuffleToDos(
      id,
      toIndex + 1,
      userId,
    );

    if (response == null || response.status.error) {
      if (context.mounted) {
        AppSnackBars.customSnackBar(
          context: context,
          message: "Couldn't reorder",
        );
      }
    }

    return response;
  }
}
