# Smoketrees App Template - Mason Brick Installation & Usage Guide

## 🚀 Quick Start (3 Steps)

### Step 1: Install Mason CLI
```bash
dart pub global activate mason_cli
```

### Step 2: Add the Brick
For **local development**:
```bash
mason add smoketrees_app --path "C:\smoketrees\app\smoketrees_app_template"
```

For **production (from GitHub)**:
```bash
mason add smoketrees_app \
  --git-url https://github.com/smoke-trees/st_sdui.git \
  --git-path brick
```

### Step 3: Generate Your Project
```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.example \
  --app_name "My App"
```

## 📊 Complete Installation Methods

### Method 1: Local Development (Recommended for Brick Developers)

Perfect for modifying the brick or testing locally.

```bash
# From the brick repo directory
cd C:\smoketrees\app\smoketrees_app_template

# Initialize Mason (if not already done)
mason init

# Check the brick is available
mason list
# Output: smoketrees_app 1.0.0 -> C:/smoketrees/app/smoketrees_app_template

# Get the brick
mason get

# Generate a test project
mason make smoketrees_app \
  --project_name test_app \
  --organization com.example \
  --app_name "Test App" \
  --output-dir "./test_output"

# Verify the generated project
cd test_output
flutter pub get
dart analyze lib  # Should show 0 errors
flutter run
```

### Method 2: From GitHub (For End Users)

For users who want to use the published brick.

```bash
# Install Mason if not already installed
dart pub global activate mason_cli

# Add the brick from GitHub
mason add smoketrees_app \
  --git-url https://github.com/smoke-trees/st_sdui.git \
  --git-path brick

# Verify installation
mason list
# Output: smoketrees_app 1.0.0 -> git://github.com/smoke-trees/st_sdui.git#brick

# Generate a project
mason make smoketrees_app \
  --project_name health_app \
  --organization com.smoketrees \
  --app_name "Health Tracker"
```

### Method 3: Using Config File (For CI/CD)

Useful for automated generation.

```bash
# Create config.json
cat > config.json << 'EOF'
{
  "project_name": "cart_demo",
  "organization": "com.smoketrees",
  "app_name": "Stac Cart Demo",
  "description": "E-commerce app demo",
  "include_example_screens": true,
  "include_network_layer": true,
  "include_firebase": false,
  "platforms": ["android", "ios", "web"]
}
EOF

# Generate using config
mason make smoketrees_app -c config.json
```

## 🎛️ All Generation Options

### Basic Generation (Interactive)
```bash
mason make smoketrees_app
# Will prompt you for each variable
```

### All Variables
```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.example \
  --app_name "My App" \
  --description "My awesome app" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase false \
  --platforms android ios web \
  --output-dir "."
```

## 📋 Variable Reference

| Variable | Type | Example | Default | Purpose |
|----------|------|---------|---------|---------|
| `project_name` | string | `health_habits` | `my_stac_app` | Dart package name (snake_case) |
| `organization` | string | `com.smoketrees` | `com.example` | Bundle ID organization (reverse-domain) |
| `app_name` | string | `Health Habits` | `My Stac App` | Display name on all platforms |
| `description` | string | `Track health goals` | `A Stac-powered Flutter application` | pubspec.yaml description |
| `include_example_screens` | boolean | `true` | `false` | Include demo screens in `example/lib/` |
| `include_network_layer` | boolean | `true` | `true` | Include Dio networking setup |
| `include_firebase` | boolean | `false` | `false` | Add Firebase dependencies |
| `platforms` | array | `[android, ios, web]` | `[android, ios, web, windows, macos, linux]` | Target platforms |
| `output-dir` | string | `./my_app` | `.` | Where to generate the project |

## 🔧 After Generation

The post-generation hook automatically runs:
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
stac build
```

But you can also run manually:

```bash
cd my_app

# If you need to run again
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Verify no errors
dart analyze lib

# Run the app
flutter run
```

## 📚 Real-World Examples

### Example 1: Health Tracker App
```bash
mason make smoketrees_app \
  --project_name health_tracker \
  --organization com.health.app \
  --app_name "Health Tracker" \
  --description "Track daily health metrics" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase true \
  --platforms android ios

cd health_tracker
stac watch & flutter run
```

### Example 2: Minimal Web App
```bash
mason make smoketrees_app \
  --project_name web_app \
  --organization com.example \
  --app_name "Web App" \
  --include_example_screens false \
  --include_network_layer false \
  --include_firebase false \
  --platforms web

cd web_app
flutter run -d chrome
```

### Example 3: Enterprise App with All Features
```bash
mason make smoketrees_app \
  --project_name enterprise_app \
  --organization com.enterprise \
  --app_name "Enterprise Suite" \
  --description "Enterprise-grade application" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase true \
  --platforms android ios web

cd enterprise_app
stac watch & flutter run
```

## ❓ Troubleshooting

### "Cannot find mason.yaml"
Make sure you're in the brick repo directory and have run `mason init`:
```bash
cd C:\smoketrees\app\smoketrees_app_template
mason init
mason get
```

### "Brick not found"
Verify the brick is installed:
```bash
mason list
# Should show: smoketrees_app 1.0.0 -> ...
```

If not, re-add it:
```bash
# For local development
mason add smoketrees_app --path "C:\smoketrees\app\smoketrees_app_template"

# Or for GitHub
mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick
```

### "No terminal attached to stdout"
Use a config file instead of interactive mode:
```bash
mason make smoketrees_app -c config.json
```

### Generate has wrong package name
Make sure you're using snake_case for `project_name`:
- ✅ Correct: `my_app`, `health_tracker`, `cart_demo`
- ❌ Wrong: `MyApp`, `HealthTracker`, `CartDemo`

### Analysis shows errors
Run build_runner to generate required files:
```bash
dart run build_runner build --delete-conflicting-outputs
dart analyze lib  # Should now be 0 errors
```

## 📖 Documentation Files

- **README.md** - Main user guide with feature overview
- **MASON_QUICKSTART.md** - Installation and setup guide
- **BRICK_README.md** - Detailed brick reference
- **IMPLEMENTATION_SUMMARY.md** - Technical implementation details
- **DART_ANALYZE_GUIDE.md** - Understanding analysis warnings
- **COMPLETION_REPORT.md** - Final status and production readiness

## 🎯 Next Steps After Generating

1. **Understand the structure**
   ```bash
   cd my_app
   cat README.md
   ```

2. **Start development**
   ```bash
   stac watch  # Terminal 1
   flutter run # Terminal 2
   ```

3. **Create Stac screens**
   - Create screens in `stac/lib/`
   - Run `stac build` to compile
   - Reference screens in `lib/stac_runtime/stac_registry.dart`

4. **Configure backend** (if using network layer)
   - Update `lib/core/network/dio_controllers/backend_dio.dart`
   - Set up API endpoints in `lib/utils/urls.dart`

5. **Customize theme**
   - Edit `lib/theme/colors.dart` for brand colors
   - Update `lib/theme/decorations.dart` for design tokens

## ✅ Verification Checklist

After generation, verify the project is ready:

```bash
cd generated_app

# Check dependencies installed
flutter pub get

# Generate models and serializers
dart run build_runner build --delete-conflicting-outputs

# Verify no analysis errors
dart analyze lib  # Should show "0 issues found"

# Run tests (if any)
flutter test

# Run the app
flutter run
```

## 🚀 Publishing Your Generated Project

Once you're ready to ship:

```bash
# For Android
flutter build appbundle --release

# For iOS
flutter build ipa --release

# For Web
flutter build web --release
```

## 💬 Support

- Report issues: https://github.com/smoke-trees/st_sdui/issues
- Ask questions: https://github.com/smoke-trees/st_sdui/discussions
- Stac docs: https://stac.smoketrees.dev

---

**Happy building! 🎉**

For more details, check the documentation files in the brick repository.
