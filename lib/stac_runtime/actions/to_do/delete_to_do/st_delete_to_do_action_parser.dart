import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';
import '../../../../features/todo/list/to_do_list_page.dart';

import 'st_delete_to_do_action.dart';

class StacDeleteToDoActionParser
    extends StacActionParser<StacDeleteToDoAction> {
  @override
  String get actionType => 'delete_to_do';

  @override
  StacDeleteToDoAction getModel(Map<String, dynamic> json) =>
      StacDeleteToDoAction.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, StacDeleteToDoAction model) async {
    final controller = Get.find<ToDoListController>();
    final todo = controller.todos.firstWhereOrNull((t) => t.id == model.id);
    if (todo == null) return;
    await controller.onDeleteToDo(todo);
  }
}
