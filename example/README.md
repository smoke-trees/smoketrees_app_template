# Example application

This directory contains the runnable application and its Stac screen DSL. It
uses the reusable widgets, themes, models, and parsers from the root `lib/`
directory.

> **Do NOT delete this `example/` folder.** It is not just a sample app — it
> holds dozens of reusable widgets under `example/lib/shared/` (buttons, cards,
> dialogs, fields, pages, players, chips, app-wide widgets), the example Stac
> models/parsers/actions under `example/lib/stac_runtime/` and
> `example/lib/features/`, and the runnable app itself. Those widgets can be
> copied or imported into the main `lib/` folder. Removing it breaks the app,
> the watch loop, and the deploy pipeline.

## Layout

```text
example/
├── lib/                  # Flutter application, features, backend, and routes
│   ├── main.dart
│   ├── app/
│   ├── core/
│   ├── features/
│   ├── shared/           # Example-specific UI
│   ├── stac_runtime/     # Example-specific parser/action composition
│   └── utils/
└── stac/
    └── lib/              # Stac screens, themes, and composition helpers
```

Run the application from the repository root:

```sh
fvm flutter run -t example/lib/main.dart
```

Run the local Stac development loop from the repository root:

```sh
fvm dart run stac_cli/bin/stac_watch.dart
```

When adding code, use this ownership rule:

- Put reusable Flutter widgets, Stac models/parsers, and editable themes in
  root `lib/`.
- Put application features, routes, controllers, backend integrations, and
  app-specific widgets in `example/lib/`.
- Put deployable Stac screens and themes in `example/stac/lib/`.

## Scaffolding a custom Stac widget parser

Custom server-driven widgets live under the **root `lib/stac_runtime/widgets/`**
as a **model + `.g.dart` + parser** trio, exported from the `smoketrees_app_template`
barrel and registered in `lib/stac_runtime/stac_registry.dart`. The root-level
`create_stac_parser.sh` script scaffolds all of it:

```sh
# from the repository root
./create_stac_parser.sh <Name> [category] [subdir...]

# examples
./create_stac_parser.sh MyCard              # → lib/stac_runtime/widgets/layout/my_card/
./create_stac_parser.sh ImageTile layout    # → lib/stac_runtime/widgets/layout/image_tile/
./create_stac_parser.sh ChatBubble inbox    # → lib/stac_runtime/widgets/inbox/chat_bubble/
```

What it does:

1. Creates `st_<snake>.dart` (a `@JsonSerializable` `StacWidget` model),
   `st_<snake>_parser.dart` (a `StacParser<Name>` with a `parse` placeholder),
   and a `st_<snake>.g.dart` header in `lib/stac_runtime/widgets/<category>/<snake>/`.
2. Exports both files from `lib/smoketrees_app_template.dart`.
3. Registers `NameParser()` in `lib/stac_runtime/stac_registry.dart`.
4. Runs `fvm dart run build_runner build --delete-conflicting-outputs` to
   generate the real `.g.dart` — or prints the command if `fvm` isn't found.

Then fill in the model's fields and the parser's `parse` body. See
`lib/stac_runtime/widgets/layout/material/` for a complete reference.

### Custom Stac actions

Actions use the same trio under **root `lib/stac_runtime/actions/`**, exported
from the barrel and registered in the `actionParsers` list. Scaffold with the
root-level `create_stac_action.sh`:

```sh
# from the repository root
./create_stac_action.sh <Name> [category] [subdir...]

# examples
./create_stac_action.sh SubmitOrder               # → lib/stac_runtime/actions/actions/submit_order/
./create_stac_action.sh SubmitOrder checkout      # → lib/stac_runtime/actions/checkout/submit_order/
```

Creates `st_<snake>_action.dart` (a `@JsonSerializable` `StacAction` model with
an `actionType` getter), `st_<snake>_action_parser.dart` (a
`StacActionParser<St<Name>Action>` with an `onCall` placeholder), and the
`.g.dart` header; exports both files; registers the parser in
`lib/stac_runtime/stac_registry.dart`; and runs `build_runner`. See
`lib/stac_runtime/actions/wildcard_page_nav/` for a complete reference.
