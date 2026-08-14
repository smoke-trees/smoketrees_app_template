# Example application

This directory contains the runnable application and its Stac screen DSL. It
uses the reusable widgets, themes, models, and parsers from the root `lib/`
directory.

## Layout

```text
example/
├── lib/                  # Flutter application, features, backend, and routes
│   ├── main.dart
│   ├── app/
│   ├── core/
│   ├── features/
│   ├── shared/           # Example-specific UI
│   ├── stac_runtime/     # Example parser/action composition
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
