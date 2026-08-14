import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/utils/urls.dart';
import 'package:stac/stac.dart';

import 'app/app_pages.dart';
import 'app/init_bindings.dart';
import 'stac_runtime/stac_registry.dart';

/// Hive command:
/// fvm flutter packages pub run build_runner build --delete-conflicting-outputs

/// build_runner command:
/// fvm dart run build_runner build --delete-conflicting-outputs

/// stac watch command:
/// dart run stac_cli/bin/stac_watch.dart

/// stac cli command (Windows -> stac.exe, macOS/Linux -> stac):
/// fvm dart run build_stac.dart "https://your-backend.com/api"

///App Build command
/// fvm flutter build appbundle  --release --obfuscate --split-debug-info=C:\\Av\Work\fomo_app\debug-info
/// fvm flutter build apk  --release --obfuscate --split-debug-info=C:\\Av\Work\fomo_app\debug-info
/// fvm flutter build apk  --release --no-shrink

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget app;
  try {
    await Stac.initialize(
      baseUrl: AppUrls.stacBaseUrl,
      parsers: StacParsers.parsers,
      actionParsers: StacParsers.actionParsers,
      logStackTraces: true,
      showErrorWidgets: true,
    );

    InitBindings().dependencies();

    app = const App();
  } catch (e) {
    app = GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Initialization error: $e'))),
    );
  }

  runApp(app);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      title: 'Stac Template',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      home: const StarterHomePage(),
    );
  }
}

/// Placeholder home that renders without a backend.
///
/// Once your Stac screens exist, switch to `StacApp` (see
/// `example/lib/main.dart`) and map routes in `lib/app/app_pages.dart`.
class StarterHomePage extends StatelessWidget {
  const StarterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stac Template')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Your Stac app starts here.\n\n'
            '1. Add routes in lib/app/app_pages.dart\n'
            '2. Register parsers in lib/stac_runtime/stac_registry.dart\n'
            '3. Copy example/lib content into lib/ to run the full app.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
