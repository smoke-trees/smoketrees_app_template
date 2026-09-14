# Stac Codegen Tools Skill

## Overview

This skill provides guidance on using the Stac code generation tools available in the `__brick__` directory:
- `create_stac_parser.dart` - Generate custom Stac widget parsers
- `create_stac_action.dart` - Generate custom Stac action parsers

These tools scaffold complete implementations including models, parsers, and automatic registration.

## When to Use

Use this skill when:
- User asks to create a custom Stac widget
- User asks to create a custom Stac action
- User wants to scaffold new widget or action types
- User needs to generate boilerplate for Stac extensions
- User asks about the create_stac_parser.dart or create_stac_action.dart tools

## Tool 1: create_stac_parser.dart

### Purpose
Scaffolds a custom Stac widget with:
- Model class with JSON serialization
- Parser implementation extending `StacParser<T>`
- Auto-registration in stac_registry.dart
- Auto-export in main library file
- Build runner integration for code generation

### Usage
```bash
dart run create_stac_parser.dart <Name> [category] [subdir...]
```

### Parameters
- `<Name>` (required): PascalCase widget name (e.g., `MyWidget`, `CustomCard`, `PricingTable`)
- `[category]` (optional): Widget category, defaults to `layout`
- `[subdir...]` (optional): Additional subdirectories for organization

### Examples
```bash
# Basic widget in default layout category
dart run create_stac_parser.dart CustomCard

# Widget in custom category
dart run create_stac_parser.dart PricingTable pricing

# Widget with subdirectories
dart run create_stac_parser.dart FeatureGrid layout custom/marketing
```

### Generated Files
For `dart run create_stac_parser.dart CustomCard pricing`:
- `lib/stac_runtime/widgets/pricing/custom_card/st_custom_card.dart` - Model class
- `lib/stac_runtime/widgets/pricing/custom_card/st_custom_card_parser.dart` - Parser implementation
- `lib/stac_runtime/widgets/pricing/custom_card/st_custom_card.g.dart` - Generated JSON code

### Model Template
```dart
@JsonSerializable(explicitToJson: true)
class CustomCard extends StacWidget {
  const CustomCard({
    this.child,
  });

  final StacWidget? child;

  @override
  String get type => 'st_custom_card';

  factory CustomCard.fromJson(Map<String, dynamic> json) =>
      _$CustomCardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomCardToJson(this);
}
```

### Parser Template
```dart
class CustomCardParser extends StacParser<CustomCard> {
  @override
  String get type => 'st_custom_card';

  @override
  CustomCard getModel(Map<String, dynamic> json) => CustomCard.fromJson(json);

  @override
  Widget parse(BuildContext context, CustomCard model) {
    return SizedBox(child: model.child?.parse(context));
  }
}
```

### Registration
Automatically adds to `lib/stac_runtime/stac_registry.dart`:
```dart
CustomCardParser(),
```

And exports in main library file after the WildcardPageParser export.

## Tool 2: create_stac_action.dart

### Purpose
Scaffolds a custom Stac action with:
- Action model class extending `StacAction`
- Action parser implementing `StacActionParser<T>`
- Auto-registration in stac_registry.dart
- Auto-export in main library file
- Build runner integration

### Usage
```bash
dart run create_stac_action.dart <Name> [category] [subdir...]
```

### Parameters
- `<Name>` (required): PascalCase action name (e.g., `SubmitOrder`, `SendEmail`, `TrackEvent`)
- `[category]` (optional): Action category, defaults to `actions`
- `[subdir...]` (optional): Additional subdirectories

### Examples
```bash
# Basic action in default actions category
dart run create_stac_action.dart SubmitOrder

# Action in custom category
dart run create_stac_action.dart SendEmail notifications

# Action with subdirectories
dart run create_stac_action.dart TrackEvent analytics/custom
```

### Generated Files
For `dart run create_stac_action.dart SubmitOrder checkout`:
- `lib/stac_runtime/actions/checkout/submit_order/st_submit_order_action.dart` - Action model
- `lib/stac_runtime/actions/checkout/submit_order/st_submit_order_action_parser.dart` - Action parser
- `lib/stac_runtime/actions/checkout/submit_order/st_submit_order_action.g.dart` - Generated code

### Action Model Template
```dart
@JsonSerializable(explicitToJson: true)
class StSubmitOrderAction extends StacAction {
  const StSubmitOrderAction();

  @override
  String get actionType => 'submit_order';

  factory StSubmitOrderAction.fromJson(Map<String, dynamic> json) =>
      _$StSubmitOrderActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StSubmitOrderActionToJson(this);
}
```

### Action Parser Template
```dart
class StSubmitOrderActionParser extends StacActionParser<StSubmitOrderAction> {
  const StSubmitOrderActionParser();

  @override
  String get actionType => 'submit_order';

  @override
  StSubmitOrderAction getModel(Map<String, dynamic> json) => 
      StSubmitOrderAction.fromJson(json);

  @override
  Future<void> onCall(BuildContext context, StSubmitOrderAction model) async {
    // TODO: Implement the action behavior.
  }
}
```

### Registration
Automatically adds to `lib/stac_runtime/stac_registry.dart`:
```dart
StSubmitOrderActionParser(),
```

And exports after the StWildcardPageNavActionParser export.

## Workflow

### Creating a Custom Widget

1. **Determine the widget name and category**
   - Use PascalCase for the name
   - Choose appropriate category (layout, display, input, etc.)

2. **Run the generator**
   ```bash
   cd __brick__
   dart run create_stac_parser.dart MyWidget [category]
   ```

3. **Verify generation**
   - Check model file was created
   - Check parser file was created
   - Confirm registration in stac_registry.dart
   - Confirm export in main library file

4. **Implement widget logic**
   - Add properties to the model class
   - Update the parser's `parse()` method to return the actual Flutter widget
   - Add any necessary imports

5. **Regenerate if model changes**
   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```

### Creating a Custom Action

1. **Determine the action name and category**
   - Use PascalCase for the name (e.g., SubmitForm, TrackEvent)
   - Choose category if not using default `actions`

2. **Run the generator**
   ```bash
   cd __brick__
   dart run create_stac_action.dart MyAction [category]
   ```

3. **Verify generation**
   - Check action model file
   - Check action parser file
   - Confirm registration in stac_registry.dart

4. **Implement action behavior**
   - Add properties to the action model
   - Implement the `onCall()` method in the parser
   - Add any async logic, navigation, or side effects

5. **Regenerate if model changes**
   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```

## Important Notes

### Naming Conventions
- Widget/Action names MUST be PascalCase (e.g., `MyWidget`, `SubmitOrder`)
- Generated type names use snake_case (e.g., `st_my_widget`, `submit_order`)
- Action classes are prefixed with `St` and suffixed with `Action`
- Widget classes use the provided name directly

### File Structure
- Widgets go in `lib/stac_runtime/widgets/[category]/[snake_name]/`
- Actions go in `lib/stac_runtime/actions/[category]/[snake_name]/`
- Each gets its own directory with model, parser, and generated files

### Build Runner
- Tools automatically run `fvm dart run build_runner build --delete-conflicting-outputs`
- If `fvm` is not available, a placeholder `.g.dart` file is created
- Run build_runner manually if placeholders are created

### Registration
- Tools automatically update `stac_registry.dart` to register the new parser
- Tools automatically export the new files in the main library file
- Registration uses specific anchor points:
  - Widgets: After `WildcardPageParser()`
  - Actions: After `StWildcardPageNavActionParser()`

### Working Directory
- Both tools MUST be run from the `__brick__` directory
- Tools use `File.fromUri(Platform.script).parent` to find project root
- Tools set `Directory.current = root` before executing

## AI Assistant Guidelines

When using these tools:

1. **Always work from __brick__ directory**
   ```bash
   cd __brick__
   dart run create_stac_parser.dart ...
   ```

2. **Validate input before running**
   - Check name is PascalCase
   - Confirm category makes sense
   - Use appropriate defaults

3. **After generation, customize the implementation**
   - Don't leave TODO comments
   - Add necessary properties to models
   - Implement actual widget/action logic
   - Add proper imports

4. **Verify registration**
   - Check stac_registry.dart includes the new parser
   - Confirm exports are in the main library file
   - Look for the anchor lines used by the tools

5. **Handle build_runner**
   - If `.g.dart` file is a placeholder, run build_runner manually
   - Use `fvm dart run build_runner build --delete-conflicting-outputs`
   - Verify the generated code compiles

6. **Common pitfalls to avoid**
   - Don't run from wrong directory
   - Don't use lowercase or snake_case names
   - Don't modify registration anchors in stac_registry.dart
   - Don't forget to implement the TODO sections

## Example Workflows

### Example 1: Create a Custom Badge Widget
```bash
cd __brick__
dart run create_stac_parser.dart Badge display
```

Then edit `lib/stac_runtime/widgets/display/badge/st_badge.dart`:
```dart
class Badge extends StacWidget {
  const Badge({
    required this.text,
    this.color,
    this.child,
  });

  final String text;
  final String? color;
  final StacWidget? child;
  
  @override
  String get type => 'st_badge';
  // ... rest of implementation
}
```

Edit parser `lib/stac_runtime/widgets/display/badge/st_badge_parser.dart`:
```dart
@override
Widget parse(BuildContext context, Badge model) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: model.color != null 
          ? Color(int.parse(model.color!.replaceFirst('#', '0xFF')))
          : Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      model.text,
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}
```

### Example 2: Create a TrackEvent Action
```bash
cd __brick__
dart run create_stac_action.dart TrackEvent analytics
```

Then edit the action model to add properties:
```dart
class StTrackEventAction extends StacAction {
  const StTrackEventAction({
    required this.eventName,
    this.properties,
  });
  
  final String eventName;
  final Map<String, dynamic>? properties;
  
  @override
  String get actionType => 'track_event';
  // ... rest of implementation
}
```

Implement the action:
```dart
@override
Future<void> onCall(BuildContext context, StTrackEventAction model) async {
  // Send to analytics service
  await AnalyticsService.track(
    model.eventName,
    properties: model.properties ?? {},
  );
  debugPrint('Tracked event: ${model.eventName}');
}
```

## Troubleshooting

### "Could not find registration anchor"
- The tools look for specific lines in stac_registry.dart
- Ensure `WildcardPageParser()` exists for widgets
- Ensure `StWildcardPageNavActionParser()` exists for actions
- Don't modify or remove these anchor lines

### "Name must be a PascalCase Dart identifier"
- Use PascalCase: MyWidget, SubmitOrder, TrackEvent
- Don't use: my_widget, submit-order, track_event

### Build runner fails
- Ensure you're in the __brick__ directory
- Run manually: `fvm dart run build_runner build --delete-conflicting-outputs`
- Check for syntax errors in the generated model files

### Parser not being called
- Verify registration in stac_registry.dart
- Check the `type` or `actionType` matches exactly
- Ensure Stac.initialize includes your registry

## Summary

These code generation tools provide a consistent, automated way to extend Stac with custom widgets and actions. They handle boilerplate, registration, and code generation so developers can focus on implementing the actual widget rendering and action behavior.
