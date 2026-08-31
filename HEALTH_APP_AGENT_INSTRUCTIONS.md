# Agent Brief: Local Health Habit Tracker

## Objective

Turn the Stac Flutter template in the current directory into a small, polished daily health habit tracker for a senior-level presentation.

The purpose is to demonstrate Stac layouts, forms, conditional UI, local interaction, progress, and reusable screen composition. This is a local UI prototype, not a medical or production tracking application.

## Hard Constraints

- Do not create or call a backend.
- Do not make HTTP requests for application data.
- Do not add authentication, accounts, cloud sync, analytics, or a database.
- Do not collect sensitive health information.
- Keep all initial habit data in local Dart constants used by the Stac DSL.
- Persistence across restarts is not required. Prefer in-memory state; use existing local storage only if it is already trivial and clearly improves the demo.
- Keep the app to three compact screens: Today, Add Habit, and Weekly Summary.
- Use the Stac DSL for screen structure and styling wherever the installed Stac API supports it.
- Use existing template parsers and actions before creating custom ones.
- Add a custom parser or action only when required for a meaningful local interaction that cannot be implemented with existing Stac primitives.
- Do not hand-edit generated files under `stac/.build/`, `stac/.dev-build/`, or any `*.g.dart` file.
- Do not retain unrelated sample flows such as authentication or backend-powered to-do features in the finished demo.

## First Steps

Before editing:

1. Read `README.md`, `pubspec.yaml`, `lib/main.dart`, `lib/app/app_pages.dart`, `lib/stac_runtime/stac_registry.dart`, and the current files under `stac/lib/`.
2. Inspect the exact Stac version and source available in this checkout. Do not guess constructor names, action names, form behavior, or model fields.
3. Inspect existing custom widgets such as `StMainButton`, `StAnimatedIconToggle`, `StDismissible`, `StReorderableListViewBuilder`, `StConditionalWidget`, `StAnimatedContainer`, `StPageView`, `StCustomBottomBar`, and `StDialog` before deciding whether they are useful.
4. Preserve reusable infrastructure under `lib/shared/` and `lib/stac_runtime/` unless a small extension is genuinely necessary.
5. Establish a simple local state approach. Do not introduce a repository, service layer, or mock API for static demo data.

## Product Scope

Use a calm but distinctive visual identity: deep green or indigo, a warm neutral background, clear progress accents, and restrained illustrations or icons. Avoid presenting health scores as medical advice. The UI must work on a typical phone and remain usable on a wider window.

Start with these five local habits:

- Morning walk, target 20 minutes
- Drink water, target 6 glasses
- Stretch, target 10 minutes
- Read before bed, target 15 minutes
- Sleep routine, target bedtime 10:30 PM

Each habit should have a stable ID, title, short target label, icon, category, completion state, and optional streak. Use simple local constants rather than JSON files or fake network responses.

## Required Screens

### 1. Today

Create the main dashboard containing:

- Friendly date/header area
- A concise message such as `3 of 5 habits complete`
- Circular or linear progress presentation
- Five habit rows/cards with icon, title, target, streak, and completion control
- Completed habits rendered differently from incomplete habits
- A small motivational message that changes for zero, partial, and full completion when existing conditional state supports it
- Entry point to add a habit
- Entry point to weekly summary

At least one completion control must visibly update local UI state. Ideally progress and the message update as well, but do not build disproportionate native infrastructure solely for aggregate calculations.

### 2. Add Habit

Create a compact local form containing:

- Habit name
- Category selection with 3 or 4 categories
- Frequency selection such as daily or weekdays
- Target or reminder text
- Optional reminder toggle
- Save button
- Cancel or back action

Use available Stac form widgets and validation. Habit name must be required. Saving should show a confirmation snackbar/dialog and return to Today. If adding the new item to the Today list requires substantial custom state plumbing, use a clearly labeled preview card or confirmation summary instead of pretending it was persisted.

No notification scheduling or permission request is needed. The reminder field is purely demonstrative.

### 3. Weekly Summary

Create a static but convincing summary containing:

- Current streak
- Weekly completion percentage
- Seven-day row or simple bar visualization
- Per-habit completion summary for 3 representative habits
- Best-day callout
- Encouraging message
- Back navigation

Use fixed local weekly values. Do not add a chart dependency unless the repository already contains one and using it is substantially simpler than composing bars with standard Stac containers.

## Interaction Priorities

Implement interactions in this order. Stop adding complexity when the next item would require architecture unrelated to demonstrating Stac.

1. Navigation among Today, Add Habit, and Weekly Summary.
2. Toggle at least one habit between incomplete and complete.
3. Validate the add-habit form and show save confirmation.
4. Conditional motivational message or completion styling.
5. Dismiss or reorder habits if existing parsers make it straightforward.
6. Recalculate aggregate progress and append newly created habits only if existing Stac local-state actions support this cleanly.

State may reset on restart. Static weekly metrics are expected. Be transparent in code and in the final report about which values are interactive and which are presentation data.

## Stac Demonstration Goals

The finished demo should make these capabilities easy to point out:

- Annotated `@StacScreen` DSL compiled to JSON
- Composition of responsive layouts, cards, icons, text, progress, and buttons
- Reusable Dart helpers that return `StacWidget` trees
- Navigation actions
- Form fields, validation, and action sequencing
- Conditional rendering or styling based on local values
- At least one animated container, toggle, or state transition
- Optional dismissible or reorderable list behavior when feasible
- A visual change that can be demonstrated by editing the DSL and letting `stac watch` reload it

Include one obvious live-edit demonstration in the code, such as constants for the daily goal, motivational copy, accent color, habit ordering, or weekly callout. Add a short comment identifying the intended presentation edit, but do not clutter the UI with developer explanations.

## Suggested Organization

Adapt names to the repository’s established structure after inspecting it. A reasonable target is:

```text
stac/lib/
  health_demo/
    today_screen.dart
    add_habit_screen.dart
    weekly_summary_screen.dart
    habit_data.dart
    widgets/
      habit_card.dart
      progress_header.dart
      weekly_bar.dart
```

Keep helpers unannotated and annotate only actual routed screens. Register every screen route required by the runtime. If one pre-registered wildcard route provides a materially simpler implementation, it may be used, but ordinary named screens are preferred for this fixed three-screen demo.

## Quality Bar

- No overflow on a narrow phone viewport.
- Content scrolls where necessary and the form remains reachable with the keyboard open.
- Tap targets and text contrast are reasonable.
- Incomplete, completed, validation, and confirmation states look intentional.
- Do not use alarmist medical language, diagnosis, or health claims.
- Avoid excessive gradients, random colors, generic dashboard styling, and unnecessary animations.
- Keep files and abstractions small. Do not build a health platform architecture.
- Follow existing formatting and lint rules.
- Remove obsolete sample routes/screens only when they belong to this copied demo and are no longer referenced. Never modify generated artifacts manually.

## Verification

Complete all applicable checks and fix failures caused by the implementation:

1. Run dependency resolution only if needed.
2. Run code generation only if a serializable Stac model or action was added or changed.
3. Run `stac build` and confirm each annotated screen produces JSON.
4. Run `flutter analyze` or the repository’s FVM equivalent.
5. Run existing tests and add focused tests only for native logic introduced by this demo.
6. Run or smoke-test the app when a device is available and verify all three screens, form validation, and local interactions.

Do not claim an interaction works unless it was verified. If an intended interaction is unsupported by the installed Stac API, implement the smallest honest fallback and document that limitation in the final report.

## Definition of Done

- The app opens into the Today dashboard without requiring a backend.
- Today, Add Habit, and Weekly Summary screens are reachable.
- Five local habits and seven days of local summary data are presented consistently.
- At least one habit completion interaction works visibly.
- Add Habit validates required input and provides honest local confirmation.
- Completed and incomplete states are visually distinct.
- No network request is made for application data.
- `stac build` succeeds.
- Static analysis passes, aside from clearly identified pre-existing issues.
- The final report lists changed files, verification commands, any intentionally static values, and one suggested live-edit sequence for the presentation.
