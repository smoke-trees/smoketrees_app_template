# Mason Brick Installation & Quick-Start Guide

## Prerequisites

- Flutter 3.44.0+ (or use FVM with `.fvmrc`)
- Dart 3.12.0+
- Mason CLI
- Stac CLI (for `stac watch` during development)

## Step 1: Install Mason CLI

```bash
dart pub global activate mason_cli
```

Verify installation:
```bash
mason --version
```

## Step 2: Add the Smoketrees Brick

### Option A: From GitHub (Production)

```bash
mason add smoketrees_app \
  --git-url https://github.com/smoke-trees/st_sdui.git \
  --git-path brick
```

### Option B: Local Development

```bash
mason add smoketrees_app \
  --path "C:\smoketrees\app\smoketrees_app_template"
```

### Option C: From a Different Machine

```bash
mason add smoketrees_app \
  --path "\\network-path\smoketrees_app_template"
```

Verify the brick is installed:
```bash
mason list
```

You should see `smoketrees_app` in the list.

## Step 3: Generate Your First Project

### Minimal Setup (Interactive)

```bash
mason make smoketrees_app
```

You'll be prompted for:
- Project name (snake_case)
- Organization (reverse-domain)
- App name (display name)
- Description
- Other options (example screens, network layer, Firebase, platforms)

### With Command-Line Arguments

```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.mycompany \
  --app_name "My App" \
  --include_example_screens true \
  --include_network_layer true \
  --include_firebase false \
  --platforms android ios web
```

### Using a Config File

Create `config.json`:
```json
{
  "project_name": "health_habits",
  "organization": "com.smoketrees",
  "app_name": "Health Habits",
  "description": "Track your daily health goals",
  "include_example_screens": true,
  "include_network_layer": true,
  "include_firebase": false,
  "platforms": ["android", "ios", "web"]
}
```

Then:
```bash
mason make smoketrees_app -c config.json
```

### Generate to Specific Directory

```bash
mason make smoketrees_app \
  --project_name my_app \
  --organization com.example \
  --app_name "My App" \
  --output-dir "C:\projects\my_app"
```

## Step 4: Navigate to Your Project

```bash
cd my_app
```

## Step 5: Start Development

### Option A: With Stac Watch (Recommended for Stac development)

```bash
# Terminal 1: Watch Stac files for changes
stac watch

# Terminal 2: Run the app
flutter run
```

### Option B: Direct Flutter Run

```bash
flutter run
```

### Option C: Specify Platform

```bash
flutter run -d android    # Android emulator/device
flutter run -d ios        # iOS simulator
flutter run -d chrome     # Web (Chrome)
```

## Real-World Examples

### Example 1: Stac Cart Demo (Full Setup)

```bash
# 1. Generate project
mason make smoketrees_app \
  --project_name stac_cart_demo \
  --organization com.smoketrees \
  --app_name "Stac Cart Demo" \
  --include_example_screens true \
  --include_network_layer true \
  --platforms android ios

# 2. Navigate to project
cd stac_cart_demo

# 3. Start development
stac watch  # Terminal 1
flutter run # Terminal 2
```

### Example 2: Minimal Health App (No Examples, No Network)

```bash
mason make smoketrees_app \
  --project_name minimal_health \
  --organization com.healthapp \
  --app_name "Minimal Health" \
  --include_example_screens false \
  --include_network_layer false \
  --include_firebase false \
  --platforms ios

cd minimal_health
flutter run
```

### Example 3: Enterprise App (With Firebase)

```bash
mason make smoketrees_app \
  --project_name enterprise_app \
  --organization com.enterprise \
  --app_name "Enterprise App" \
  --description "Enterprise-grade Stac application" \
  --include_example_screens false \
  --include_network_layer true \
  --include_firebase true \
  --platforms android ios web

cd enterprise_app

# Setup Firebase (requires Firebase configuration)
# Then run:
stac watch
flutter run
```

## What Gets Generated

### Directory Structure

```
my_app/
├── lib/                          # Main Flutter code
│   ├── main.dart                # Entry point
│   ├── my_app.dart              # Barrel exports (package name)
│   ├── stac_runtime/            # Custom Stac widgets & actions
│   ├── core/                    # Network, storage, services
│   ├── shared/                  # Reusable components
│   ├── theme/                   # Theme configuration
│   └── utils/                   # Utilities
├── example/                      # Reference implementation
│   └── lib/features/            # Example screens (if enabled)
├── android/                      # Android project (Android-specific)
│   ├── app/build.gradle.kts     # Templated with your organization
│   └── app/src/main/...         # Android manifest, MainActivity
├── ios/                          # iOS project (if selected)
│   ├── Runner/Info.plist        # Templated with your app name
│   └── Runner.xcodeproj/        # Xcode project (templated bundle ID)
├── web/                          # Web project (if selected)
├── windows/                      # Windows project (if selected)
├── macos/                        # macOS project (if selected)
├── linux/                        # Linux project (if selected)
├── pubspec.yaml                 # Dependencies (templated)
├── .fvmrc                       # Flutter version (3.44.0)
├── analysis_options.yaml        # Linter configuration
└── .gitignore                   # Git ignores
```

### Automatically Generated Files

**For your project name `health_habits` and organization `com.smoketrees`:**

| File | Content |
|------|---------|
| `pubspec.yaml` | `name: health_habits` |
| `lib/health_habits.dart` | Package barrel exports |
| `lib/main.dart` | `import 'package:health_habits/...'` |
| `android/app/build.gradle.kts` | `namespace = "com.smoketrees.health_habits"` |
| `android/app/src/main/AndroidManifest.xml` | `android:label="Health Habits"` |
| `ios/Runner/Info.plist` | `CFBundleName: health_habits`, `CFBundleDisplayName: Health Habits` |
| `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER = com.smoketrees.health_habits` |

## Verify Your Setup

### 1. Check Flutter Setup

```bash
flutter doctor
```

All items should be green (except Web if not needed).

### 2. Check Mason Installation

```bash
mason list
```

Should show `smoketrees_app` brick.

### 3. Check Stac CLI (Optional)

```bash
stac --version
```

Required if you want to use `stac watch`.

### 4. Generate Test Project

```bash
mason make smoketrees_app \
  --project_name test_app \
  --organization com.test \
  --app_name "Test App"

cd test_app
flutter pub get
flutter run
```

## Common Issues & Solutions

### Issue: "Mason brick not found"

**Solution:**
```bash
mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick
mason get
```

### Issue: "No terminal attached to stdout"

**Solution:** Use a config file instead:
```bash
mason make smoketrees_app -c config.json
```

### Issue: Android build fails with "Package not found"

**Solution:** The post-gen hook didn't properly rename the Android package directory. Fix manually:
```bash
# From project root
mkdir -p android/app/src/main/kotlin/com/yourorg/yourapp
mv android/app/src/main/kotlin/com/example/placeholder/MainActivity.kt \
   android/app/src/main/kotlin/com/yourorg/yourapp/MainActivity.kt
```

### Issue: Build runner errors after generation

**Solution:** This is often normal. Run it manually:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: `stac watch` not found

**Solution:** Install Stac CLI:
```bash
dart pub global activate stac_cli
```

Then ensure `~/.pub-cache/bin` is in your PATH.

### Issue: Flutter complains about SDK version

**Solution:** Use FVM to pin Flutter 3.44.0:
```bash
fvm install 3.44.0
fvm use 3.44.0
```

Or manually update your Flutter:
```bash
flutter upgrade --force
```

## Next Steps After Generation

1. **Understand the Structure**: Open `lib/main.dart` and explore `lib/stac_runtime/`
2. **Read Example Code**: Check `example/lib/` for reference implementations
3. **Customize Theme**: Edit `lib/theme/` for your brand colors
4. **Add Your Screens**: Create new Stac screens in `stac/lib/`
5. **Set Up Backend**: Configure API endpoints in `lib/core/network/` if using network layer
6. **Configure Firebase**: Follow Firebase setup if `include_firebase: true`

## Project Maintenance

### Update Dependencies

```bash
flutter pub upgrade
```

### Regenerate Models (After Updating Stac SDK)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Rebuild Stac Screens

```bash
stac build
```

### Format Code

```bash
dart format lib/ example/
```

### Lint Check

```bash
dart analyze
```

## Support & Resources

- **Stac Documentation**: https://stac.smoketrees.dev
- **Flutter Setup**: https://flutter.dev/docs/get-started
- **Mason Docs**: https://docs.brickhub.dev
- **GitHub Issues**: https://github.com/smoke-trees/st_sdui/issues
- **GitHub Discussions**: https://github.com/smoke-trees/st_sdui/discussions

## Advanced: Modify & Rebuild Brick

To modify the brick itself:

```bash
# Clone or navigate to the template
cd smoketrees_app_template

# Edit __brick__/ files or brick.yaml

# Test locally
mason make smoketrees_app \
  --project_name test_app \
  --organization com.test \
  --app_name "Test App" \
  --output-dir ./test_output

# Verify generated project
cd test_output
flutter run

# Clean up test
cd ..
rm -rf test_output
```

## Troubleshooting Brick Updates

If you update the brick but changes don't appear:

```bash
# Remove old version
mason remove smoketrees_app

# Reinstall
mason add smoketrees_app --git-url https://github.com/smoke-trees/st_sdui.git --git-path brick --force

# Get latest
mason get
```

---

**You're all set! 🚀 Happy building with Stac!**
