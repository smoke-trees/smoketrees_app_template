import 'package:get/get.dart';

import '../core/services/global_service.dart';
import '../core/controllers/st_data_refresh_controller.dart';
{%- if include_network_layer %}
import '../core/network/dio_controllers/backend_dio.dart';
import '../core/controllers/app_settings_controller.dart';
import '../core/controllers/device_controller.dart';
import '../core/controllers/user_controller.dart';
{%- endif %}

/// Initialize all GetX bindings and services.
///
/// Call `InitBindings().dependencies()` from `main()` before running the app.
class InitBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<GlobalService>(GlobalService(), permanent: true);
    Get.put<StDataRefreshController>(
      StDataRefreshController(),
      permanent: true,
    );

    {%- if include_network_layer %}
    // Network layer (included when include_network_layer is true)
    Get.put<BackendDio>(BackendDio(), permanent: true);
    Get.put<AppSettingsController>(
      AppSettingsController(),
      permanent: true,
    );
    Get.put<DeviceController>(DeviceController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    {%- endif %}
  }
}
