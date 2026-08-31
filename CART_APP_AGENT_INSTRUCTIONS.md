# Agent Brief: Mini Food Menu and Cart

## Objective

Turn the Stac Flutter template in the current directory into a small, polished food menu and cart demo for a senior-level presentation.

The purpose is to demonstrate how much of an application can be described with Stac. This is a local prototype, not a production commerce application.

## Hard Constraints

- Do not create or call a backend.
- Do not make HTTP requests for application data.
- Do not add authentication, accounts, payment, checkout, analytics, or a database.
- Keep all menu data in local Dart constants used by the Stac DSL.
- Prefer bundled assets. Network images are acceptable only as decorative content and the app must remain usable if they fail.
- Keep the app to three compact screens: menu, item details, and cart.
- Use the Stac DSL for screen structure and styling wherever the installed Stac API supports it.
- Use existing template parsers and actions before creating custom ones.
- Add a custom parser or action only when required for a meaningful local interaction that cannot be implemented with existing Stac primitives.
- Do not hand-edit generated files under `stac/.build/`, `stac/.dev-build/`, or any `*.g.dart` file.
- Do not retain unrelated sample flows such as authentication or backend-powered to-do features in the finished demo.

## First Steps

Before editing:

1. Read `README.md`, `pubspec.yaml`, `lib/main.dart`, `lib/app/app_pages.dart`, `lib/stac_runtime/stac_registry.dart`, and the current files under `stac/lib/`.
2. Inspect the exact Stac version and source available in this checkout. Do not guess constructor names, action names, or model fields.
3. Inspect existing custom widgets such as `StMainButton`, `StAnimatedIconToggle`, `StDismissible`, `StPageView`, `StCustomBottomBar`, and `StDialog` before deciding whether they are useful.
4. Preserve reusable infrastructure under `lib/shared/` and `lib/stac_runtime/` unless a small extension is genuinely necessary.
5. Establish a simple route and state approach that works completely offline.

## Product Scope

Use a fictional modern cafe or street-food brand. Choose a deliberate visual identity rather than a generic Material demo. Use a warm palette, strong food imagery, clear typography, rounded cards, and consistent spacing. The UI must work on a typical phone and remain usable on a wider window.

Use 6 fixed menu items across 3 categories. Each item should contain:

- Stable ID
- Name
- Short description
- Category
- Price
- Image asset or reliable image URL
- Vegetarian flag
- Available flag
- Optional featured or popular flag

Suggested items may include burgers, wraps, bowls, fries, drinks, and dessert. Keep names and prices internally consistent.

## Required Screens

### 1. Menu

Create an attractive landing/menu screen containing:

- Brand header and short subtitle
- One promotional or featured banner
- Three visible category chips or sections
- Six menu-item cards
- Item image, name, short description, price, and relevant badges
- A clear cart entry point with an item-count indicator if local state supports it cleanly
- An unavailable item rendered differently with its action disabled
- Navigation from an available item to its detail screen

The item list may be constructed from local constants at DSL build time. Do not introduce a fake repository or mock API merely to imitate remote data.

### 2. Item Details

Create one reusable detail layout populated from the selected item when supported by the routing/state APIs. If dynamic route arguments would require disproportionate native code, create a representative detail screen for one featured item instead.

Include:

- Large image
- Name, description, price, and dietary badge
- Two size choices
- Three optional add-ons
- Quantity selector or a simple fixed quantity if local mutation is not practical
- Favorite toggle using an existing animated toggle when appropriate
- Add-to-cart button
- Back navigation

Size and add-on selections should visibly change selection state if existing Stac local-state actions support it. Do not build complex infrastructure solely to calculate prices in real time.

### 3. Cart

Seed the cart with 2 representative items so the screen is useful immediately, even after a cold start. Include:

- Item image or thumbnail
- Item name and selected options
- Quantity and line price
- Remove interaction using a dismissible row if supported
- Subtotal, fixed delivery fee, and total
- A checkout-style primary button labeled `Place demo order`
- Confirmation dialog or snackbar explaining that this is a local demo
- An empty-cart presentation that can be shown after removing all items if local state supports it cleanly

The order button must not perform payment or network activity.

## Interaction Priorities

Implement interactions in this order. Stop adding state complexity when the next item would require substantial architecture unrelated to demonstrating Stac.

1. Navigation among menu, item details, and cart.
2. Dialog or snackbar from `Place demo order`.
3. Favorite animation or toggle.
4. Visible local selection for size and add-ons.
5. Dismissible cart rows and an empty state.
6. Shared cart mutation and live totals only if the existing Stac state/action facilities make it straightforward.

It is acceptable for cart data to reset when the app restarts. It is also acceptable to use a seeded cart rather than implementing a complete cart domain model. Clearly favor a reliable presentation over simulated production architecture.

## Stac Demonstration Goals

The finished demo should make these capabilities easy to point out:

- Annotated `@StacScreen` DSL compiled to JSON
- Composition of layout, text, images, icons, cards, badges, and buttons
- Reusable Dart helpers that return `StacWidget` trees
- Navigation actions
- Conditional rendering or styling for vegetarian, featured, and unavailable items
- A dialog, snackbar, or equivalent feedback action
- At least one animation or interactive toggle
- A list interaction such as dismissing an item, when feasible
- A visual change that can be demonstrated by editing the DSL and letting `stac watch` reload it

Include one obvious live-edit demonstration in the code, such as constants for promotion text, accent color, featured item, or item availability. Add a short comment identifying the intended presentation edit, but do not clutter the UI with developer explanations.

## Suggested Organization

Adapt names to the repository’s established structure after inspecting it. A reasonable target is:

```text
stac/lib/
  cart_demo/
    menu_screen.dart
    item_detail_screen.dart
    cart_screen.dart
    menu_data.dart
    widgets/
      food_card.dart
      section_header.dart
```

Keep helpers unannotated and annotate only actual routed screens. Register every screen route required by the runtime. If one pre-registered wildcard route provides a materially simpler implementation, it may be used, but ordinary named screens are preferred for this fixed three-screen demo.

## Quality Bar

- No overflow on a narrow phone viewport.
- Content scrolls where necessary.
- Tap targets and text contrast are reasonable.
- Empty, disabled, and confirmation states look intentional.
- Avoid excessive gradients, random colors, generic dashboard cards, and unnecessary animations.
- Keep files and abstractions small. Do not build a commerce architecture.
- Follow existing formatting and lint rules.
- Remove obsolete sample routes/screens only when they belong to this copied demo and are no longer referenced. Never modify generated artifacts manually.

## Verification

Complete all applicable checks and fix failures caused by the implementation:

1. Run dependency resolution only if needed.
2. Run code generation only if a serializable Stac model or action was added or changed.
3. Run `stac build` and confirm each annotated screen produces JSON.
4. Run `flutter analyze` or the repository’s FVM equivalent.
5. Run existing tests and add focused tests only for native logic introduced by this demo.
6. Run or smoke-test the app when a device is available and verify all three screens and interactions.

Do not claim an interaction works unless it was verified. If an intended interaction is unsupported by the installed Stac API, implement the smallest honest fallback and document that limitation in the final report.

## Definition of Done

- The app opens into the menu demo without requiring a backend.
- Menu, item detail, and cart screens are reachable.
- Six local items and a seeded two-item cart are presented consistently.
- Unavailable and dietary states are visually demonstrated.
- At least one local interactive state and one confirmation interaction work.
- No network request is made for application data.
- `stac build` succeeds.
- Static analysis passes, aside from clearly identified pre-existing issues.
- The final report lists changed files, verification commands, and one suggested live-edit sequence for the presentation.
