I’ll check whether this repository already has a bootstrap or rename mechanism and distinguish it from stac init, which may only initialize Stac rather than copy this full application template.
✱Glob "**/*{init,setup,bootstrap,rename,template}*.{dart,ps1,sh,yaml,json}" (4 matches)
✱Glob ".stac/**/*" 
✱Grep "stac init|package_rename|rename_app|change_app_package|applicationId|PRODUCT_BUNDLE_IDENTIFIER" in . (10 matches)
→Read .fvmrc 
Thought: 2.6s
Recommending custom Mason brick for Flutter packageExplaining Mason and Dart CLI template workflowsClarifying Mason tokenization and template scope
Yes. The cleanest solution is to package this repository as a Mason brick so a complete application can be generated with one command.
Recommended Workflow
Instead of creating an empty Flutter project first, generate the complete project directly:
mason make smoketrees_app `
  --project_name health_habits `
  --organization com.smoketrees `
  --app_name "Health Habits" `
  --output-dir .
That command can generate:
- Flutter Android, iOS, web, Windows, macOS, and Linux files
- lib/shared/
- lib/stac_runtime/
- lib/core/
- stac/
- .stac/
- Stac configuration
- pubspec.yaml
- .fvmrc
- Assets
- Tests
- Correct Dart package imports
- Correct Android application ID
- Correct iOS bundle identifier
- Correct display name
For example, these values would be generated automatically:
Dart package:       health_habits
Android app ID:     com.smoketrees.health_habits
iOS bundle ID:      com.smoketrees.healthHabits
Display name:       Health Habits
You would no longer search and replace smoketrees_app_template manually.
Why stac init Is Not Enough
The existing command:
stac init
only initializes the basic Stac integration, such as:
- stac/
- A sample screen
- default_stac_options.dart
- Optional Stac skills/configuration
It does not currently copy all the reusable infrastructure from this repository, including:
- Custom Stac parsers
- Custom Stac actions
- Shared widgets
- Network and storage setup
- Theme utilities
- Application routing
- Assets
- Template-specific dependencies
Therefore, stac init is useful for adding Stac to an ordinary Flutter project, but it does not generate this complete SmokeTrees template.
How the Mason Brick Would Work
The template files would use placeholders rather than fixed identifiers.
For example, pubspec.yaml would contain a project-name variable:
name: {{project_name}}
Dart imports would be generated with the selected package name:
import 'package:{{project_name}}/smoketrees_app_template.dart';
Android configuration would use generated identifiers:
namespace = "{{organization}}.{{project_name}}"
applicationId = "{{organization}}.{{project_name}}"
The iOS project would also receive the corresponding bundle identifier rather than retaining:
com.example.smoketreesAppTemplate
The brick can run a post-generation hook that performs:
flutter pub get
dart run build_runner build --delete-conflicting-outputs
stac build
It can also optionally delete example features based on generation options.
Suggested Generation Questions
The generator should request only a few values:
Project name: health_habits
App display name: Health Habits
Organization: com.smoketrees
Description: A local Stac health habit demo
Include example screen: yes/no
Include network layer: yes/no
Include Firebase dependencies: yes/no
For your cart and health demos, the resulting commands could look like:
mason make smoketrees_app `
  --project_name stac_cart_demo `
  --organization com.smoketrees `
  --app_name "Stac Cart Demo" `
  --output-dir "C:\smoketrees\demos\stac_cart_demo"
mason make smoketrees_app `
  --project_name stac_health_demo `
  --organization com.smoketrees `
  --app_name "Stac Health Demo" `
  --output-dir "C:\smoketrees\demos\stac_health_demo"
Installing the Generator
After adding a brick.yaml to this repository, you could install it directly from Git:
dart pub global activate mason_cli
mason init
mason add smoketrees_app --git-url https://github.com/your-org/smoketrees-app-template.git --git-path brick
Then generate projects anywhere with:
mason make smoketrees_app
A local installation during development would be:
mason add smoketrees_app --path "C:\smoketrees\app\smoketrees_app_template\brick"
Even Simpler Custom Command
If you want a branded command instead of exposing Mason, a small Dart CLI can wrap the same process:
smoketrees create stac_health_demo `
  --org com.smoketrees `
  --display-name "Stac Health Demo"
Internally, that CLI would:
1. Download or bundle the template.
2. Generate project identifiers.
3. Create the target directory.
4. Update native platform configuration.
5. Run flutter pub get.
6. Run code generation.
7. Run stac build.
8. Print the commands needed to launch it.
Mason is still the better first implementation because templating, prompts, hooks, and file generation already exist.
Recommendation
Use a Mason brick that creates the complete project in a new directory, rather than overlaying this template onto an existing Flutter skeleton. Overlaying can cause conflicts in pubspec.yaml, platform projects, package imports, SDK versions, and generated files.
The ideal workflow becomes:
mason make smoketrees_app --project_name stac_cart_demo --organization com.smoketrees
Set-Location "stac_cart_demo"
stac watch
This directly solves both problems: no repository cloning and no manual application-ID/package-name replacement.