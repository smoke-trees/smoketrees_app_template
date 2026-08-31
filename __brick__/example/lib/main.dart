import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/{{project_name}}.dart';

import 'app/app_pages.dart';
import 'app/default_stac_options.dart';
import 'app/init_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const StacApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => GlobalService().init(), permanent: true);

  await Get.putAsync(() => NotificationService().init(), permanent: true);

  Get.put(AppLinksService());
}

class StacApp extends StatelessWidget {
  const StacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '{{app_name}}',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitBindings(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
    );
  }
}
