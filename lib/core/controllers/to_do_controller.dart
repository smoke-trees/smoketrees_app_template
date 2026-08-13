import 'package:get/get.dart';
import 'package:smoketrees_app_template/core/network/dio_controllers/entity_dio_extension.dart';
import 'package:smoketrees_app_template/core/network/response.dart';
import 'package:smoketrees_app_template/utils/console_logger.dart';

import '../models/to_do.dart';
import 'user_controller.dart';

class ToDoController extends GetxController {
  static ToDoController get to => Get.find();

  final EntityDio _entityDio = EntityDio(path: 'to-do');
  RxMap<String, ToDo> toDoMap = RxMap<String, ToDo>();

  Future<List<ToDo>> fetchToDos({int? page, int? count}) async {
    try {
      var response = await _entityDio.readMany(
        page: page,
        count: count,
        params: {'userId': UserController.to.user?.id},
        orderBy: 'serialNumber',
      );
      if (response.status.error || (response.result?.isEmpty ?? true)) {
        return [];
      }

      List<ToDo> toDoList = response.result!
          .map((e) => ToDo.fromJson(e))
          .toList();
      toDoMap.addAll({for (var toDo in toDoList) toDo.id!: toDo});
      return toDoList;
    } catch (e) {
      ConsoleLogger.error('Error fetching To Dos: $e');
      return [];
    }
  }

  Future<ToDo?> fetchToDoById(String id) async {
    try {
      var response = await _entityDio.read(id);
      if (response.status.error || (response.result?.isEmpty ?? true)) {
        return null;
      }

      ToDo toDo = ToDo.fromJson(response.result!);
      toDoMap.addAll({toDo.id!: toDo});
      return toDo;
    } catch (e) {
      return null;
    }
  }

  Future<String?> createToDo({
    required String userId,
    required String title,
    required String description,
    bool? completed,
  }) async {
    try {
      var response = await _entityDio.postQuery(
        'create',
        data: {
          'userId': userId,
          'title': title,
          'description': description,
          if (completed != null) 'completed': completed,
        },
      );
      if (response.status.error) {
        return null;
      }
      return response.result;
    } catch (e) {
      return null;
    }
  }

  Future<ApiResponse?> updateToDo({
    required String id,
    String? title,
    String? description,
    int? serialNumber,
    required String userId,
    bool? completed,
  }) async {
    try {
      Map<String, dynamic> data = {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        'userId': userId,
        if (serialNumber != null) 'serialNumber': serialNumber,
        if (completed != null) 'completed': completed,
      };
      var response = await _entityDio.put(id, data);

      return response;
    } catch (e) {
      ConsoleLogger.error(e.toString());
      return null;
    }
  }

  Future<ApiResponse?> deleteToDo(String id) async {
    try {
      var response = await _entityDio.delete(id, data: {});

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<ApiResponse?> reshuffleToDos(
    String id,
    int serialNumber,
    String userId,
  ) async {
    try {
      var response = await _entityDio.postQuery(
        'reshuffle',
        data: {'id': id, 'serialNumber': serialNumber, 'userId': userId},
      );

      return response;
    } catch (e) {
      return null;
    }
  }
}
