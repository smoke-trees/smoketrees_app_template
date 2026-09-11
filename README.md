# SmokeTrees Stac App Template

A Mason template for adding [st_sdui](https://github.com/smoke-trees/st_sdui) Server-Driven UI (SDUI) infrastructure to a Flutter application.

st_sdui lets you define screens with a Dart DSL, compile them to JSON, deliver them from a server, and render them as native Flutter widgets at runtime. This makes it possible to update layouts, run experiments, personalize screens, and launch campaigns without submitting a new app-store build.

## What This Template Includes

- Stac initialization and parser registration
- A starter `hello_world` Stac screen
- Custom widget and action parser examples
- Parser and action scaffolding scripts
- Networking, storage, theming, and shared-widget foundations
- Optional example screens, network code, and Firebase dependencies
- Git-based st_sdui package configuration
- Local development through `stac watch` and Tailscale Funnel

The template adds files to an existing Flutter project. It does not replace the project's `android/`, `ios/`, `web/`, or other platform directories.

## Prerequisites

- Flutter and Dart installed
- [Mason CLI](https://pub.dev/packages/mason_cli)
- The stac CLI
- Tailscale on the development computer when using `stac watch`

Install Mason:

```bash
dart pub global activate mason_cli
```

Install the stac CLI directly from the st_sdui monorepo:

```bash
dart pub global activate --source git --git-path packages/stac_cli --git-ref main https://github.com/smoke-trees/st_sdui.git
```

Verify both tools:

```bash
mason --version
stac --version
stac watch --help
```

If `stac` is not found, add Dart's global executable directory to `PATH`:

```text
Windows: %LOCALAPPDATA%\Pub\Cache\bin
macOS/Linux: $HOME/.pub-cache/bin
```

## Add the Template to a Flutter Project

Create a project if needed:

```bash
flutter create my_app
cd my_app
```

Initialize Mason in the Flutter project:

```bash
mason init
```

Add this brick from GitHub:

```bash
mason add smoketrees_app --git-url https://github.com/smoke-trees/smoketrees_app_template.git
```

For a local clone, use:

```bash
mason add smoketrees_app --path "/path/to/smoketrees_app_template"
```

Generate the files:

```bash
mason make smoketrees_app
```

Mason prompts for these values:

| Option | Default | Purpose |
|---|---|---|
| Project name | `my_stac_app` | Dart package name used by `pubspec.yaml` and imports |
| App description | `A Stac-powered Flutter application` | Package description |
| Include example screens? | `false` | Adds reference screens for learning |
| Include network layer? | `true` | Adds Dio networking and backend integration |
| Include Firebase? | `false` | Adds Firebase messaging and notification dependencies |

The post-generation hook runs `flutter pub get`, code generation, and `stac build`. If the stac CLI was not available during generation, install it with the Git activation command above and run `stac build` manually.

## Project Structure

```text
lib/
|-- app/                     # Application routes and bindings
|-- core/                    # Networking, storage, and services
|-- shared/                  # Reusable Flutter widgets
|-- stac_runtime/
|   |-- actions/             # Custom Stac action models and parsers
|   |-- widgets/             # Custom Stac widget models and parsers
|   `-- stac_registry.dart   # Runtime parser registration
|-- default_stac_options.dart
`-- main.dart
stac/
|-- lib/                     # Dart DSL screens and themes
|-- .build/                  # Output from stac build
`-- .dev-build/              # Output from stac watch
create_stac_parser.dart      # Custom widget scaffolder
create_stac_action.dart      # Custom action scaffolder
```

Do not edit `.build/`, `.dev-build/`, or generated `.g.dart` files manually.

## Initialize Stac

Initialize Stac before `runApp`. A minimal setup using the generated options is:

```dart
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'default_stac_options.dart';
import 'stac_runtime/stac_registry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Stac.initialize(
    options: defaultStacOptions,
    parsers: StacParsers.parsers,
    actionParsers: StacParsers.actionParsers,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stac App',
      home: Stac(routeName: 'hello_world'),
    );
  }
}
```

The template also includes `lib/main.dart` as a larger integration example with custom parsers, actions, routes, and initialization error handling.

## Write a Screen

Stac screens live under `stac/lib/`. The included starter screen is:

```dart
import 'package:stac/stac_core.dart';

@StacScreen(screenName: 'hello_world')
StacWidget helloWorld() {
  return StacScaffold(
    backgroundColor: StacColors.white,
    body: StacCenter(
      child: StacText(data: 'Hello World'),
    ),
  );
}
```

The `screenName` is the route name used by `Stac(routeName: 'hello_world')`. Shared DSL helpers can be extracted into ordinary Dart functions and imported by multiple screen files.

Build all annotated screens and themes:

```bash
stac build
```

Generated JSON is written to `stac/.build/`.

## Local Development With Tailscale Funnel

`stac watch` builds JSON into `stac/.dev-build/`, serves it from a local HTTP server, exposes the server through Tailscale Funnel, and injects the generated HTTPS URL into the Flutter debug process. Android and iOS test devices only need internet access; they do not need Tailscale installed.

### Set Up Tailscale

Install Tailscale from [tailscale.com/download](https://tailscale.com/download), then authenticate the development computer:

```bash
tailscale version
tailscale up
tailscale status
```

Enable Funnel once for the tailnet:

```bash
tailscale funnel http://127.0.0.1:8090
```

If Tailscale prints an authorization URL, open it and approve Funnel. After approval, stop the foreground command with `Ctrl+C`. The stac CLI will start Funnel automatically during future watch sessions.

Inspect the current Funnel configuration with:

```bash
tailscale funnel status
```

### Run the Watcher

From the Flutter project root, run:

```bash
stac watch
```

On success, the CLI prints an address similar to:

```text
Stac server running on https://your-machine.your-tailnet.ts.net
```

Do not hardcode this URL in the app. The CLI injects it into the debug Flutter process automatically. Saving a screen or theme rebuilds the affected JSON and triggers the appropriate Flutter reload or restart.

Available watch options:

| Flag | Description |
|---|---|
| `--device <id>` | Run on a specific Flutter device; the CLI prompts when multiple devices are available |
| `--no-app` | Watch and rebuild without launching Flutter |

When using `--no-app`, start the app separately with the debug defines required by your current stac CLI version.

### Tailscale Troubleshooting

| Problem | Resolution |
|---|---|
| `tailscale` is not recognized | Restart the terminal after installation or add Tailscale to `PATH` |
| Funnel is not enabled | Open the authorization URL from Tailscale and approve Funnel |
| `No serve config` | Run `tailscale funnel http://127.0.0.1:8090` once and complete authorization |
| Device cannot load the screen | Confirm the device has internet access and `stac watch` is still running |
| Port `8090` is in use | Stop the process using the port before starting the watcher |

If Tailscale is missing, `stac watch` exits before launching Flutter and prints the installation and setup instructions.

## Package Configuration

This template consumes `stac` from GitHub and overrides its related packages so all framework packages resolve from the same st_sdui revision:

```yaml
dependencies:
  stac:
    git:
      url: https://github.com/smoke-trees/st_sdui.git
      ref: main
      path: packages/stac

dependency_overrides:
  stac_core:
    git:
      url: https://github.com/smoke-trees/st_sdui.git
      ref: main
      path: packages/stac_core

  stac_framework:
    git:
      url: https://github.com/smoke-trees/st_sdui.git
      ref: main
      path: packages/stac_framework

  stac_logger:
    git:
      url: https://github.com/smoke-trees/st_sdui.git
      ref: main
      path: packages/stac_logger
```

Using `ref: main` follows the latest repository state. For reproducible builds, replace `main` in every entry with the same tested release tag or commit SHA.

After changing the revision, update dependencies:

```bash
flutter pub get
```

To pull newer commits from the configured branch:

```bash
flutter pub upgrade
```

## Custom Widgets and Actions

Custom Stac extensions require two parts:

1. A pure-Dart model that can be serialized into the server payload.
2. A Flutter parser that turns the model into a native widget or executes an action.

Scaffold a custom widget parser:

```bash
dart run create_stac_parser.dart <Name> [category] [subdir...] [--inject-data]
```

Examples:

```bash
dart run create_stac_parser.dart ProductCard collections
dart run create_stac_parser.dart ProductList collections --inject-data
```

Scaffold a custom action parser:

```bash
dart run create_stac_action.dart <Name> [category] [subdir...]
```

Example:

```bash
dart run create_stac_action.dart SubmitOrder checkout
```

The scripts create the model/parser files, update exports and registry entries, and run code generation when possible. After changing a serializable model, regenerate its `.g.dart` file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Every custom parser and action parser must be included in the lists passed to `Stac.initialize`. Exporting a parser is not sufficient by itself; confirm its registration in `lib/stac_runtime/stac_registry.dart`.

## Build and Deploy

The standard CLI workflow is:

```bash
stac login
stac init
stac build
stac watch
stac deploy
```

- `stac init` creates or updates the project configuration.
- `stac build` compiles Dart DSL screens and themes to JSON.
- `stac watch` runs the local Funnel-based development loop.
- `stac deploy` publishes generated UI through the configured Stac service.

The CLI reads credentials from:

```text
~/.stac/.env       # production
~/.stac/.env.dev   # development
```

Expected keys:

```text
STAC_BASE_API_URL
STAC_GOOGLE_CLIENT_ID
STAC_GOOGLE_CLIENT_SECRET  # optional
STAC_FIREBASE_API_KEY
```

## Common Use Cases

- Content-heavy product, news, marketplace, and commerce screens
- Marketing banners, promotions, and time-limited campaigns
- A/B tests and user-segment personalization
- Server-controlled onboarding and feature rollout
- Operational dashboards, forms, and administrative workflows
- White-label themes and layouts
- Rapid prototyping against a running Flutter application

## Command Reference

| Task | Command |
|---|---|
| Install the CLI | `dart pub global activate --source git --git-path packages/stac_cli --git-ref main https://github.com/smoke-trees/st_sdui.git` |
| Verify the CLI | `stac --version` |
| Initialize Stac | `stac init` |
| Build JSON | `stac build` |
| Start local development | `stac watch` |
| Watch without launching Flutter | `stac watch --no-app` |
| Target a device | `stac watch --device <id>` |
| Deploy | `stac deploy` |
| Regenerate model code | `dart run build_runner build --delete-conflicting-outputs` |

## Resources

- [st_sdui repository](https://github.com/smoke-trees/st_sdui)
- [Tailscale downloads](https://tailscale.com/download)
- [Flutter documentation](https://docs.flutter.dev/)
- [Mason documentation](https://docs.brickhub.dev/)
