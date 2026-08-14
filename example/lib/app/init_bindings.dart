import 'package:get/get.dart';
import '../core/controllers/st_data_refresh_controller.dart';
import '../features/auth/user_controller.dart';
import '../core/services/app_links.dart';
import '../core/services/global_service.dart';
import '../features/todo/list/to_do_list_page.dart';

import '../core/controllers/app_settings_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AppSettingsController>(AppSettingsController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<GlobalService>(GlobalService(), permanent: true);
    Get.put<AppLinksService>(AppLinksService(), permanent: true);
    Get.put<ToDoListController>(ToDoListController(), permanent: true);
    Get.put<StDataRefreshController>(
      StDataRefreshController(),
      permanent: true,
    );
  }
}
