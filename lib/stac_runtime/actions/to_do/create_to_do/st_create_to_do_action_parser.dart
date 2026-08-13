import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';
import 'package:smoketrees_app_template/core/controllers/st_data_refresh_controller.dart';
import 'package:smoketrees_app_template/features/todo/list/to_do_list_page.dart';

import 'st_create_to_do_action.dart';

class StCreateToDoActionParser extends StacActionParser<StCreateToDoAction> {
  @override
  String get actionType => 'create_to_do';

  @override
  StCreateToDoAction getModel(Map<String, dynamic> json) =>
      StCreateToDoAction.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, StCreateToDoAction model) async {
    final scope = StacFormScope.of(context);

    // Runs every field's validatorRules; false means at least one field
    // failed (its inline error text is now showing) — bail out here, same
    // as any normal Flutter form.
    final isValid = scope?.formKey.currentState?.validate() ?? true;
    if (!isValid) return;

    final formData = scope?.formData;
    final title = (formData?['title'] as String?)?.trim() ?? '';
    final description = (formData?['description'] as String?)?.trim() ?? '';

    final controller = Get.find<ToDoListController>();
    await controller.createToDo(title: title, description: description);
    StDataRefreshController.to.notifyListChanged();
    await Stac.onCallFromJson(StacNavigator.pop().toJson(), context);
  }
}
