# smoketrees_app_template

A **Stac** (Server-Driven UI) Flutter template that adds server-driven capabilities to your Flutter apps. Reusable common widgets live in `lib/shared/`; the reference application and server-driven screen DSL are kept separate from the reusable package layer.

## Getting Started

This template is designed to be **added to existing Flutter projects**. Create your Flutter project first with `flutter create`, then add this Stac template to it. This preserves your platform-specific configurations and gives you full control over native setup.

This README is written as a **navigation guide**: if you're new to this repo, read it top to bottom once, then use the [map](#map-where-do-i-go-for-x) as a lookup whenever you're not sure which folder or file a change belongs in. The goal is that by the end, you can take this template and ship your own SDUI application without guessing.

---

## Quick Start: Add Stac to Your Flutter Project

### Prerequisites

```bash
# Install Mason CLI globally
dart pub global activate mason_cli
```

### Step 1: Create a Flutter Project

If you don't already have a Flutter project:

```bash
flutter create my_app
cd my_app
```

If you already have a Flutter project, just navigate to it:

```bash
cd your_existing_project
```

### Step 2: Initialize Mason

```bash
mason init
```

### Step 3: Add the Stac Template Brick

**From GitHub:**
```bash
mason add smoketrees_app --git-url https://github.com/smoke-trees/smoketrees_app_template.git
```

**Or Local (if you have the repo cloned):**
```bash
mason add smoketrees_app --path "/path/to/smoketrees_app_template"
```

### Step 4: Generate Stac Files

```bash
mason make smoketrees_app --project_name my_app
```

This will:
- ✅ Add the Stac infrastructure (`lib/stac_runtime/`, `stac/` folder)
- ✅ Add core setup files (`lib/core/`, `lib/features/`, `lib/shared/`)
- ✅ Add custom parsers and action handlers
- ✅ Add configuration files and utilities
- ✅ Install dependencies via `flutter pub get`
- ✅ Run code generation (`build_runner`)
- ✅ Compile initial Stac screens

**Important**: This template only adds Stac infrastructure files. Your existing platform folders (`android/`, `ios/`, etc.) remain untouched.

### Step 5: Start Development

```bash
stac watch  # Terminal 1 - watches for Stac DSL changes
flutter run # Terminal 2 - runs your Flutter app
```

---

## What Gets Generated?

This template adds the following to your existing Flutter project:

### Core Stac Infrastructure
- **`lib/stac_runtime/`** - Stac parsers, widgets, and action handlers
  - `widgets/` - Server-driven widget parsers (layout, controls, collections)
  - `actions/` - Server-driven action handlers (navigation, wildcard pages)
  - `stac_registry.dart` - Central registry for all parsers and actions

### Shared UI Components
- **`lib/shared/`** - Reusable Flutter widgets (non-server-driven)
  - Common buttons, dialogs, loaders, animations
  - Image/video helpers, shimmer loading, form fields

### Application Layer
- **`lib/core/`** - Networking, storage, auth patterns
  - Dio client configuration and interceptors
  - Hive storage setup
  - Backend integration patterns

- **`lib/features/`** - Reference app screens (splash, auth, bottom navigation)
  - Example implementations you can replace with your own
  - Shows patterns for Stac screen integration

### Stac DSL & Build Output
- **`stac/`** - Stac DSL files and compiled JSON screens
  - `lib/` - Your screen definitions using `@StacScreen` annotation
  - `.build/` - Generated JSON output (from `stac build`)
  - `.dev-build/` - Development build output (from `stac watch`)

### Scaffolding Tools
- **`create_stac_parser.dart`** - CLI tool to scaffold new Stac widget parsers
- **`create_stac_action.dart`** - CLI tool to scaffold new Stac action parsers

### Assets & Configuration
- **`assets/`** - Image and animation assets used by reference screens
- **`.agents/`** - OpenCode agent skills for Stac development workflows
- **`analysis_options.yaml`** - Linting rules
- **`.fvmrc`** - Flutter version management configuration

**Your platform folders remain unchanged** - the template only adds Stac infrastructure files to your existing project structure.

---

## Configuration Options

You can customize the template generation with these variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `project_name` | `my_stac_app` | Dart package name (snake_case). Used for pubspec.yaml name and imports |
| `description` | `A Stac-powered Flutter application` | Short description for pubspec.yaml |
| `include_example_screens` | `false` | Include reference screens (splash, sign_in, counter, auth) for learning |
| `include_network_layer` | `true` | Include Dio networking, auth interceptors, and backend integration |
| `include_firebase` | `false` | Add Firebase messaging and local notifications dependencies |

### Example Commands

**Minimal setup:**
```bash
mason make smoketrees_app --project_name my_app
```

**With example screens for learning:**
```bash
mason make smoketrees_app \
  --project_name my_app \
  --include_example_screens true
```

**With Firebase support:**
```bash
mason make smoketrees_app \
  --project_name my_app \
  --include_example_screens true \
  --include_firebase true \
  --description "My awesome Stac-powered app"
```

**Minimal setup (no networking):**
```bash
mason make smoketrees_app \
  --project_name my_app \
  --include_network_layer false
```

---

## Table of contents

- [Start here: how to read this repo](#start-here-how-to-read-this-repo)
- [Map: where do I go for X?](#map-where-do-i-go-for-x)
- [Use cases](#use-cases)
- [What this template provides](#what-this-template-provides)
- [Your path from template to shipped app](#your-path-from-template-to-shipped-app)
- [Prerequisites](#prerequisites)
- [Stac package sources](#stac-package-sources)
- [First-time setup (clone → run)](#first-time-setup-clone--run)
- [Daily loop: the watch session](#daily-loop-the-watch-session)
- [Key commands: `r`, `R`, `q`](#key-commands-r-r-q)
- [Build screen/theme JSON](#build-screentheme-json)
- [Project anatomy](#project-anatomy)
- [Screens in this template](#screens-in-this-template)
- [Building your first screen, step by step](#building-your-first-screen-step-by-step)
- [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser)
- [Custom Stac actions](#custom-stac-actions)
- [Wildcard pages: one route, many screens](#wildcard-pages-one-route-many-screens)
- [Runtime routing: `AppUrls` and `STAC_LOCAL_DEV`](#runtime-routing-appurls-and-stac_local_dev)
- [CLI reference](#cli-reference)
- [Gotchas & sharp edges](#gotchas--sharp-edges)

---

## Start here: how to read this repo

This template has **two layers**, and almost every question you'll have while building an app comes down to "which layer does my change belong in?"

1. **The package layer — `lib/`.** Reusable runtime: Stac parsers, Stac actions, shared Flutter widgets, networking, storage, auth patterns. Treat this as infrastructure. You'll add to it (new parsers, new actions, new shared widgets) far more often than you'll rewrite it.
2. **The reference app layer.** A runnable, working example built on top of `lib/` — backend controllers, feature-specific screens (`sign_in`, `bottom_navigation`, a to-do feature), route configuration, and the registry wiring it all together. This is **scaffolding to replace**, not code to keep. It exists so you have a working app to run on day one and a pattern to copy for every feature you build.

The practical rule while you work:

- Building a genuinely reusable, app-agnostic primitive (a new button style, a new Stac widget type, a new action type)? → **`lib/`**.
- Building a feature specific to *your* product (your onboarding flow, your checkout screen, your settings page)? → **the reference app layer**, using the same file layout (`DSL entry` + `feature module` + `registry entries`) as the sample screens.

Everything below expands on this split. If you only read one section, read this one — it's the lens for every other decision in the repo.

---

## Map: where do I go for X?

A quick-reference table for common tasks. Each row links to a fuller section further down.

| I want to… | Go to | Section |
|---|---|---|
| Run the app for the first time | Set `backendUrl`, then `fvm flutter run` | [First-time setup](#first-time-setup-clone--run) |
| Start my daily dev loop | `stac watch` | [Daily loop](#daily-loop-the-watch-session) |
| Edit an existing screen's layout | Its DSL entry file (e.g. `st_splash_page.dart`) | [Editing a screen](#daily-loop-the-watch-session) |
| Add a brand-new screen | New DSL file with `@StacScreen`, then register its route | [Building your first screen](#building-your-first-screen-step-by-step) |
| Change the app's theme/colors | The `@StacThemeRef` DSL file (e.g. `st_theme.dart`) — costs a hot **restart**, not reload | [Editing a screen](#daily-loop-the-watch-session), [Gotchas](#gotchas--sharp-edges) |
| Add a time-boxed page (sale banner, campaign, one-off announcement) **without a new app release** | Add it to `WildcardPageModel.children` | [Wildcard pages](#wildcard-pages-one-route-many-screens) |
| Build a new reusable widget (server-driven) | `dart run create_stac_parser.dart <Name> [category]` | [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser) |
| Build a new reusable Flutter widget (not server-driven) | Add it under `lib/shared/` directly | [What this template provides](#what-this-template-provides) |
| Add new tap/navigation behavior triggerable from JSON | `dart run create_stac_action.dart <Name> [category]` | [Custom Stac actions](#custom-stac-actions) |
| Point the app at my backend | Reference app's URL configuration (`AppUrls.backendUrl`) | [Point the app at your backend](#first-time-setup-clone--run) |
| Understand why screen JSON and data come from different URLs | `AppUrls.backendUrl` vs `AppUrls.stacBaseUrl` | [Runtime routing](#runtime-routing-appurls-and-stac_local_dev) |
| Regenerate `.g.dart` files after changing a model | `fvm dart run build_runner build --delete-conflicting-outputs` | [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser) |
| See what a finished parser/action looks like | `lib/stac_runtime/widgets/controls/main_button/`, `lib/stac_runtime/actions/wildcard_page_nav/` | [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser) |
| Debug a blank screen or `CustomErrorCard` | Check the parser is registered in the Stac registry, and (for wildcard pages) that the child key matches | [Gotchas](#gotchas--sharp-edges), [Wildcard pages gotchas](#gotchas) |
| Rebuild JSON without deploying | `stac build` | [Build screen/theme JSON](#build-screentheme-json) |
| Deploy screen/theme JSON to a backend | Not yet configured in this template — see [TODO](#todo) | — |

---

## Use cases

This template is built for teams that move UI decisions to the backend. The local development workflow is ready today; backend deployment is tracked in [TODO](#todo):

- **Content-heavy apps** — news, e-commerce, and marketplace apps where layouts, product pages, and landing screens change frequently. Edit the screen DSL and preview it with `stac watch`.
- **Wildcard page delivery** — add a new named page to an already registered wildcard route and change the page shown by the server without adding a native route or releasing a new app version.
- **Marketing & promotions** — swap banners, feature cards, and offers on the fly, and run timed campaigns from the server. The [`wildcard_page`](#wildcard-pages-one-route-many-screens) route exists exactly for this: a sale or campaign page can be live this week and gone next week with no app update.
- **Personalization** — render different layouts per user segment, region, or device from a single codebase. Screens ship as JSON, so the backend picks which variant to serve per request.
- **A/B testing** — experiment with variants of a screen or theme and measure engagement without shipping new builds. The watch loop's hot-reload and theme hot-restart make iterating on variants fast.
- **Operational dashboards & admin tools** — update forms, tables, and workflows as business logic evolves, without re-submitting to the app store.
- **Onboarding & feature flags** — roll out new screens gradually, or tailor onboarding flows per market. Routing is data-driven: `splash_page` decides between `sign_in` and `bottom_navigation` at runtime.
- **White-labeling** — reuse one Flutter binary across brands by driving logos, colors, and themes from the server. `main_theme` (`@StacThemeRef`) can be swapped server-side; editing it just costs a hot restart in the dev loop.
- **Rapid prototyping** — validate UI ideas in a running app by changing Dart source and hot-reloading via the dev server. See [Daily loop: the watch session](#daily-loop-the-watch-session).

---

## What this template provides

The template is more than a blank Flutter project. The following pieces are ready to keep, replace, or use as references:

| Area | Included capability | Where to look |
|------|---------------------|---------------|
| Server-driven UI | Stac JSON screens and themes generated from annotated Dart DSL | `stac/` |
| Local development | File watcher, local Stac server, Flutter hot reload, and theme hot restart | `stac watch` |
| Screen/theme generation | Compile annotated DSL files into JSON artifacts for local inspection and future backend integration | `stac build` |
| Navigation | Named routes plus the `wildcard_page` route for adding server-driven sub-pages without a new app release | `lib/stac_runtime/widgets/layout/wildcard_page/` |
| Wildcard pages | One registered route can host new named pages from the server without adding a native route or releasing a new app version | `lib/stac_runtime/widgets/layout/wildcard_page/`, `lib/stac_runtime/actions/wildcard_page_nav/` |
| Stac widgets | Layout, collection, control, conditional, dialog, list, and data-driven widget parsers | `lib/stac_runtime/widgets/` |
| Stac actions | Typed navigation and to-do actions dispatched from JSON or Dart | `lib/stac_runtime/actions/` |
| Reusable Flutter UI | Buttons, dialogs, loaders, animations, image/video helpers, shimmer loading, and fields | `lib/shared/`, `lib/stac_runtime/widgets/controls/main_button/` |
| Backend integration | Dio client/controller structure, auth, settings, to-do requests, and error logging | Reference app network/features modules |
| Local persistence | Hive initialization and persisted user/session data | Reference app storage module |
| Error handling | Flutter error page/card fallbacks and Stac rendering error widgets | Reference app error widgets and app entrypoint |
| Code generation | JSON serialization for custom models and actions | `fvm dart run build_runner build --delete-conflicting-outputs` |
| Cross-platform scaffolding | One Dart command for a custom parser and one for a custom action | `create_stac_parser.dart`, `create_stac_action.dart` |

### Main feature: add pages without a new app release

`wildcard_page` is a pre-registered Flutter route that can contain any number of named server-driven sub-pages. Because the native route already exists in the installed app, adding another child such as `summer_sale`, `terms_update`, or `campaign_page` does not require adding a new Flutter route or publishing a new app version.

The flow is:

1. Build the new page as a `StacWidget` helper.
2. Add it to `WildcardPageModel.children` under a unique name.
3. Open it with `StWildcardPageNavAction(wildcardPage: '<name>')`.
4. Preview it locally with `stac watch` and generate its JSON with `stac build`.
5. Publish the updated wildcard screen JSON through the backend once deployment is configured.

Only the server-driven JSON changes. Users keep their installed app version because `wildcard_page`, `WildcardPageParser`, and `StWildcardPageNavActionParser` are already included in the application. See [Wildcard pages](#wildcard-pages-one-route-many-screens) for the complete implementation and limitations.

The reference application is included to show how the reusable root `lib/` package layer is wired into a complete app. A normal application built from this template keeps the root runtime/shared code, then replaces the reference backend URLs, routes, screens, controllers, and branding with its own implementation.

---

## Your path from template to shipped app

Use this as a checklist. It's the same material as "How to use this template" in earlier versions of this doc, ordered as a path rather than a list.

**Phase 1 — Get it running as-is**

1. Clone the repository and run `fvm use` so the project uses the Flutter version in `.fvmrc`.
2. Run `fvm flutter pub get`.
3. Install the Stac CLI once — see [First-time setup](#first-time-setup-clone--run).
4. Point `AppUrls.backendUrl` at a real backend (yours, or a staging one) so the reference app has data to show.
5. Run `fvm flutter run` and confirm you land on `splash_page` → `sign_in` or `bottom_navigation`.
6. Start `stac watch` and confirm hot reload works by editing the reference `splash_page` DSL.

At the end of Phase 1 you have a working app and a working dev loop — nothing here is yours yet, but you've proven the template works in your environment.

**Phase 2 — Make it yours**

1. Rename the package and app title where required by your release process.
2. Replace the sample backend URL and adapt the reference app's Dio controllers to your API.
3. Replace the sample auth, to-do, counter, and wildcard screens with your feature modules — same file layout (DSL entry, feature module, registry entries), different content.
4. Add your server-driven screens to the reference app's DSL directory using `@StacScreen(screenName: '...')`.
5. Add your theme with `@StacThemeRef(name: '...')` and update `StacAppTheme` in the app entrypoint.
6. Register any new parsers and actions in the reference app's Stac registry — an export alone does **not** register a parser or action; the registry entry does.
7. Use `stac watch` for local iteration, `stac build` when you need JSON artifacts without the running app.

**Phase 3 — Extend the runtime as needed**

Only touch `lib/` (the package layer) once the reference-app-level replacement in Phase 2 isn't enough — i.e., you need a widget type or action type that doesn't exist yet:

1. New reusable Stac widget → [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser).
2. New reusable Stac action → [Custom Stac actions](#custom-stac-actions).
3. New reusable plain-Flutter widget (not server-driven) → add directly under `lib/shared/`.

**Phase 4 — Ship**

Screen/theme JSON currently only builds locally (`stac build` → `stac/.build/`). Backend deployment isn't wired up in this template yet — see [TODO](#todo) before you plan a release around server-pushed screens.

---

## Prerequisites

| Tool | Notes |
|------|-------|
| **Flutter 3.44.0** | Pinned by `.fvmrc`. Install via FVM: `fvm use` or `fvm install`. A plain Flutter SDK on your `PATH` also works, but FVM keeps every `flutter`/`dart` call on the pinned version. |
| **Dart SDK** | Ships with Flutter; the CLI targets `^3.8.1`. |
| **A backend** | The app talks to a real backend over HTTP for data (auth, to-dos, settings). There is no mock backend in this repo — only screen/theme JSON is served locally. |
| **A device or emulator** | Needed for the watch session's auto-launch. `flutter devices` to list them. |

## Stac package sources

This template defines its Stac packages from the [`st_sdui`](https://github.com/smoke-trees/st_sdui) Git repository instead of relying on published package versions from pub.dev. The package source is configured in `pubspec.yaml`:

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

The entries have different roles:

- `stac` is the package used directly by the application. Its `path` points to the `packages/stac` package inside the monorepo.
- `stac_core` provides the core Stac models and serialization contracts used by widgets, screens, and actions. It is overridden so the app uses the matching Git revision.
- `stac_framework` provides framework-level Stac integration and stays on the same repository revision.
- `stac_logger` provides the Stac logging package and stays on the same repository revision.

The `ref: main` entries intentionally track the current repository branch. This keeps the Stac packages coordinated, but a future change on `main` can change dependency resolution. For reproducible application builds, replace `main` with a tested commit SHA across all four entries.

After changing a package source or revision, run:

```sh
fvm flutter pub get
```

The Stac CLI is sourced from the same monorepo, but it is installed separately as a global Dart executable. See [Install the Stac CLI](#2-install-the-stac-cli-one-time).

## First-time setup (clone → run)

### 1. Get the app's dependencies

```sh
flutter pub get
```

The `stac` package is pulled from **Git, not pub.dev** — `pubspec.yaml`:

```yaml
dependencies:
  stac:
    git:
      url: https://github.com/smoke-trees/st_sdui.git
      ref: main
      path: packages/stac
```

> It tracks `main` unpinned. Running `flutter pub get` months from now may resolve a different Stac version.

### 2. Install the `stac` CLI (one time)

**Required.** The CLI is a globally activated package pulled from the `st_sdui` monorepo — it is *not* a dependency of the root project, so step 1 does not resolve it:

```sh
dart pub global activate --source git --git-path packages/stac_cli --git-ref main https://github.com/smoke-trees/st_sdui.git
```

Verify the install with `stac --version`. If `stac` is not found on your `PATH`, add Dart's global executables directory: `%LOCALAPPDATA%\Pub\Cache\bin` on Windows, `$HOME/.pub-cache/bin` on macOS/Linux.

### 3. Point the app at your backend (one time)

Open the reference application's URL configuration and set:

```dart
static String backendUrl = "http://192.168.1.17:8080"; // your real backend
```

There is a second URL behind a compile-time flag — see [Runtime routing](#runtime-routing-appurls-and-stac_local_dev). This file is not generated; it is yours to edit.

### 4. First run — confirm the app boots against the backend

```sh
fvm flutter run
```

A plain `flutter run` passes no `STAC_LOCAL_DEV`, so the app fetches **both** data and screen JSON from `backendUrl`. This isolates backend problems before you add the watch loop: a bad `backendUrl` otherwise surfaces as a blank splash or an auth error with no obvious cause.

The first screen is `splash_page`, which auto-routes after ~5s to `sign_in` (no saved user) or `bottom_navigation` (user persisted in Hive).

### 5. Start the watch session

```sh
stac watch
```

That's the whole setup. Local dev routing is **on by default** — no flag needed.

## Daily loop: the watch session

`stac watch` is a subcommand of the globally installed `stac` CLI, alongside `build`. Run it with `stac watch` (or `fvm dart ... stac` if you need the FVM-pinned Dart on `PATH`).

### What it does

On startup:

1. Reads the build ledger `.stac/manifest.json`.
2. Starts a local dev server on **`0.0.0.0:8090`**.
3. Spawns `flutter run --machine`, passing `--dart-define=STAC_LOCAL_DEV`, `STAC_DEV_HOST`, `STAC_DEV_PORT`.
4. Scans `stac/` and `lib/` for `@StacScreen` / `@StacThemeRef` entries, builds every screen and theme once into **`stac/.dev-build/`**, then watches both directories.

On every save of a `.dart` file (excluding `*.g.dart`, debounced 300 ms):

1. Rebuilds only the screens/themes that transitively depend on the changed file — so editing a model or parser under `lib/` rebuilds the screens that import it.
2. Writes new JSON to `stac/.dev-build/` and bumps the version in `.stac/manifest.json` **only when the output hash actually changed**.
3. Triggers a **hot reload** (`app.restart`, `fullRestart: false`) via the Flutter daemon. A changed **theme** forces a **hot restart** (`fullRestart: true`), because themes are memoized at `Stac.initialize` time.

Failed builds are skipped: the error is printed and the last good build stays live.

The dev server mimics the backend's two read endpoints, so the app fetches screens from it instead:

```
GET /app-screens?screenName=<name>   -> {"result": [{"name", "screenJson", "version"}]}
GET /app-themes?themeName=<name>     -> {"result": [{"name", "themeJson", "version"}]}
```

Stop with **`q`** or **Ctrl+C** — both restore the terminal, cancel the watchers, stop the dev server, and kill the spawned app.

### Options

| Flag | Default | Effect |
|------|---------|--------|
| `--port <n>` | `8090` | Dev server port, also passed as `STAC_DEV_PORT`. |
| `--host <s>` | `192.168.1.17` | Host advertised to the app as `STAC_DEV_HOST`. Use your machine's LAN IP for physical devices, `localhost` for emulators on the same machine. |
| `--device <id>` | auto | Passed to `flutter run` as `-d <id>`. `flutter devices` lists IDs. |
| `--no-app` | app spawns | Run the server and watch loop without launching the app. |
| `--no-dev` | dev routing on | Opts **out** of local-dev routing: the app is built with `STAC_LOCAL_DEV=false` and fetches screens from `backendUrl` instead of the dev server. |

### Two common invocations

```sh
# Standard local loop
stac watch

# Watch only, no app — you run the app yourself (e.g. from an IDE)
stac watch --no-app
# then, from another terminal:
fvm flutter run --dart-define=STAC_LOCAL_DEV=true \
  --dart-define=STAC_DEV_HOST=localhost --dart-define=STAC_DEV_PORT=8090
```

### Editing a screen

Open the reference application's `st_splash_page.dart` DSL file:

```dart
import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/features/splash/stac/splash_page_model.dart';
import 'package:smoketrees_app_template/utils/assets.dart';

@StacScreen(screenName: "splash_page")
StacWidget stSplashPage() {
  return SplashPageModel(logoAsset: AppAssets.animatedAppLogo);
}
```

Save → the watcher prints `✓ built screen "splash_page" (v<n>)` → the app hot-reloads.

If your edit produces byte-identical JSON, you'll see no rebuild line and no reload. That's intentional — the manifest hash gate suppresses no-op reloads. Press `r` if you want to force one anyway.

Editing the reference application's `st_theme.dart` (`@StacThemeRef`) triggers a full hot restart instead.

## Key commands: `r`, `R`, `q`

The watch session reads single keypresses while it runs:

| Key | Action |
|-----|--------|
| `r` | **Hot reload** — re-push the current build to the running app. |
| `R` | **Hot restart** — full restart, re-running `main()` and re-resolving the theme. |
| `q` (or `Q`) | **Quit** — clean shutdown. |
| `Ctrl+C` | Also quits, same shutdown path. |

`r` and `R` are independent of the file watcher: they re-push whatever is already in `stac/.dev-build/` without rebuilding anything. That's what you want when the app has drifted but no source file changed — stale backend data, a widget stuck in a bad state, or a reload you suppressed by saving identical output. Manual reloads log `↻ hot reload (manual)` / `↻ hot restart (manual)`, so they're distinguishable from watcher-driven `↻ hot reload` and `↻ hot restart (theme changed)`.

### Two input modes

The hint printed at startup tells you which mode you're in:

```
watching for changes… (r = hot reload, R = hot restart, q = quit)
```

Keys fire on the keypress itself — no Enter, and the character isn't echoed. This needs a real terminal (`stdin.hasTerminal`), because it puts stdin into raw mode.

```
watching for changes… (r/R/q then Enter, or Ctrl+C to stop)
```

stdin isn't a TTY — piped output, CI, or some IDE run consoles. Raw mode isn't available, so keys are read line-buffered: type `r` and press Enter. Everything else works identically.

Raw mode is a global terminal setting, so the session captures the incoming mode on start and restores it on every exit path. If a session is ever killed hard (Task Manager, a crash) before restore runs, your shell can be left without echo — `q` or Ctrl+C avoid that.

With `--no-app` there's no app to talk to, so `r`/`R` print an advisory instead of reloading.

## Build screen/theme JSON

`stac build` is available for compiling the annotated DSL into JSON. It does not deploy anything in this template because the backend deployment flow is not configured yet. See [TODO](#todo).

```sh
stac build
```

Scans the project for `@StacScreen` and `@StacThemeRef`, then writes generated JSON under `stac/.build/`. `--validate` is accepted but is currently a no-op.

### Same commands on iOS and Android

All of the above — `stac watch` and `stac build` — are platform-agnostic. The CLI produces the same JSON regardless of which platform the app runs on, so **there is no separate command set for iOS vs Android**. The only platform-dependent bit is which device you point the watch loop at via `--device` (a simulator/emulator ID from `flutter devices`), and even then the command is identical.

## Project anatomy

```
smoketrees_app_template/
├── lib/
│   ├── app/                     # pages routing and controller bindings
│   ├── core/                    # networking, storage, auth, settings
│   ├── enums/                   # define enums here
│   ├── features/                # all main pages like auth, bottom_navigation, and etc
│   ├── shared/                  # reusable common Flutter widgets
│   ├── stac_runtime/            # reusable Stac widgets, parsers, actions
│   ├── theme/
│   |── utils/
├── stac/                        # root package Stac DSL/helpers
|   ├── lib/                     # screen and theme DSL
|   ├── .build/                  # generated JSON output
|   └── .dev-build/              # watch-mode output
├── .stac/manifest.json          # build ledger (version/hash per screen/theme)
├── .fvmrc                       # Flutter 3.44.0
├── create_stac_parser.dart      # cross-platform Stac widget parser scaffold
├── create_stac_action.dart      # cross-platform Stac action parser scaffold
└── pubspec.yaml
```

Read this tree with the [Start here](#start-here-how-to-read-this-repo) split in mind: `lib/stac_runtime/` and `lib/shared/` are the package layer; `lib/app/`, `lib/features/`, and `stac/lib/` are where the reference app (and, after Phase 2, your app) lives. `stac/.build/` and `stac/.dev-build/` are generated — never hand-edit either.

### Key flows

- **Dart → JSON.** `stac build` and the watch loop each run an annotated function in a temp wrapper and `jsonEncode` the resulting `StacWidget`. The **annotation argument** (`screenName: "…"`), not the filename, becomes the screen name.
- **JSON → UI.** The app calls `Stac.initialize` with every parser and action parser, then maps registered route names to `Stac(routeName:)`.
- **Custom widgets.** Reusable common Flutter widgets remain in `lib/shared/`. DSL primitives live in `lib/stac_runtime/widgets/`; each is a model + `.g.dart` + parser trio. Scaffold new ones with `create_stac_parser.dart` (see [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser)).
- **Actions.** Typed `StacActionParser`s handle behavior from JSON or Dart, while application-specific callback registries can support legacy string-keyed actions.
- **Runtime data.** Controllers hit the backend via `backendDio` (`/to-do`, `/user/sign-in`, `/application-settings`, …) and publish changes through `StDataRefreshController`, so server-driven lists patch in place instead of refetching.

## Screens in this template

| Screen | DSL entry file | Notes |
|--------|----------------|-------|
| `splash_page` | Reference screen DSL | Home route. Waits ~5s, then routes to `sign_in` or `bottom_navigation` depending on whether a user is in Hive. |
| `sign_in` | Reference screen DSL | Authentication screen backed by the sample auth flow. |
| `sign_up` | Reference screen DSL | Registration screen backed by the sample auth flow. |
| `bottom_navigation` | Reference screen DSL | 5-tab shell (`StCustomBottomBar` + `StPageView`) with the to-do showcase. |
| `wildcard_page` | Reference wildcard DSL | One registered route hosting many named sub-pages selected by a `wildcardPage` argument. |
| `profile_test_page` | Reference screen DSL | Placeholder screen. |
| `main_theme` (theme) | Reference theme DSL | App theme. Editing it forces a hot restart. |

Unannotated screen helpers and wildcard sub-page builders are inlined into their parent screen, so they produce no JSON artifacts of their own.

Treat every row in this table as a **pattern to copy**, not code to keep long-term: `sign_in`/`sign_up` show the auth pattern, `bottom_navigation` shows the tabbed-shell pattern, `wildcard_page` shows the no-release-page pattern. When you build your own screen, find the closest match here and mirror its structure (DSL entry → feature module → registry entries) rather than starting from a blank file.

## Building your first screen, step by step

A worked example that ties the sections above together — adding one brand-new named screen (not a wildcard sub-page) to your app.

1. **Decide the screen name.** This is the string you'll pass to `@StacScreen(screenName: '...')` and the key used in the route table — pick it once and keep it consistent.
2. **Create the DSL entry file** in the reference app's DSL directory, following `st_splash_page.dart` as a model: import the models it needs, annotate a function with `@StacScreen(screenName: 'your_screen')`, and return a `StacWidget` tree built from existing parsers (layout, controls, etc. under `lib/stac_runtime/widgets/`).
3. **Register the route.** Add `'your_screen': (p0) => Stac(routeName: 'your_screen')` to the app's route table (`app_pages.dart`-equivalent) — screen JSON ships over the air, but route names do not (see [Wildcard pages: why this exists](#wildcard-pages-one-route-many-screens) for the full explanation of that constraint).
4. **Wire any new behavior.** If the screen needs a tap action that doesn't exist yet, scaffold it — see [Custom Stac actions](#custom-stac-actions) — instead of hand-rolling a one-off callback.
5. **Preview it.** With `stac watch` running, save the DSL file and confirm you see `✓ built screen "your_screen" (v1)` in the terminal.
6. **Navigate to it** from an existing screen using a `StacNavigateAction(routeName: 'your_screen', ...)` (or your custom action, if you built one) to confirm it renders end-to-end.
7. **Decide if it should be a full route or a wildcard sub-page.** If this screen is a one-off, time-boxed, or campaign-style page, consider building it as a `wildcard_page` child instead of a new route — see [Wildcard pages](#wildcard-pages-one-route-many-screens) — so future variants of it never need a route table change or app release.

## Scaffolding a custom Stac parser

Custom DSL primitives are a model + `.g.dart` + parser trio under `lib/stac_runtime/widgets/`. The cross-platform `create_stac_parser.dart` scaffolds all three files, exports them from `lib/smoketrees_app_template.dart`, wires the parser into `lib/stac_runtime/stac_registry.dart`, and regenerates the `.g.dart`. It uses the project's Dart SDK and runs identically from macOS Terminal, CMD, PowerShell, Windows Terminal, and other shells.

### Usage

```sh
dart run create_stac_parser.dart <Name> [category] [subdir...]
```

| Argument | Meaning | Default |
|----------|---------|---------|
| `<Name>` | Widget class name, e.g. `MyCard`. Becomes `st_my_card` files, type `st_my_card`. | — |
| `[category]` | Grouping folder, e.g. `layout`. | `layout` |
| `[subdir...]` | Extra nesting, e.g. `layout custom`. | *none* |

Examples:

```sh
dart run create_stac_parser.dart MyCard            # → widgets/layout/my_card/
dart run create_stac_parser.dart ImageTile layout  # → widgets/layout/image_tile/
dart run create_stac_parser.dart ChatBubble inbox  # → widgets/inbox/chat_bubble/
```

Mirroring the existing `material` widget (`lib/stac_runtime/widgets/layout/material/`), each scaffold creates:

| File | Contents |
|------|----------|
| `st_<snake>.dart` | `@JsonSerializable(explicitToJson: true)` `StacWidget` model with a `type` getter, `fromJson`/`toJson`, and a `child` field. |
| `st_<snake>_parser.dart` | `StacParser<Name>` with `type`, `getModel`, and a `parse` placeholder to fill in. |
| `st_<snake>.g.dart` | Generated-code header; `build_runner` fills it in. |

The script then:

1. Exports the model and parser from `lib/smoketrees_app_template.dart` (the barrel the registry imports).
2. Appends `NameParser()` to the `parsers` list in `lib/stac_runtime/stac_registry.dart`.
3. Runs `fvm dart run build_runner build --delete-conflicting-outputs` to generate the real `.g.dart` (prints the command instead if `fvm` isn't on `PATH`).

After scaffolding, implement the widget's fields in the model and the render logic in `parse`, then `flutter pub run build_runner build` again on any later model change.

### Example: a custom button parser

`lib/stac_runtime/widgets/controls/main_button/` is the best complete parser example in this template. It separates the concerns cleanly:

- `main_button.dart` is the normal Flutter widget. It owns loading, disabled, colors, padding, and tap behavior.
- `st_main_button.dart` is the server-safe `StacWidget` model. It uses `StacColor`, `StacTextStyle`, `StacEdgeInsets`, and `StacAction` instead of Flutter-only types.
- `st_main_button_parser.dart` converts the Stac model into `MainButton`, resolves colors/styles, and calls `model.onPressed.parse(context)`.
- `st_main_button.g.dart` is generated by `json_serializable` and should not be edited manually.
- `StMainButtonParser()` is registered in `lib/stac_runtime/stac_registry.dart`; an application can provide its own callback resolver when registering the parser.

To create a similar button under a new name, run the cross-platform skeleton command from the repository root:

```sh
dart run create_stac_parser.dart PrimaryButton controls
```

This creates:

```text
lib/stac_runtime/widgets/controls/primary_button/
├── st_primary_button.dart
├── st_primary_button_parser.dart
└── st_primary_button.g.dart
```

The generator also adds exports and `PrimaryButtonParser()` to the root registry. It runs code generation automatically when `fvm` is available. The explicit command for generating the `.g.dart` file is:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

Adapt the generated model to expose the fields your Flutter widget needs. For example, the generated `PrimaryButton` model can follow the existing `StMainButton` model:

```dart
@JsonSerializable(explicitToJson: true)
class PrimaryButton extends StacWidget {
  const PrimaryButton({
    this.title,
    this.onPressed,
    this.color,
    this.textColor,
    this.disabled = false,
  });

  final String? title;
  final StacAction? onPressed;
  final StacColor? color;
  final StacColor? textColor;
  final bool disabled;

  @override
  String get type => 'st_primary_button';

  factory PrimaryButton.fromJson(Map<String, dynamic> json) =>
      _$PrimaryButtonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PrimaryButtonToJson(this);
}
```

The parser maps the server model into an ordinary Flutter widget. This is the important part of a custom parser: the JSON model remains platform-neutral, while the parser is responsible for Flutter rendering and action dispatch.

```dart
class PrimaryButtonParser extends StacParser<PrimaryButton> {
  @override
  String get type => 'st_primary_button';

  @override
  PrimaryButton getModel(Map<String, dynamic> json) =>
      PrimaryButton.fromJson(json);

  @override
  Widget parse(BuildContext context, PrimaryButton model) {
    return MainButton(
      title: model.title,
      disabled: model.disabled,
      color: model.color?.toColor(context),
      textColor: model.textColor?.toColor(context),
      onTap: () async {
        await model.onPressed?.parse(context);
      },
    );
  }
}
```

The DSL can then use the new parser-backed widget exactly like the existing `StMainButton`:

```dart
PrimaryButton(
  title: 'Continue',
  color: StacColors.black,
  textColor: StacColors.white,
  onPressed: StacNavigateAction(
    routeName: 'profile',
    navigationStyle: NavigationStyle.push,
  ),
)
```

For a complete production implementation, copy the additional fields and style conversion from `st_main_button.dart` and `st_main_button_parser.dart`, then run the code-generation command after changing the model. Register the parser in the registry that `Stac.initialize` receives; an export alone does not register a parser.

### Custom Stac actions

Actions follow the same model + `.g.dart` + parser pattern, but under `lib/stac_runtime/actions/`. The cross-platform `create_stac_action.dart` scaffolds the trio (`st_<snake>_action.dart`, `st_<snake>_action_parser.dart`, `st_<snake>_action.g.dart`), exports them from the barrel, and registers the parser in the `actionParsers` list:

```sh
dart run create_stac_action.dart <Name> [category] [subdir...]

# examples
dart run create_stac_action.dart SubmitOrder          # → lib/stac_runtime/actions/actions/submit_order/
dart run create_stac_action.dart SubmitOrder checkout # → lib/stac_runtime/actions/checkout/submit_order/
```

Mirroring `lib/stac_runtime/actions/wildcard_page_nav/`, the generated model extends `StacAction` (`actionType` getter), and the parser extends `StacActionParser<St<Name>Action>` with an `onCall` placeholder — dispatch through `Stac.onCallFromJson` (as `StWildcardPageNavActionParser` does) to keep behavior identical whether triggered from JSON or imperative code. Run `build_runner` after filling in the model.

### Example: a custom action used by `StMainButton`

The existing `StMainButton` accepts a typed `StacAction` through `onPressed`. That lets a screen describe a button and its behavior together in the DSL:

```dart
StMainButton(
  title: 'Open profile',
  onPressed: StOpenProfileAction(),
)
```

Generate the action skeleton with one command:

```sh
dart run create_stac_action.dart OpenProfile navigation
```

The generated class is `StOpenProfileAction`, its JSON `actionType` is `open_profile`, and the files are created under:

```text
lib/stac_runtime/actions/navigation/open_profile/
├── st_open_profile_action.dart
├── st_open_profile_action_parser.dart
└── st_open_profile_action.g.dart
```

The generator exports the model and parser and adds `StOpenProfileActionParser()` to the root action registry. Generate or regenerate the serialization file with:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

Add the action's data to the generated model. Keep route names and other values typed or required where possible:

```dart
@JsonSerializable(explicitToJson: true)
class StOpenProfileAction extends StacAction {
  const StOpenProfileAction({required this.userId});

  final String userId;

  @override
  String get actionType => 'open_profile';

  factory StOpenProfileAction.fromJson(Map<String, dynamic> json) =>
      _$StOpenProfileActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StOpenProfileActionToJson(this);
}
```

Implement the parser's `onCall` by creating a built-in Stac action and dispatching it through `Stac.onCallFromJson`, as the shipped `StWildcardPageNavActionParser` does:

```dart
class StOpenProfileActionParser
    extends StacActionParser<StOpenProfileAction> {
  const StOpenProfileActionParser();

  @override
  String get actionType => 'open_profile';

  @override
  StOpenProfileAction getModel(Map<String, dynamic> json) =>
      StOpenProfileAction.fromJson(json);

  @override
  Future<void> onCall(
    BuildContext context,
    StOpenProfileAction action,
  ) async {
    final navigate = StacNavigator.pushStac(
      'profile',
      arguments: {'userId': action.userId},
    );
    await Stac.onCallFromJson(navigate.toJson(), context);
  }
}
```

The action must be present in the registry passed to `Stac.initialize`. Add the import and parser to the application's action registry:

```dart
static final List<StacActionParser> actionParsers = [
  StWildcardPageNavActionParser(),
  StOpenProfileActionParser(),
];
```

After code generation, the final flow is:

1. A Stac screen creates `StMainButton(onPressed: StOpenProfileAction(...))`.
2. `stac build` serializes the typed action into JSON.
3. The runtime resolves `open_profile` through `StOpenProfileActionParser`.
4. The parser dispatches navigation using the same Stac action pipeline used by built-in actions.

This pattern also works for API calls, form submissions, dialogs, analytics, and other behavior. Keep network and application services in the app layer, and let the action parser translate the server action into that service call.

## Wildcard pages: one route, many screens

### Why this exists

Screen JSON ships over the air, but **route names do not**. Every reachable route has to exist in the application's route table:

```dart
static final Map<String, Widget Function(BuildContext)> stacPages = {
  'bottom_navigation': (p0) => Stac(routeName: 'bottom_navigation'),
  'sign_in':           (p0) => Stac(routeName: 'sign_in'),
  'wildcard_page':     (p0) => Stac(routeName: 'wildcard_page'),
  …
};
```

So a brand-new screen name means editing app code, which means a rebuild and a store release. That's fine for planned work and useless for the two cases where server-driven UI actually earns its keep:

- **Special events** — a sale banner, a campaign landing page, a one-off announcement that has to be live this week and gone next week.
- **Any page you don't want to spend an app update on** — a T&C revision, a new help article, a page that only exists for one cohort.

`wildcard_page` is the pre-registered route that absorbs all of these. It is one route in `app_pages.dart` that hosts an arbitrary number of named sub-pages. Once the app version contains this route, the server can select and serve a new wildcard page without adding a native route or releasing a new app version.

### How it works

`WildcardPageModel` holds a **map of named children** rather than a single body, and the parser picks one at runtime from the route arguments:

```dart
// lib/stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart
final arg = ModalRoute.of(context)?.settings.arguments;
if (arg is Map<String, dynamic> && arg.containsKey('wildcardPage')) {
  return model.children[arg['wildcardPage']]?.parse(context) ??
      CustomErrorCard(error: 'Unexpected error in parsing');
}
return CustomErrorCard(error: 'No widgets added or argumentIndex is null');
```

The DSL side stays flat — one file per sub-page, composed into the map:

```dart
// <dsl-directory>/wildcard_page/wildcard_page.dart
@StacScreen(screenName: "wildcard_page")
StacWidget wildcardPage() =>
    WildcardPageModel(children: {'page1': page1(), 'page2': page2()});
```

Adding `'summer_sale': summerSale()` to that map and previewing it with `stac watch` is the local "new page" flow. No `app_pages.dart` edit is needed for the wildcard sub-page.

### Why there's a dedicated action

Selecting a sub-page depends on one magic string arriving in the route arguments. Done by hand it looks like this:

```dart
// works, but every call site can silently get it wrong
onPressed: StacNavigator.pushStac(
  'wildcard_page',
  arguments: {'wildcardPage': 'page2'},
)
```

Three ways to break that with no compile error and no runtime exception — just the error card: misspell the `'wildcardPage'` key, forget `arguments` entirely, or use a navigation style whose `StacNavigator` helper doesn't accept `arguments` (`pushReplacementStac` and `pushAndRemoveAllStac` don't). The failure shows up as a blank/error page at runtime, so test each wildcard destination with `stac watch`.

`StWildcardPageNavAction` removes the choice. The key is written once inside the action, `wildcardPage` is a **required typed field**, and the navigation style is an **enum** instead of a hand-assembled `arguments` map:

```dart
// <dsl-directory>/wildcard_page/pages/page1.dart
onPressed: StWildcardPageNavAction(
  navigationType: WildcardPageNavType.push,
  wildcardPage: 'page2',
)
```

Forget `wildcardPage` and it no longer compiles. The action injects it for **every** navigation type:

```dart
Map<String, dynamic> get navigationArguments => {
  ...?arguments,           // caller extras, optional
  'wildcardPage': wildcardPage,   // always present, always last
};
```

`WildcardPageNavType` covers `push`, `pushReplacement`, `pushAndRemoveAll`, `pushNamed`, `pushNamedAndRemoveAll`, `pushReplacementNamed`, `pop`, `popAll`. The push variants all carry the merged arguments — including the two whose `StacNavigator` helpers can't, which the parser builds as `StacNavigateAction` directly. `pop`/`popAll` take no arguments by nature. Dispatch goes through `Stac.onCallFromJson`, the same pipeline the built-in `navigate` action uses, so behaviour is identical whether it's triggered from JSON or Dart.

The destination route is hardcoded to `'wildcard_page'` in the parser — deliberately. This action has exactly one job, so there's no `routeName` to get wrong either.

### The files

| File | Role |
|------|------|
| `lib/stac_runtime/widgets/layout/wildcard_page/wildcard_page.dart` | `WildcardPageModel` — `@JsonSerializable`, type `st_wildcard_page`, holds `Map<String, StacWidget> children`. |
| `lib/stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart` | `WildcardPageParser` — picks the child from `arguments['wildcardPage']`. |
| `lib/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav.dart` | `StWildcardPageNavAction` + `WildcardPageNavType` — `@JsonSerializable`, actionType `wildcard_page_nav`. |
| `lib/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav_parser.dart` | `StWildcardPageNavActionParser` — maps the enum to a `StacNavigateAction` and dispatches. |
| `<dsl-directory>/wildcard_page/wildcard_page.dart` | DSL entry, `@StacScreen(screenName: "wildcard_page")`. |
| `<dsl-directory>/wildcard_page/pages/*.dart` | One unannotated builder per sub-page. |

Both parsers must be registered in the application's Stac registry (`WildcardPageParser()` in `parsers`, `StWildcardPageNavActionParser()` in `actionParsers`).

### Adding a sub-page

1. Create `<dsl-directory>/wildcard_page/pages/<name>.dart` returning a `StacWidget` (no annotation — it's a helper, not a screen).
2. Add it to the map in `wildcard_page.dart`: `'<name>': <name>()`.
3. Navigate to it with `StWildcardPageNavAction(wildcardPage: '<name>')`.
4. `stac build` to generate JSON, or just save if the watch session is running.

Only step 4 reaches production. Steps 1–3 are DSL, so nothing here needs an app release.

### JSON shape

```json
{
  "actionType": "wildcard_page_nav",
  "navigationType": "push",
  "wildcardPage": "page2",
  "arguments": { "anyKey": "anyValue" }
}
```

`navigationType` is decoded leniently — an unknown value falls back to `push` rather than throwing, so a stale or hand-edited payload degrades instead of crashing.

### Gotchas

- **A wrong `wildcardPage` value renders `CustomErrorCard`, not an exception.** The key is validated against the children map at runtime only, so a name that doesn't exist in the map fails quietly on screen. Keep the map and the action call in the same PR.
- **`children` is serialised in full.** Every sub-page ships inside one `wildcard_page` JSON payload on every fetch. It's one route, so it's one document — split into a second wildcard route if a page group ever gets genuinely large.
- **Deep links still need a real route.** `wildcard_page` is reachable by name, but a specific sub-page isn't addressable from outside the app unless you pass the argument yourself.

## Runtime routing: `AppUrls` and `STAC_LOCAL_DEV`

The app keeps **two** base URLs on purpose in its URL configuration:

- `AppUrls.backendUrl` — used by `backendDio` for all data (auth, to-dos, settings).
- `AppUrls.stacBaseUrl` — used by `Stac.initialize` for screen and theme JSON only.

`stacBaseUrl` is a compile-time getter:

```dart
const isLocalDev = bool.fromEnvironment('STAC_LOCAL_DEV');
if (!isLocalDev) return backendUrl;                       // real backend
const host = String.fromEnvironment('STAC_DEV_HOST', defaultValue: 'localhost');
const port = String.fromEnvironment('STAC_DEV_PORT', defaultValue: '8070');
return 'http://$host:$port';                              // local dev server
```

So one codebase points at either target, decided by `--dart-define=STAC_LOCAL_DEV=true`. The watch session passes that define (plus host and port) automatically; a plain `flutter run` doesn't, and stays on `backendUrl`. `main.dart` reads the same flag to switch Stac's cache to `networkOnly` during dev.

## CLI reference

`stac` is a single globally installed CLI (`dart pub global activate`, see [First-time setup](#first-time-setup-clone--run)). Every command below is a subcommand of it, and they behave identically whether the app you're building targets iOS or Android.

| Command | Purpose |
|---------|---------|
| `stac init` | Scaffold a Stac project (`stac/` sample, `default_stac_options.dart`, optional skills install). |
| `stac build` | Compile annotated DSL files into `stac/.build/` JSON. |
| `stac watch` | Local hot-reload loop (see [Daily loop](#daily-loop-the-watch-session)). |
| `stac login` / `logout` / `status` | Cloud auth. |
| `stac project create --name <n>` / `project list` | Cloud project management. |
| `stac skills add` | Install a skill. |
| `stac upgrade` | Self-update the CLI (`--version`, `--force`). |
| `stac --version` / `--help` | Version / usage. |

Other flags worth knowing: `build --project <dir>`, `watch --port/--host/--device/--no-app/--no-dev`, `project create --description <d>`, global `-v/--verbose`.

## TODO

- **Configure backend deployment.** `stac build` currently generates screen/theme JSON locally, but this template does not yet configure `stac deploy` or a deployment API. Add the backend URL, authentication, deployment endpoints, and a documented release workflow before enabling deployment instructions.

## Gotchas & sharp edges

- **Port 8090 must be free.** A second watch session (or any leftover process) makes startup die with a raw `SocketException: Failed to create server socket … errno = 10048` rather than a friendly message. Pass `--port 8099` or kill the old session.
- **`stacBaseUrl` and `STAC_LOCAL_DEV` are compile-time.** Editing `urls.dart` needs a full restart of the spawned app (`q`, then relaunch) — a hot reload won't pick it up. Process env vars can't change `fromEnvironment` values either; only `--dart-define` can, which is why the `STAC_BASE_API_URL` env var in `.vscode/launch.json` has no effect on the app.
- **Default host is a hardcoded LAN IP** (`192.168.1.17`). On another network the spawned app can't reach the dev server until you pass `--host` (use `localhost` for an emulator on the same machine).
- **Port mismatch in the fallback.** The watch server defaults to `8090`, but `urls.dart`'s `STAC_DEV_PORT` fallback is `8070`. It only matters if the define goes missing — the watch session always passes the real port.
- **Themes cost a hot restart**, so editing `st_theme.dart` is a slower cycle than editing a screen.
- **The `stac` git dependency is unpinned** (`ref: main`). Pin a commit SHA if you need reproducible builds.
- **An export alone never registers a parser or action.** Forgetting the registry entry (`parsers` / `actionParsers` list) is the single most common cause of an unrendered widget or a no-op action — check the registry before debugging the parser logic itself.