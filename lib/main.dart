import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import 'app/app_pages.dart';
import 'app/init_bindings.dart';
import 'core/storage/hive.dart';
import 'shared/cards/custom_error_cards.dart';
import 'shared/pages/custom_error_page.dart';
import 'stac_runtime/stac_registry.dart';
import 'utils/console_logger.dart';
import 'utils/urls.dart';

/// Hive command:
/// fvm flutter packages pub run build_runner build --delete-conflicting-outputs

/// build_runner command:
/// fvm dart run build_runner build --delete-conflicting-outputs

/// stac watch command:
/// dart run stac_cli/bin/stac_watch.dart

/// stac cli command:
/// fvm dart compile exe stac_cli\bin\stac_cli.dart -D STAC_BASE_API_URL="http://192.168.1.17:8080" -o stac.exe

///App Build command
/// fvm flutter build appbundle  --release --obfuscate --split-debug-info=C:\\Av\Work\fomo_app\debug-info
/// fvm flutter build apk  --release --obfuscate --split-debug-info=C:\\Av\Work\fomo_app\debug-info
/// fvm flutter build apk  --release --no-shrink

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20;
      // Get.testMode = true;

      Widget app;

      try {
        await HiveService.initialize();
        await Stac.initialize(
          baseUrl: AppUrls.stacBaseUrl, // was: AppUrls.backendUrl
          parsers: StacParsers.parsers,
          actionParsers: StacParsers.actionParsers,
          logStackTraces: true,
          showErrorWidgets: true,
          cacheConfig: const bool.fromEnvironment('STAC_LOCAL_DEV')
              ? const StacCacheConfig(strategy: StacCacheStrategy.networkOnly)
              : null,
        );

        InitBindings().dependencies();

        // AnalyticsService.initialize();
        app = const App();

        FlutterError.onError = (FlutterErrorDetails details) {
          ConsoleLogger.error(
            '==FLUTTER ERROR==',
            name: "FLUTTER ERROR",
            error: details.exception,
            stackTrace: details.stack,
          );
          app = GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: CustomErrorPage(error: details.exception.toString()),
          );
        };
        ErrorWidget.builder = (FlutterErrorDetails details) {
          ConsoleLogger.error(
            '==WIDGET BUILD ERROR==',
            name: "WIDGET ERROR",
            error: details.exception,
            stackTrace: details.stack,
          );

          return CustomErrorCard(error: details.exceptionAsString());
        };
      } catch (e, stackTrace) {
        ConsoleLogger.error(
          '==INITIALIZATION ERROR==',
          name: "INIT ERROR",
          error: e,
          stackTrace: stackTrace,
        );
        app = GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: CustomErrorPage(error: e.toString()),
        );
      }

      // runApp(
      //   DevicePreview(
      //     enabled: !kReleaseMode,
      //     builder: (context) => app,
      //   ),
      // );
      runApp(app);
    },
    (error, stackTrace) {
      ConsoleLogger.error(
        '==UNCAUGHT DART ERROR==',
        name: "DART ERROR",
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class App extends StatefulWidget {
  final String? starterRoute;

  const App({super.key, this.starterRoute});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);

    return StacApp(
      title: 'Stac App Test',
      homeBuilder: (p0) => Stac(routeName: 'splash_page'),
      routes: AppPages.stacPages,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      themeMode: ThemeMode.light,
      theme: StacAppTheme(name: 'main_theme'),
      darkTheme: StacAppTheme(name: 'main_theme'),
      onGenerateRoute: (settings) {
        ConsoleLogger.info('name ${settings.name}');
        print('Route settings: ${settings.name}');
        return null;
      },
    );

    // return GetMaterialApp(
    //   builder: (context, child) {
    //     return MediaQuery(
    //       data: MediaQuery.of(context).copyWith(
    //         textScaler: const TextScaler.linear(1.0),
    //         devicePixelRatio: 1.0,
    //       ),
    //       child: AppUpdateChecker(child: child!),
    //     );
    //   },
    //   title: 'FOMO',
    //   enableLog: true,
    //   useInheritedMediaQuery: true,
    //   debugShowCheckedModeBanner: false,
    //   initialBinding: InitBindings(),
    //   theme: Themes.theme,
    //   themeMode: ThemeMode.light,
    //   textDirection: TextDirection.ltr,
    //   getPages: AppPages.pages,
    //   onGenerateRoute: (settings) {
    //     log('name ${settings.name}');
    //     print('Route settings: ${settings.name}');
    //     return null;
    //   },
    //   initialRoute: 'hello_world',
    //   // navigatorObservers: [AnalyticsService.observer],
    //   onUnknownRoute: (RouteSettings settings) {
    //     if (kDebugMode) {
    //       print("Unknown route: ${settings.name}");
    //     }
    //     // AppLinks(). getInitialLink().then((value) => print("Initial link: $value"));
    //     return GetPageRoute(
    //       settings: settings,
    //       page: () => const SplashPage(),
    //       opaque: true,
    //     );
    //   },
    //   unknownRoute: GetPage(
    //     name: SplashPage.routeName,
    //     page: () => const SplashPage(),
    //     opaque: true,
    //   ),
    // );
  }
}
