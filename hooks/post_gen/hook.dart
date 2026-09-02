import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final organization = context.vars['organization'] as String;
  final projectName = context.vars['project_name'] as String;
  final includePlatforms = (context.vars['platforms'] as List?)?.cast<String>() ?? ['android', 'ios', 'web'];

  context.logger.info('🔧 Running post-generation setup...\n');

  // 1. Android package structure renaming
  _setupAndroidPackage(context, organization, projectName);

  // 2. Run flutter pub get
  _runFlutterPubGet(context);

  // 3. Run build_runner for code generation
  _runBuildRunner(context);

  // 4. Run stac build to compile Stac screens
  _runStacBuild(context);

  // 5. Print next steps
  _printNextSteps(context, projectName);
}

/// Renames the Android package directory from placeholder to correct organization.project_name structure
void _setupAndroidPackage(HookContext context, String organization, String projectName) {
  context.logger.info('📦 Setting up Android package structure...');

  try {
    // Convert organization to directory path (com.example -> com/example)
    final orgPath = organization.replaceAll('.', '/');

    // Create the correct Android package directory structure
    final androidKotlinDir = Directory(
      'android/app/src/main/kotlin/$orgPath/$projectName',
    );

    // Remove the placeholder directory if it exists
    final placeholderDir = Directory(
      'android/app/src/main/kotlin/com/example/smoketrees_app_template',
    );

    if (placeholderDir.existsSync()) {
      context.logger.detail('  → Removing placeholder directory...');
      placeholderDir.deleteSync(recursive: true);
    }

    // Create the correct directory structure
    if (!androidKotlinDir.existsSync()) {
      androidKotlinDir.createSync(recursive: true);
      context.logger.detail('  → Created directory: android/app/src/main/kotlin/$orgPath/$projectName');
    }

    // Create MainActivity.kt with correct package
    final mainActivityFile = File('${androidKotlinDir.path}/MainActivity.kt');
    mainActivityFile.writeAsStringSync('''package $organization.$projectName

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
''');
    context.logger.success('✓ Android package structure configured');
  } catch (e) {
    context.logger.err('✗ Android setup failed: $e');
    context.logger.warn('  You may need to manually move android/app/src/main/kotlin/com/example/smoketrees_app_template/MainActivity.kt');
  }
}

/// Runs `flutter pub get` to fetch dependencies
void _runFlutterPubGet(HookContext context) {
  context.logger.info('\n📥 Running flutter pub get...');

  try {
    final result = Process.runSync('flutter', ['pub', 'get'], runInShell: true);

    if (result.exitCode == 0) {
      context.logger.success('✓ Dependencies fetched successfully');
    } else {
      context.logger.err('✗ flutter pub get failed with exit code ${result.exitCode}');
      context.logger.detail(result.stderr.toString());
    }
  } catch (e) {
    context.logger.err('✗ Failed to run flutter pub get: $e');
    context.logger.warn('  Run manually: flutter pub get');
  }
}

/// Runs `dart run build_runner build` to generate .g.dart files
void _runBuildRunner(HookContext context) {
  context.logger.info('\n⚙️  Running build_runner for code generation...');

  try {
    final result = Process.runSync(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      context.logger.success('✓ Code generation completed');
    } else {
      context.logger.err('✗ build_runner failed with exit code ${result.exitCode}');
      context.logger.detail(result.stderr.toString());
      context.logger.warn('  This may be normal if there are unresolved imports. Run manually later:');
      context.logger.warn('  → dart run build_runner build --delete-conflicting-outputs');
    }
  } catch (e) {
    context.logger.err('✗ Failed to run build_runner: $e');
    context.logger.warn('  Run manually: dart run build_runner build --delete-conflicting-outputs');
  }
}

/// Runs `stac build` to compile Stac screens
void _runStacBuild(HookContext context) {
  context.logger.info('\n🎨 Running stac build to compile screens...');

  try {
    final result = Process.runSync('stac', ['build'], runInShell: true);

    if (result.exitCode == 0) {
      context.logger.success('✓ Stac screens compiled');
    } else {
      context.logger.err('✗ stac build failed with exit code ${result.exitCode}');
      context.logger.detail(result.stderr.toString());
      context.logger.warn('  This is normal if you haven\'t set up Stac yet. Run later:');
      context.logger.warn('  → stac build');
    }
  } catch (e) {
    context.logger.err('✗ Failed to run stac build: $e');
    context.logger.warn('  stac_cli may not be installed. Install it with:');
    context.logger.warn('  → dart pub global activate stac_cli');
  }
}

/// Prints next steps for the user
void _printNextSteps(HookContext context, String projectName) {
  context.logger.info('\n${'═' * 60}');
  context.logger.success('✨ Project generated successfully!');
  context.logger.info('${'═' * 60}\n');

  context.logger.info('📁 Next steps:');
  context.logger.detail('  1. Navigate to your project:');
  context.logger.detail('     → cd $projectName');
  context.logger.detail('');
  context.logger.detail('  2. Start development with Stac watch mode:');
  context.logger.detail('     → stac watch');
  context.logger.detail('');
  context.logger.detail('  3. In another terminal, run the app:');
  context.logger.detail('     → flutter run');
  context.logger.detail('');
  context.logger.info('📚 Resources:');
  context.logger.detail('  • Stac Documentation: https://stac.smoketrees.dev');
  context.logger.detail('  • Flutter Setup: https://flutter.dev/docs/get-started');
  context.logger.detail('');
  context.logger.info('Happy coding! 🚀\n');
}
