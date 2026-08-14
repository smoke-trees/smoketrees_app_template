import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';
import '../../../../features/todo/list/to_do_list_page.dart';

import 'st_toggle_to_do_action.dart';

class StacToggleToDoActionParser
    extends StacActionParser<StacToggleToDoAction> {
  @override
  String get actionType => 'toggle_to_do';

  @override
  StacToggleToDoAction getModel(Map<String, dynamic> json) =>
      StacToggleToDoAction.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, StacToggleToDoAction model) async {
    final controller = Get.find<ToDoListController>();
    final todo = controller.todos.firstWhereOrNull((t) => t.id == model.id);
    if (todo == null) return;
    await controller.onToggleComplete(todo);
  }
}
