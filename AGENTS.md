# Agent Guidelines — smoketrees_app_template (Mason Brick)

This repository **is the Mason brick** that adds Smoke Trees Stac (Server-Driven UI) to an existing Flutter app. `__brick__/` is the source of truth for generated projects. The root Flutter app (`lib/`, `stac/`, `assets/`, etc.) is the checked-out dev copy used to exercise and test the brick.

## Stack

- Flutter + Dart (`sdk: ^3.12.0`, FVM via `.fvmrc`, `flutter_lints` in `analysis_options.yaml`)
- Mason (`brick.yaml` vars: `project_name`, `description`, `include_example_screens`, `include_network_layer`, `include_firebase`)
- Stac DSL (`stac/lib/` → `stac build` → `stac/.build/` + `stac/.dev-build/`, runtime in `lib/stac_runtime/`)
- GetX for controllers/bindings/navigation in example code
- Dio + `pretty_dio_logger` + `dio_cache_interceptor`, Hive + `hive_flutter`, `json_serializable` + `build_runner`

## Repository Layout

- `__brick__/` — authoritative Mason source; edit here when changing generated output
- `__brick__/lib/` — infra copied into host app (`app/`, `core/`, `shared/`, `stac_runtime/`, `theme/`, `utils/`, `enums/`)
- `__brick__/example/` — optional reference screens (`splash`, `auth`, `counter`)
- `__brick__/stac/lib/` — server-driven screen DSL (`hello_world.dart`)
- `__brick__/assets/` — images/svgs/lotties
- `__brick__/hooks/` — `pre_gen`/`post_gen` (runs `flutter pub get`, `build_runner`, `stac build`)
- `__brick__/create_stac_parser.dart` / `__brick__/create_stac_action.dart` — scaffolders
- `brick.yaml`, `mason.yaml` — brick metadata
- Root `lib/`, `stac/`, `example/` — dev mirrors of `__brick__/`; keep in sync when behavior should match

## Source of Truth

- Change `__brick__/` when changing what `mason make smoketrees_app` generates.
- Mirror intentional changes to the root dev copy so the brick can be run/tested here.
- Never hand-edit `.build/`, `.dev-build/`, `.dart_tool/`, `build/`, `.g.dart`, `.freezed.dart`.
- Keep `AGENTS.md`, `CLAUDE.md`, `.agents/skills/`, `.claude/skills/`, `skills-lock.json` in both root and `__brick__/` so generated apps inherit agent setup (see `.gitignore` negations).
- Preserve Mason placeholders: `{{project_name}}`, `{{description}}`, conditional file guards for `include_*` vars.

## Flutter & Dart Conventions (enforced via `flutter_lints`)

- **Formatting:** `dart format .` — no manual style overrides.
- **Analysis:** `flutter analyze` must be clean; `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`.
- **Files:** `snake_case.dart` — widgets/screens one per file, colocate `stac/` model + parser (`st_to_do_tile.dart`, `st_to_do_tile.g.dart`, `st_to_do_tile_parser.dart`).
- **Types:** `PascalCase` for classes/enums/extensions/typedefs, `camelCase` for vars/methods/params/properties, `SCREAMING_SNAKE` for constants.
- **Null safety:** prefer typed models over `dynamic`; avoid `any`/`Object?` leakage; use `?`, `required`, `const` constructors and `super.key`.
- **Widgets:** small, composable, `const` where possible; reusable non-Stac UI in `lib/shared/`; Stac behavior in `lib/stac_runtime/` models/parsers/actions.
- **State:** follow existing GetX patterns (`GetxController`, `Rx`, `Obx`, `Bindings`, `Get.find()`); don't mix in Bloc/Riverpod without explicit ask.
- **Imports:** Dart → Flutter → package → relative, sorted; no unused imports.
- **Logging:** no `print`; use `utils/console_logger.dart` / `pretty_dio_logger` patterns.

## Stac Rules

- Every custom widget/action needs a model (`json_annotation`), parser (`StacParser<T>`), and registration in `lib/stac_runtime/stac_registry.dart` (and `example/lib/stac_runtime/stac_registry.dart` when examples are enabled).
- Keep `@StacScreen(screenName: '...')` in `stac/lib/`; `screenName` maps to `Stac(routeName: ...)`.
- Scaffold via `dart run create_stac_parser.dart <Name> [category] [subdir...] [--inject-data]` and `dart run create_stac_action.dart <Name> [category]`.
- Preserve JSON field names / parser `type` strings once shipped — breaking them breaks server payloads.
- Follow existing navigation (`lib/app/app_pages.dart`, `lib/app/app_nav.dart`, `StWildcardPageNav` action) — no ad-hoc route handling.

## Scaffolding Tools — `create_stac_parser.dart` & `create_stac_action.dart`

Both live in repo root and `__brick__/` and are copied to the generated app root; after `mason make` run them from the app root. They set `Directory.current` to the script location so execution directory does not matter.

- **`create_stac_parser.dart`** — `create_stac_parser.dart:1`
  - Usage: `dart run create_stac_parser.dart <PascalCaseName> [category] [subdir...] [--inject-data]` — `name` must match `^[A-Z][A-Za-z0-9]*$`.
  - `snake` + `type` derivation: `MyWidget` → `st_my_widget.dart` / `st_my_widget_parser.dart` / `st_my_widget.g.dart`, `type = 'st_my_widget'`.
  - `category` defaults to `layout` when omitted; any extra positionals become nested subdirs. `dart run create_stac_parser.dart ProductCard collections` → `lib/stac_runtime/widgets/collections/product_card/...`. `category` is validated to reject `.`/`..`.
  - Writes model + parser under `lib/stac_runtime/widgets/<category>/<snake>/`, then auto-patches `lib/smoketrees_app_template.dart` exports (after `wildcard_page_parser.dart`) and `lib/stac_runtime/stac_registry.dart` (`WildcardPageParser(),` anchor) via `_insertAfter`.
  - `--inject-data` mode generates a data-injection parser: model has `endpoint`/`items`/`actionKey` + `childTemplate`/`loadingWidget`/`errorWidget`/`emptyWidget` with `{{key}}` placeholders; parser uses `Dio`, `ActionRegistry.call`, `inject_data.dart`, `Stac.fromJson` and `FutureBuilder` branches (`_buildWithAction` / `_buildWithEndpoint` / `_buildWithItems` / `_buildList`). Non-inject mode generates a simple `StacWidget? child` model and `SizedBox(child: model.child?.parse(context))` parser.
  - Finally tries `fvm dart run build_runner build --delete-conflicting-outputs` (inherits stdio); if `fvm` missing, writes a placeholder `part of 'st_<snake>.dart';` and instructs to run `build_runner` manually. See `create_stac_parser.dart:357`.

- **`create_stac_action.dart`** — `create_stac_action.dart:1`
  - Usage: `dart run create_stac_action.dart <PascalCaseName> [category] [subdir...]` — no `--inject-data`.
  - `SubmitOrder` → `st_submit_order_action.dart` / `st_submit_order_action_parser.dart` / `st_submit_order_action.g.dart` under `lib/stac_runtime/actions/<category>/<snake>/`, `actionType = 'snake_case'`.
  - Generates `St<Action> extends StacAction` model (`st_<snake>_action.dart:61`) and `St<Action>Parser extends StacActionParser` (`st_<snake>_action_parser.dart:83`) with `getModel` + `onCall(BuildContext, model)` stub.
  - Same auto-patching: exports in `lib/smoketrees_app_template.dart` (after `st_wildcard_page_nav_parser.dart`) and `lib/stac_runtime/stac_registry.dart` (`StWildcardPageNavActionParser(),` anchor), then same `fvm build_runner` attempt with placeholder fallback (`create_stac_action.dart:157`).

Always verify the registry entry was inserted and run `dart run build_runner build --delete-conflicting-outputs` + `stac build` if the placeholder was written.

## Mason Rules

- Keep `brick.yaml` vars compatible and defaults meaningful (`my_stac_app`, `false`/`true` flags).
- Preserve conditionals: `include_example_screens`, `include_network_layer`, `include_firebase`.
- Don't add/replace `android/`/`ios/`/`web/`/`macos/` in the brick — it augments an existing host project.
- Test both default and non-default variable combos after changing conditional files.

## Workflow (brick contributor)

1. `fvm use` (or `flutter --version` matches `.fvmrc`) → `flutter pub get`
2. Edit `__brick__/` (mirror to root if needed)
3. `dart run build_runner build --delete-conflicting-outputs` after model/hive changes
4. `stac build` after `stac/lib/` changes
5. `dart format .` + `flutter analyze`
6. `flutter test` if tests cover the change
7. Verify brick: `flutter create /tmp/host && cd /tmp/host && mason init && mason add smoketrees_app --path /path/to/smoketrees_app_template && mason make smoketrees_app` with varied vars; ensure `AGENTS.md`, `CLAUDE.md`, `.agents/skills/grill*`, `.claude/skills/grill*`, `skills-lock.json` present.

Local dev loop (inside host or root dev app): `stac watch` (needs Tailscale Funnel) + `flutter run` (`stac watch --no-app` to run separately).

## Verification (run before PR)

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- `dart run build_runner build --delete-conflicting-outputs` (when models/parsers/g.dart affected)
- `stac build` (when Stac DSL affected)
- Brick generation smoke test as above

## Docs & Safety

- Update `README.md` + `__brick__/smoketrees_app_template.md` when setup/generation structure changes.
- Keep comments minimal, for non-obvious behavior only.
- Don't commit secrets, `.env`, `skills-lock.json` is intentional, but never credentials; ignore `build/`, `.dart_tool/`, `.stac/`, `pubspec.lock` noise per `.gitignore`.
- Don't touch migrations/external server contracts unless explicitly requested.

## Skills

- `.agents/skills/grill-me`, `grill-with-docs`, `grilling` (from `mattpocock/skills`) — stress-test plans via design-tree rounds. `.claude/skills/` mirrors them for Claude.
- Stac-specific skills in `.agents/skills/stac-*` — use for `stac init/build/watch/deploy` and parser scaffolding.
- `skills-lock.json` is `{version:1, skills:{...}}` with only the three grill skills — keep root and `__brick__/` in sync.
