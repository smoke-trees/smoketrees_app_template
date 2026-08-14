# smoketrees_app_template

A **Stac** (Server-Driven UI) Flutter template. Reusable common widgets live in `lib/shared/`; the runnable application lives in `example/lib/`; and screen layouts live as Dart DSL files under `stac/example/`.

This README walks a new developer from a fresh clone to a running app with local hot-reload, and explains how the pieces fit together.

---

## Table of contents

- [Prerequisites](#prerequisites)
- [First-time setup (clone → run)](#first-time-setup-clone--run)
- [Daily loop: the watch session](#daily-loop-the-watch-session)
- [Key commands: `r`, `R`, `q`](#key-commands-r-r-q)
- [One-off build & deploy](#one-off-build--deploy)
- [Project anatomy](#project-anatomy)
- [Screens in this template](#screens-in-this-template)
- [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser)
- [Custom Stac actions](#custom-stac-actions)
- [Wildcard pages: one route, many screens](#wildcard-pages-one-route-many-screens)
- [Runtime routing: `AppUrls` and `STAC_LOCAL_DEV`](#runtime-routing-appurls-and-stac_local_dev)
- [CLI reference](#cli-reference)
- [Gotchas & sharp edges](#gotchas--sharp-edges)

---

## Prerequisites

| Tool | Notes |
|------|-------|
| **Flutter 3.44.0** | Pinned by `.fvmrc`. Install via FVM: `fvm use` or `fvm install`. A plain Flutter SDK on your `PATH` also works, but FVM keeps every `flutter`/`dart` call on the pinned version. |
| **Dart SDK** | Ships with Flutter; the CLI targets `^3.8.1`. |
| **A backend** | The app talks to a real backend over HTTP for data (auth, to-dos, settings). There is no mock backend in this repo — only screen/theme JSON is served locally. |
| **A device or emulator** | Needed for the watch session's auto-launch. `flutter devices` to list them. |

## First-time setup (clone → run)

### 1. Get the app's dependencies

```sh
flutter pub get
```

Run the example entrypoint with `flutter run -t example/lib/main.dart`.

The `stac` package is pulled from **Git, not pub.dev** — `pubspec.yaml`:

```yaml
dependencies:
  stac:
    git:
      url: https://github.com/RJ2607/mod_stac.git
      ref: main
```

> It tracks `main` unpinned. Running `flutter pub get` months from now may resolve a different Stac version.

### 2. Get the CLI's dependencies

**Required.** `stac_cli/` is its own Dart package and is *not* a dependency of the root project, so step 1 does not resolve it:

```sh
dart pub get --directory stac_cli
```

Skip this and `dart run stac_cli/bin/stac_watch.dart` fails to resolve its imports.

### 3. Point the app at your backend (one time)

Open `example/lib/utils/urls.dart` and set:

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
fvm dart run stac_cli/bin/stac_watch.dart
```

That's the whole setup. Local dev routing is **on by default** — no flag needed.

## Daily loop: the watch session

`stac_watch` is a **second entrypoint** inside `stac_cli/`. It is *not* a `stac watch` subcommand of `stac.exe`; run it with `dart run` (or `fvm dart run`).

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
fvm dart run stac_cli/bin/stac_watch.dart

# Watch only, no app — you run the app yourself (e.g. from an IDE)
fvm dart run stac_cli/bin/stac_watch.dart --no-app
# then, from another terminal:
fvm flutter run --dart-define=STAC_LOCAL_DEV=true \
  --dart-define=STAC_DEV_HOST=localhost --dart-define=STAC_DEV_PORT=8090
```

### Editing a screen

Open `stac/example/st_splash_page.dart`:

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

Editing `stac/example/st_theme.dart` (the `@StacThemeRef` entry) triggers a full hot restart instead.

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

## One-off build & deploy

### 1. Compile the CLI (one time)

`stac.exe` is a compiled binary with your backend URL baked in. `build_stac.bat` wraps the compile:

```bat
build_stac.bat "http://192.168.1.17:8080/api"
```

or by hand:

```sh
dart compile exe stac_cli\bin\stac_cli.dart -D STAC_BASE_API_URL="https://your-backend.com/api" -o stac.exe
```

The URL is baked in at compile time.

### 2. Build the screens to JSON

```sh
stac.exe build
```

Scans `stac/` for `@StacScreen` / `@StacThemeRef`, compiles each into JSON under **`stac/.build/`**, printing `✓ Generated screen: <name>.json` per artifact. `--validate` is accepted but is currently a no-op.

### 3. Deploy to the backend

```sh
stac.exe deploy
```

POSTs every file in `stac/.build` to `${STAC_BASE_API_URL}/app-screens/deploy` and `/app-themes/deploy`. `--skip-build` deploys what's already there without rebuilding.

Deploy never touches `stac/.dev-build` — the dev loop and the deploy pipeline write to separate directories on purpose, so a watch-mode save can't be published by accident.

## Project anatomy

```
smoketrees_app_template/
├── stac/                       # Stac DSL — screens & themes as Dart
│   ├── example/
│   │   ├── st_theme.dart       #   @StacThemeRef(name: 'main_theme')
│   │   ├── st_splash_page.dart
│   │   ├── hello_world.dart    #   helper, no annotation
│   │   ├── auth/                #   sign_in, sign_up
│   │   ├── bottom_navigation/
│   │   ├── wildcard_page/       #   wildcard_page + pages/{page1,page2}
│   │   └── test page/           #   note: directory name contains a space
│   ├── .build/                  # stac.exe build output (deploy pipeline)
│   └── .dev-build/               # watch output (dev loop)
├── lib/
│   ├── shared/                  # reusable common Flutter widgets
│   ├── core/                     # support required by common widgets
│   ├── features/auth/            # common-widget dependency closure
│   ├── features/splash/          # common-widget dependency closure
│   ├── theme/
│   └── utils/
├── example/
│   └── lib/
│       ├── main.dart           # Hive init → Stac.initialize → StacApp
│       ├── app/                # routes, navigation, bindings, options
│       ├── stac_runtime/       # example Stac models, parsers, and actions
│       └── features/           # counter and to-do examples
├── stac_cli/                   # the CLI + watch tool (separate Dart package)
│   ├── bin/stac_cli.dart       #   stac build/deploy/init/… entrypoint
│   ├── bin/stac_watch.dart     #   watch-loop entrypoint (dart run)
│   └── lib/watch/              #   server, watcher, process controller,
│                               #   key_commands, manifest
├── .stac/manifest.json         # build ledger (version/hash per screen/theme)
├── .fvmrc                      # Flutter 3.44.0
├── build_stac.bat              # compile stac.exe with baked-in API URL
├── create_stac_parser.sh       # scaffold a custom Stac widget parser
├── create_stac_action.sh       # scaffold a custom Stac action parser
└── pubspec.yaml
```

> **Only delete the `example/` folder if you're not using any of its custom widgets.** It is not just a sample app — it contains dozens of reusable widgets under `example/lib/shared/` (buttons, cards, dialogs, fields, pages, players, chips, and app-wide widgets) plus the example Stac models, parsers, and actions under `example/lib/stac_runtime/` and `example/lib/features/`. These widgets can be copied or imported into the main `lib/` folder, and the runnable app, routes, and backend integration all live there. If your project still depends on any of them, removing it breaks the app, the watch loop, and the deploy pipeline.

### Key flows

- **Dart → JSON.** `stac build` and the watch loop each run an annotated function in a temp wrapper and `jsonEncode` the resulting `StacWidget`. The **annotation argument** (`screenName: "…"`), not the filename, becomes the screen name.
- **JSON → UI.** `example/lib/main.dart` calls `Stac.initialize(baseUrl: AppUrls.stacBaseUrl, …)` with every parser from `example/lib/stac_runtime/stac_registry.dart`. `example/lib/app/app_pages.dart` maps `splash_page`, `bottom_navigation`, `sign_in`, `sign_up` to `Stac(routeName:)`.
- **Custom widgets.** Reusable common Flutter widgets remain in `lib/shared/`. DSL primitives live in `lib/stac_runtime/widgets/`; each is a model + `.g.dart` + parser trio. Scaffold new ones with `create_stac_parser.sh` (see [Scaffolding a custom Stac parser](#scaffolding-a-custom-stac-parser)). Screen-level widgets live under `example/lib/features/<name>/stac/`.
- **Actions.** Two mechanisms coexist: proper `StacActionParser`s under `example/lib/stac_runtime/actions/` (`to_do/{delete,reorder,toggle}`, `wildcard_page_nav/`), and `action_registry.dart`, a string-keyed callback map (`hello_world`, `back_profile_test_page`, `go_to_tab_1`) used by `StMainButton` via `actionKey`.
- **Runtime data.** Controllers hit the backend via `backendDio` (`/to-do`, `/user/sign-in`, `/application-settings`, …) and publish changes through `StDataRefreshController`, so server-driven lists patch in place instead of refetching.

## Screens in this template

| Screen | DSL entry file | Notes |
|--------|----------------|-------|
| `splash_page` | `stac/example/st_splash_page.dart` | Home route. Waits ~5s, then routes to `sign_in` or `bottom_navigation` depending on whether a user is in Hive. |
| `sign_in` | `stac/example/auth/st_sign_in_page.dart` | Thin wrapper returning `SignInModel`; the real form is `example/lib/features/auth/sign_in/sign_in_page.dart` → `/user/sign-in`. |
| `sign_up` | `stac/example/auth/st_sign_up_page.dart` | `/user/sign-up`; reads tokens from a nested `result.tokens`. |
| `bottom_navigation` | `stac/example/bottom_navigation/st_bottom_navigation_bar.dart` | 5-tab shell (`StCustomBottomBar` + `StPageView`). Tab 2 is the DSL showcase: reorderable to-do list with swipe actions, animations, conditional styling. |
| `wildcard_page` | `stac/example/wildcard_page/wildcard_page.dart` | One route hosting many sub-pages, selected at runtime by a `wildcardPage` argument. See [Wildcard pages](#wildcard-pages-one-route-many-screens). |
| `profile_test_page` | `stac/example/test page/profile_test_page.dart` | Placeholder. |
| `main_theme` (theme) | `stac/example/st_theme.dart` | App theme. Editing it forces a hot restart. |

`stac/example/hello_world.dart`, `stac/example/bottom_navigation/st_to_do_list_view.dart`, and `stac/example/wildcard_page/pages/*.dart` carry no annotation — they're composition helpers inlined into their parent screen, so they produce no JSON of their own.

## Scaffolding a custom Stac parser

Custom DSL primitives are a model + `.g.dart` + parser trio under `lib/stac_runtime/widgets/`. `create_stac_parser.sh` scaffolds all three files, exports them from `lib/smoketrees_app_template.dart`, wires the parser into `lib/stac_runtime/stac_registry.dart`, and regenerates the `.g.dart` — so adding a new server-driven widget is one command instead of five hand-written files.

### Usage

```sh
./create_stac_parser.sh <Name> [category] [subdir...]
```

| Argument | Meaning | Default |
|----------|---------|---------|
| `<Name>` | Widget class name, e.g. `MyCard`. Becomes `st_my_card` files, type `st_my_card`. | — |
| `[category]` | Grouping folder, e.g. `layout`. | `layout` |
| `[subdir...]` | Extra nesting, e.g. `layout custom`. | *none* |

Examples:

```sh
./create_stac_parser.sh MyCard            # → widgets/layout/my_card/
./create_stac_parser.sh ImageTile layout  # → widgets/layout/image_tile/
./create_stac_parser.sh ChatBubble inbox  # → widgets/inbox/chat_bubble/
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

### Custom Stac actions

Actions follow the same model + `.g.dart` + parser pattern, but under `lib/stac_runtime/actions/`. `create_stac_action.sh` scaffolds the trio (`st_<snake>_action.dart`, `st_<snake>_action_parser.dart`, `st_<snake>_action.g.dart`), exports them from the barrel, and registers the parser in the `actionParsers` list:

```sh
./create_stac_action.sh <Name> [category] [subdir...]

# examples
./create_stac_action.sh SubmitOrder        # → lib/stac_runtime/actions/actions/submit_order/
./create_stac_action.sh SubmitOrder checkout # → lib/stac_runtime/actions/checkout/submit_order/
```

Mirroring `lib/stac_runtime/actions/wildcard_page_nav/`, the generated model extends `StacAction` (`actionType` getter), and the parser extends `StacActionParser<St<Name>Action>` with an `onCall` placeholder — dispatch through `Stac.onCallFromJson` (as `StWildcardPageNavActionParser` does) to keep behavior identical whether triggered from JSON or imperative code. Run `build_runner` after filling in the model.

## Wildcard pages: one route, many screens

### Why this exists

Screen JSON ships over the air, but **route names do not**. Every reachable route has to exist in `example/lib/app/app_pages.dart`:

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

`wildcard_page` is the pre-registered route that absorbs all of these. It is one route in `app_pages.dart` that hosts an arbitrary number of sub-pages, so shipping a new page becomes a `stac deploy` instead of a release.

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
// stac/example/wildcard_page/wildcard_page.dart
@StacScreen(screenName: "wildcard_page")
StacWidget wildcardPage() =>
    WildcardPageModel(children: {'page1': page1(), 'page2': page2()});
```

Adding `'summer_sale': summerSale()` to that map and deploying is the entire "new page" flow. No `app_pages.dart` edit, no release.

### Why there's a dedicated action

Selecting a sub-page depends on one magic string arriving in the route arguments. Done by hand it looks like this:

```dart
// works, but every call site can silently get it wrong
onPressed: StacNavigator.pushStac(
  'wildcard_page',
  arguments: {'wildcardPage': 'page2'},
)
```

Three ways to break that with no compile error and no runtime exception — just the error card: misspell the `'wildcardPage'` key, forget `arguments` entirely, or use a navigation style whose `StacNavigator` helper doesn't accept `arguments` (`pushReplacementStac` and `pushAndRemoveAllStac` don't). The failure shows up as a blank/error page after deploy, which is the worst place to find it.

`StWildcardPageNavAction` removes the choice. The key is written once inside the action, `wildcardPage` is a **required typed field**, and the navigation style is an **enum** instead of a hand-assembled `arguments` map:

```dart
// stac/example/wildcard_page/pages/page1.dart
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
| `example/lib/stac_runtime/widgets/layout/wildcard_page/wildcard_page.dart` | `WildcardPageModel` — `@JsonSerializable`, type `st_wildcard_page`, holds `Map<String, StacWidget> children`. |
| `example/lib/stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart` | `WildcardPageParser` — picks the child from `arguments['wildcardPage']`. |
| `example/lib/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav.dart` | `StWildcardPageNavAction` + `WildcardPageNavType` — `@JsonSerializable`, actionType `wildcard_page_nav`. |
| `example/lib/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav_parser.dart` | `StWildcardPageNavActionParser` — maps the enum to a `StacNavigateAction` and dispatches. |
| `stac/example/wildcard_page/wildcard_page.dart` | DSL entry, `@StacScreen(screenName: "wildcard_page")`. |
| `stac/example/wildcard_page/pages/*.dart` | One unannotated builder per sub-page. |

Both parsers are registered in `example/lib/stac_runtime/stac_registry.dart` (`WildcardPageParser()` in `parsers`, `StWildcardPageNavActionParser()` in `actionParsers`).

### Adding a sub-page

1. Create `stac/example/wildcard_page/pages/<name>.dart` returning a `StacWidget` (no annotation — it's a helper, not a screen).
2. Add it to the map in `wildcard_page.dart`: `'<name>': <name>()`.
3. Navigate to it with `StWildcardPageNavAction(wildcardPage: '<name>')`.
4. `stac.exe build && stac.exe deploy` — or just save, if the watch session is running.

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

The app keeps **two** base URLs on purpose (`example/lib/utils/urls.dart`):

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

`STAC_BASE_API_URL` is unrelated to the app — it's the CLI's compile-time define, baked into `stac.exe`, used by `stac deploy`.

## CLI reference

`stac.exe` (compiled) is the full CLI; `dart run stac_cli/bin/stac_watch.dart` is the watch tool.

| Command | Purpose |
|---------|---------|
| `stac.exe init` | Scaffold a Stac project (`stac/` sample, `default_stac_options.dart`, optional skills install). |
| `stac.exe build` | Compile `stac/` → `stac/.build/` JSON. |
| `stac.exe deploy` | Push `stac/.build/` to `${STAC_BASE_API_URL}/app-screens\|themes/deploy`. |
| `stac.exe login` / `logout` / `status` | Cloud auth — currently no-ops; the auth check in `base_command.dart` is commented out. |
| `stac.exe project create --name <n>` / `project list` | Cloud project management. |
| `stac.exe skills add` | Install a skill. |
| `stac.exe upgrade` | Self-update the CLI (`--version`, `--force`). |
| `stac.exe --version` / `--help` | Version / usage. |
| `dart run stac_cli/bin/stac_watch.dart` | Local hot-reload loop (see above). |

Other flags worth knowing: `build --project <dir>`, `deploy --skip-build`, `project create --description <d>`, global `-v/--verbose`.

## Gotchas & sharp edges

- **Port 8090 must be free.** A second watch session (or any leftover process) makes startup die with a raw `SocketException: Failed to create server socket … errno = 10048` rather than a friendly message. Pass `--port 8099` or kill the old session.
- **`stacBaseUrl` and `STAC_LOCAL_DEV` are compile-time.** Editing `urls.dart` needs a full restart of the spawned app (`q`, then relaunch) — a hot reload won't pick it up. Process env vars can't change `fromEnvironment` values either; only `--dart-define` can, which is why the `STAC_BASE_API_URL` env var in `.vscode/launch.json` has no effect on the app.
- **Default host is a hardcoded LAN IP** (`192.168.1.17`). On another network the spawned app can't reach the dev server until you pass `--host` (use `localhost` for an emulator on the same machine).
- **Port mismatch in the fallback.** The watch server defaults to `8090`, but `urls.dart`'s `STAC_DEV_PORT` fallback is `8070`. It only matters if the define goes missing — the watch session always passes the real port.
- **Themes cost a hot restart**, so editing `st_theme.dart` is a slower cycle than editing a screen.
- **The `stac` git dependency is unpinned** (`ref: main`). Pin a commit SHA if you need reproducible builds.