import 'package:get/get.dart';
import 'package:smoketrees_app_template/smoketrees_app_template.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalService());
  }
}
