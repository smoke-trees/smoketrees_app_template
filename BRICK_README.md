# Smoketrees App Mason Brick

A complete **Mason brick** for generating Stac (Server-Driven UI) Flutter applications with one command. No repository cloning, no manual package renaming—just instant, fully-configured projects.

## Features

✨ **Complete Project Generation** — Generates entire Flutter app structure with:
- Dart package setup with correct imports
- Android `applicationId` and `namespace`
- iOS `PRODUCT_BUNDLE_IDENTIFIER`
- Stac runtime with custom widgets and actions
- Networking layer (Dio, interceptors, auth)
- Storage integration (Hive)
- Shared widgets (animations, dialogs, forms, shimmer loading)
- Theme utilities and color management
- App routing and navigation
- Example screens (splash, auth, counter)
- All platform files (Android, iOS, web, Windows, macOS, Linux)

🎯 **Smart Templating** — Automatically substitutes:
- Project name in `pubspec.yaml` and all Dart imports
- Organization in bundle IDs and package namespaces
- App display name in native configurations
- Conditional dependencies (Firebase, network layer)

⚡ **Post-Generation Setup** — Optional hook runs:
- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`
- Directory structure cleanup (Android package renaming)

## Installation

### From Git (Recommended)

```bash
dart pub global activate mason_cli

mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick
```

### Local Development

```bash
mason add smoketrees_app --path "C:\smoketrees\app\smoketrees_app_template"
```

## Usage

### Basic Generation

```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.mycompany \
  --app_name "My App"
```

### Complete Example (with all options)

```bash
mason make smoketrees_app \
  --project_name stac_health_demo \
  --organization com.smoketrees \
  --app_name "Stac Health Demo" \
  --description "A Stac-powered health tracking app" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase false \
  --platforms android ios web \
  --output-dir "C:\projects\stac_health_demo"
```

### Interactive Mode (prompted)

```bash
mason make smoketrees_app
```

The brick will prompt you for each required variable.

## Generated Project Structure

```
my_app/
├── android/                              # Android platform project
│   ├── app/build.gradle.kts             # Templated with organization + project_name
│   └── app/src/main/...                 # AndroidManifest.xml, MainActivity.kt
├── ios/                                  # iOS platform project
│   ├── Runner/Info.plist                # Templated with app_name
│   └── Runner.xcodeproj/project.pbxproj # Templated with PRODUCT_BUNDLE_IDENTIFIER
├── lib/
│   ├── main.dart                        # App entry point with Stac init
│   ├── {{project_name}}.dart            # Barrel exports (renamed to project name)
│   ├── stac_runtime/                    # Custom Stac widgets & actions
│   │   ├── widgets/                     # Layout, controls, collections
│   │   ├── actions/                     # Navigation, custom actions
│   │   └── stac_registry.dart           # All parser registrations
│   ├── core/
│   │   ├── network/                     # Dio, interceptors, auth
│   │   ├── services/                    # Global, notifications, app links
│   │   └── storage/                     # Hive initialization
│   ├── shared/                          # Reusable components
│   │   ├── animations/                  # Scale, slide, fade-in
│   │   ├── dialogs/                     # Popups, loaders
│   │   ├── shimmer_loading/             # Skeleton screens
│   │   ├── widgets/                     # Carousels, dividers, clipper
│   │   └── snackbars/                   # Toast & snackbar utilities
│   ├── theme/                           # Colors, decorations, styles
│   ├── utils/                           # Assets, URLs, logging
│   └── app/                             # Pages, navigation, bindings
├── example/                             # Reference implementation
│   ├── lib/features/                    # Splash, auth, counter (if enabled)
│   └── stac/                            # Example Stac screens
├── pubspec.yaml                         # Templated with project name & dependencies
├── .fvmrc                               # Flutter 3.44.0 pinned version
├── analysis_options.yaml                # Linter rules
├── .gitignore                           # Flutter-specific ignores
└── [web/, windows/, macos/, linux/]    # Generated if selected in platforms
```

## Template Variables

| Variable | Type | Example | Used For |
|----------|------|---------|----------|
| `project_name` | string | `health_habits` | pubspec name, Dart imports, Android namespace |
| `organization` | string | `com.smoketrees` | Android applicationId, iOS bundle identifier |
| `app_name` | string | `Health Habits` | iOS display name, Android app label |
| `description` | string | `A health tracking app` | pubspec description |
| `include_example_screens` | boolean | `true` | Include `example/lib/features/` demo screens |
| `include_network_layer` | boolean | `true` | Include `lib/core/network/` Dio setup |
| `include_firebase` | boolean | `false` | Add Firebase messaging to pubspec.yaml |
| `platforms` | array | `[android, ios, web]` | Native platform directories to generate |

## Real-World Examples

### Stac Cart Demo

```bash
mason make smoketrees_app \
  --project_name stac_cart_demo \
  --organization com.smoketrees \
  --app_name "Stac Cart Demo" \
  --include_example_screens true \
  --platforms android ios web \
  --output-dir "./stac_cart_demo"

cd stac_cart_demo
stac watch
```

### Health Habits Tracker (with Firebase)

```bash
mason make smoketrees_app \
  --project_name health_habits \
  --organization com.mycompany \
  --app_name "Health Habits" \
  --description "Track your daily health goals" \
  --include_firebase true \
  --include_network_layer true \
  --platforms android ios
```

### Minimal Stac App (local rendering only)

```bash
mason make smoketrees_app \
  --project_name minimal_app \
  --organization com.example \
  --app_name "Minimal App" \
  --include_example_screens false \
  --include_network_layer false \
  --include_firebase false
```

## Generated Dart Imports

All Dart files automatically use the correct package name:

```dart
// Before (template):
import 'package:{{project_name}}/{{project_name}}.dart';

// After (generated for project_name=health_habits):
import 'package:health_habits/health_habits.dart';
```

## Generated Android Configuration

`android/app/build.gradle.kts`:
```kotlin
// Before (template):
namespace = "{{organization}}.{{project_name}}"
applicationId = "{{organization}}.{{project_name}}"

// After (generated for organization=com.smoketrees, project_name=health_habits):
namespace = "com.smoketrees.health_habits"
applicationId = "com.smoketrees.health_habits"
```

## Generated iOS Configuration

`ios/Runner.xcodeproj/project.pbxproj`:
```
// Before (template):
PRODUCT_BUNDLE_IDENTIFIER = {{organization}}.{{project_name}}.Runner;

// After (generated for organization=com.smoketrees, project_name=health_habits):
PRODUCT_BUNDLE_IDENTIFIER = com.smoketrees.health_habits.Runner;
```

## Post-Generation Steps

After brick generation, the generated project is ready to use:

```bash
cd my_app

# (Optional) Run post-generation setup if hooks are enabled
# flutter pub get
# dart run build_runner build --delete-conflicting-outputs

# Start development with Stac watch mode
stac watch

# Or run the app
flutter run
```

## Conditional Sections

### Example Screens

If `include_example_screens: false`, the following directories are omitted:
- `example/lib/features/` (splash, auth, counter, todo screens)
- `example/lib/stac_runtime/` (reference action/widget parsers)

### Network Layer

If `include_network_layer: false`, these are excluded:
- `lib/core/network/` (Dio, interceptors, auth)
- Network dependencies in `pubspec.yaml`

### Firebase

If `include_firebase: false`, Firebase dependencies are excluded from `pubspec.yaml`.

### Platforms

Only selected platforms have native project files generated:
- `android/` — Only if `platforms` includes `android`
- `ios/` — Only if `platforms` includes `ios`
- `web/` — Only if `platforms` includes `web`
- `windows/`, `macos/`, `linux/` — If selected

## Why Use This Brick Instead of Cloning?

| Aspect | Clone Repo | Mason Brick |
|--------|-----------|-----------|
| **Setup Time** | 5–10 min (clone + rename) | < 1 min (one command) |
| **Package Names** | Manual search & replace | Automatic templating |
| **Bundle IDs** | Manual edit (Android, iOS) | Automatic templating |
| **Platform Selection** | Keep everything | Choose what you need |
| **Repeatability** | Error-prone | Consistent every time |
| **Clean Start** | Starting template included | Fresh, minimal example |

## Troubleshooting

### "Mason brick not found"

Ensure you've installed it:
```bash
mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick
mason get
```

### "No terminal attached"

Use a config file instead of interactive prompts:
```bash
cat > config.json << EOF
{
  "project_name": "my_app",
  "organization": "com.example",
  "app_name": "My App",
  "description": "My app",
  "include_example_screens": true,
  "include_network_layer": true,
  "include_firebase": false,
  "platforms": ["android", "ios"]
}
EOF

mason make smoketrees_app -c config.json
```

### "Build runner errors after generation"

Run code generation manually:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Android package directory not renamed

The post-gen hook moves `android/app/src/main/kotlin/com/example/placeholder/MainActivity.kt` to the correct package structure. If it doesn't run, execute manually:
```bash
# Replace {organization} and {project_name} with your values
# Example: com/smoketrees/health_habits

mkdir -p "android/app/src/main/kotlin/{organization/replaced/with/dots/as/slashes}/{project_name}"
mv "android/app/src/main/kotlin/com/example/placeholder/MainActivity.kt" \
   "android/app/src/main/kotlin/{organization/path}/{project_name}/MainActivity.kt"
```

## Development & Contributing

To modify the brick locally:

```bash
# Edit __brick__/ template files
# Edit brick.yaml for new variables

# Test generation:
mason make smoketrees_app --output-dir ./test_output -c config.json

# View generated project:
cd test_output
flutter run
```

## License

Same as the Smoketrees/Stac repository. See LICENSE file.

## Support

For issues, feature requests, or questions:
- 🐛 [Report issues on GitHub](https://github.com/smoke-trees/st_sdui/issues)
- 💬 [Discuss on GitHub Discussions](https://github.com/smoke-trees/st_sdui/discussions)
- 📖 [Read Stac documentation](https://stac.smoketrees.dev)
