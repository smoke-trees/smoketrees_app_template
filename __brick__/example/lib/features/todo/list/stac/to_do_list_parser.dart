import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'to_do_list_model.dart';
import '../to_do_list_page.dart';

class ToDoListParser extends StacParser<ToDoListModel> {
  const ToDoListParser();

  @override
  String get type => 'to_do_list';

  @override
  ToDoListModel getModel(Map<String, dynamic> json) =>
      ToDoListModel.fromJson(json);

  @override
  Widget parse(BuildContext context, ToDoListModel model) {
    return ToDoListPage(
      appBarTitle: model.appBarTitle,
      toDoTileModel: model.toDoTileModel,
    );
  }
}
