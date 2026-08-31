# Smoketrees App Template - Mason Brick

🚀 **Generate complete Stac (Server-Driven UI) Flutter applications with a single Mason command**

This is a professional, production-ready Mason brick that generates a fully-configured Flutter application with Stac integration, custom widgets, networking, storage, theming, and example screens—no manual setup required.

## Why This Brick?

| Problem | Solution |
|---------|----------|
| ⏰ Cloning and renaming takes 10+ minutes | ⚡ Generate in 30 seconds with one command |
| 🔄 Manual package name replacement is error-prone | ✅ Automatic templating for all identifiers |
| 📦 Wrong bundle IDs on Android/iOS | ✅ Correct IDs generated automatically |
| 🎯 Not sure what to include | ✅ Choose features during generation |
| 🔁 Inconsistent project structure | ✅ Every project follows the same architecture |

## Quick Start

### 1️⃣ Install Mason CLI

```bash
dart pub global activate mason_cli
```

### 2️⃣ Add This Brick

```bash
mason add smoketrees_app \
  --git-url https://github.com/smoke-trees/st_sdui.git \
  --git-path brick
```

### 3️⃣ Generate Your Project

```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.example \
  --app_name "My App"
```

### 4️⃣ Start Development

```bash
cd my_app
stac watch  # Terminal 1: Watch Stac files
flutter run # Terminal 2: Run the app
```

That's it! 🎉

## What Gets Generated

### Complete Project Structure

```
my_app/
├── lib/                              # Main Flutter app
│   ├── main.dart                    # Entry point with Stac initialization
│   ├── my_app.dart                  # Barrel exports (project name)
│   ├── stac_runtime/                # Custom Stac widgets & actions (17+ custom)
│   ├── core/
│   │   ├── network/                 # Dio, interceptors, auth (optional)
│   │   ├── services/                # Global, notifications, app links
│   │   ├── controllers/             # GetX controllers (optional)
│   │   └── storage/                 # Hive setup
│   ├── shared/                      # Reusable components
│   │   ├── animations/              # Scale, slide, fade
│   │   ├── dialogs/                 # Popups, loaders
│   │   ├── shimmer_loading/         # Skeleton screens
│   │   ├── widgets/                 # Carousels, dividers, clipper
│   │   └── snackbars/               # Toast utilities
│   ├── theme/                       # Colors, decorations, styles
│   ├── utils/                       # Assets, URLs, logging
│   └── app/                         # Pages, navigation, bindings
├── example/                          # Reference implementation
│   ├── lib/features/                # Splash, auth, counter (optional)
│   └── stac/                        # Example Stac screens
├── android/                          # Android project (templated)
├── ios/                              # iOS project (templated)
├── [web/, windows/, macos/, linux/] # Generated if selected
├── pubspec.yaml                      # Dependencies (templated)
├── .fvmrc                           # Flutter 3.44.0 pinned
├── analysis_options.yaml            # Linter rules
└── .gitignore                       # Flutter ignores
```

### What's Automatically Configured

✅ Dart package imports with correct name  
✅ Android `applicationId` and `namespace`  
✅ iOS `PRODUCT_BUNDLE_IDENTIFIER`  
✅ App display names across all platforms  
✅ Firebase dependencies (optional)  
✅ Network layer (Dio, auth, interceptors)  
✅ Custom Stac parsers and actions  
✅ Example screens for reference  
✅ All native platform files  
✅ Post-generation setup (pub get, build_runner, stac build)

## Generation Options

### Basic (Interactive Prompts)

```bash
mason make smoketrees_app
# Follow the prompts for project details
```

### With Arguments

```bash
mason make smoketrees_app \
  --project_name health_app \
  --organization com.mycompany \
  --app_name "Health Tracker" \
  --description "Track your daily health" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase false \
  --platforms android ios web \
  --output-dir "./projects/health_app"
```

### With Config File

Create `config.json`:
```json
{
  "project_name": "stac_cart_demo",
  "organization": "com.smoketrees",
  "app_name": "Stac Cart Demo",
  "description": "E-commerce app with Stac",
  "include_example_screens": true,
  "include_network_layer": true,
  "include_firebase": false,
  "platforms": ["android", "ios", "web"]
}
```

Then:
```bash
mason make smoketrees_app -c config.json --output-dir ./stac_cart_demo
```

## Real-World Examples

### Example 1: Minimal Stac App (No Examples, No Network)

```bash
mason make smoketrees_app \
  --project_name minimal_stac \
  --organization com.example \
  --app_name "Minimal Stac" \
  --include_example_screens false \
  --include_network_layer false \
  --include_firebase false

cd minimal_stac
flutter run
```

### Example 2: Full-Featured App with Firebase

```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.mycompany \
  --app_name "My Awesome App" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase true \
  --platforms android ios

cd my_app
# Configure Firebase, then:
stac watch & flutter run
```

### Example 3: Web-Only Development

```bash
mason make smoketrees_app \
  --project_name web_app \
  --organization com.example \
  --app_name "Web App" \
  --platforms web

cd web_app
flutter run -d chrome
```

## Template Variables Reference

| Variable | Type | Example | Purpose |
|----------|------|---------|---------|
| `project_name` | string | `health_habits` | Dart package name, Android namespace, iOS display name |
| `organization` | string | `com.smoketrees` | Android applicationId, iOS bundle identifier |
| `app_name` | string | `Health Habits` | Display name on all platforms |
| `description` | string | `Track health goals` | pubspec.yaml description |
| `include_example_screens` | boolean | `true` | Include `example/lib/features/` demo code |
| `include_network_layer` | boolean | `true` | Include `lib/core/network/` Dio setup |
| `include_firebase` | boolean | `false` | Add Firebase dependencies to pubspec.yaml |
| `platforms` | array | `[android, ios, web]` | Which native platforms to generate |

## Generated Platform Configurations

### Android
- ✅ `applicationId`: `{{organization}}.{{project_name}}`
- ✅ `namespace`: `{{organization}}.{{project_name}}`
- ✅ `android:label`: `{{app_name}}`
- ✅ `MainActivity.kt` with correct package structure
- ✅ `build.gradle.kts` fully configured

### iOS
- ✅ `PRODUCT_BUNDLE_IDENTIFIER`: `{{organization}}.{{project_name}}.Runner`
- ✅ `CFBundleDisplayName`: `{{app_name}}`
- ✅ `CFBundleName`: `{{project_name}}`
- ✅ `project.pbxproj` with correct bundle ID
- ✅ `Info.plist` templated and ready

### Dart
- ✅ `pubspec.yaml`: `name: {{project_name}}`
- ✅ All imports: `import 'package:{{project_name}}/...`
- ✅ Barrel export: `lib/{{project_name}}.dart`

## Included Libraries & Dependencies

### Core
- `flutter` - Flutter SDK
- `get` (^4.6.6) - State management and routing
- `stac` - Server-Driven UI framework from Smoke-Trees

### Networking (when `include_network_layer: true`)
- `dio` (5.10.0) - HTTP client
- `dio_cache_interceptor` - Response caching
- `pretty_dio_logger` - Network logging

### UI & Styling
- `google_fonts` (6.1.0)
- `flutter_svg` (2.2.3)
- `shimmer` (^3.0.0) - Loading animations
- `lottie` (^3.3.2) - JSON animations

### Storage
- `hive_flutter` - Local database
- `hive` - Data storage

### Utilities
- `toastification` (^3.0.3) - Toast notifications
- `fluttertoast` (^9.0.0) - Alternative toasts
- `app_links` (^6.4.1) - Deep linking
- `connectivity_plus` (^7.1.0) - Network detection
- `package_info_plus` (^9.0.1) - App info

### Firebase (when `include_firebase: true`)
- `firebase_messaging` (^16.1.3)
- `flutter_local_notifications` (^19.0.0)

### Development
- `build_runner` - Code generation
- `json_serializable` - JSON parsing
- `hive_generator` - Hive model generation
- `flutter_lints` (^6.0.0) - Linting

## Project After Generation

After `mason make` completes, your project is **immediately ready** to use:

```bash
cd my_app

# Option 1: Run with Stac watch (for development)
stac watch         # Terminal 1
flutter run       # Terminal 2

# Option 2: Just run
flutter run

# Option 3: Specify device
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

## File Templating Examples

### Before (in `__brick__/`)
```dart
import 'package:{{project_name}}/{{project_name}}.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{app_name}}',
    );
  }
}
```

### After (generated for `project_name=health_habits`, `app_name=Health Habits`)
```dart
import 'package:health_habits/health_habits.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Habits',
    );
  }
}
```

## Conditional Sections

### Network Layer
When `include_network_layer: false`, these are excluded:
- `lib/core/network/` (Dio, interceptors, auth)
- `lib/core/controllers/` (GetX controllers)
- Network dependencies in `pubspec.yaml`

### Example Screens
When `include_example_screens: false`, these are excluded:
- `example/lib/features/` (splash, auth, counter screens)
- `example/lib/stac_runtime/` (reference parsers)

### Firebase
When `include_firebase: false`, these are excluded:
- `firebase_messaging` dependency
- `flutter_local_notifications` dependency

### Platforms
Only selected platforms have native files generated:
- `android/` — Only if `platforms` includes `android`
- `ios/` — Only if `platforms` includes `ios`
- `web/`, `windows/`, `macos/`, `linux/` — If selected

## Post-Generation Setup

The brick automatically runs (if hooks are enabled):

```bash
# 1. Create Android package directory structure
# 2. flutter pub get
# 3. dart run build_runner build --delete-conflicting-outputs
# 4. stac build (if stac_cli is installed)
```

If you need to run these manually:

```bash
cd my_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
stac build
```

## Troubleshooting

### "Mason brick not found"

Ensure it's installed:
```bash
mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick
mason get
```

### "No terminal attached"

Use a config file instead of interactive mode:
```bash
mason make smoketrees_app -c config.json
```

### Android build fails

The post-gen hook should have created the correct package structure. If not, manually move:
```bash
mkdir -p android/app/src/main/kotlin/com/yourorg/yourapp
mv android/app/src/main/kotlin/com/example/placeholder/MainActivity.kt \
   android/app/src/main/kotlin/com/yourorg/yourapp/MainActivity.kt
```

### Build runner errors

Normal after generation. Run manually:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### `stac watch` not found

Install Stac CLI:
```bash
dart pub global activate stac_cli
```

## Next Steps After Generation

1. **Explore the Structure**: Read `lib/main.dart` and `lib/stac_runtime/`
2. **Review Examples**: Check `example/lib/features/` for reference code
3. **Customize Theme**: Edit `lib/theme/` for your brand colors
4. **Add Stac Screens**: Create screens in `stac/lib/`
5. **Set Up Backend**: Configure API endpoints in `lib/core/network/`
6. **Configure Firebase**: Follow Firebase setup if needed

## Development Workflow

```bash
# Start development
stac watch & flutter run

# Watch Stac files for changes (Terminal 1)
# stac watch

# In another terminal, run the app (Terminal 2)
# flutter run

# Make changes to:
# - lib/        → Hot reload
# - stac/lib/   → stac watch rebuilds, then hot reload

# When done developing
# Ctrl+C to stop both processes
```

## Project Maintenance

```bash
# Update dependencies
flutter pub upgrade

# Regenerate models
dart run build_runner build --delete-conflicting-outputs

# Rebuild Stac screens
stac build

# Format code
dart format lib/ example/

# Lint check
dart analyze
```

## For Local Development

If you're modifying the brick itself:

```bash
cd smoketrees_app_template
mason make smoketrees_app \
  --project_name test_app \
  --organization com.test \
  --app_name "Test App" \
  --output-dir ./test_output

cd test_output
flutter run

# Clean up when done
cd ..
rm -rf test_output
```

## Mason Brick Installation Methods

### From GitHub (Production)
```bash
mason add smoketrees_app \
  --git-url https://github.com/smoke-trees/st_sdui.git \
  --git-path brick
```

### Local Development
```bash
mason add smoketrees_app \
  --path "C:\smoketrees\app\smoketrees_app_template"
```

### Network Path
```bash
mason add smoketrees_app \
  --path "\\network-path\smoketrees_app_template"
```

## Documentation

- 📖 **[BRICK_README.md](./BRICK_README.md)** - Complete brick reference with features, examples, and troubleshooting
- 🚀 **[MASON_QUICKSTART.md](./MASON_QUICKSTART.md)** - Installation and quick-start guide
- 📋 **[mason_implement.md](./mason_implement.md)** - Implementation recommendations and workflow

## Resources

- 🌐 [Stac Documentation](https://stac.smoketrees.dev)
- 🐦 [Flutter Setup](https://flutter.dev/docs/get-started)
- 🧱 [Mason Documentation](https://docs.brickhub.dev)
- 💬 [GitHub Discussions](https://github.com/smoke-trees/st_sdui/discussions)
- 🐛 [Report Issues](https://github.com/smoke-trees/st_sdui/issues)

## License

Same as the Smoke-Trees/Stac repository. See LICENSE file.

---

**Ready to build? Generate your first app with:**

```bash
mason make smoketrees_app --project_name my_first_app --organization com.example --app_name "My First App"
```

**Happy building! 🚀**
