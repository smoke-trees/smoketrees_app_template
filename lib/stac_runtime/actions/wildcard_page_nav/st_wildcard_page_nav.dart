import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_wildcard_page_nav.g.dart';

/// Navigation types supported by [StWildcardPageNavAction].
///
/// Mirrors the separate navigation operations exposed by [StacNavigator]
/// ([NavigationStyle]) so that a caller can pick which kind of navigation to
/// perform without hard-coding it in every screen.
enum WildcardPageNavType {
  push,
  pushReplacement,
  pushAndRemoveAll,
  pushNamed,
  pushNamedAndRemoveAll,
  pushReplacementNamed,
  pop,
  popAll,
}

/// A custom [StacAction] that always sends a `wildcardPage` argument,
/// regardless of the [WildcardPageNavType] used.
///
/// The [wildcardPage] value is merged into every navigation's `arguments`
/// map before the underlying [StacNavigator] navigation is dispatched, so a
/// destination like [StWildcardPage] (which keys off
/// `arguments['wildcardPage']`) always knows which child to render.
///
/// ```json
/// {
///   "actionType": "wildcard_page_nav",
///   "navigationType": "push",
///   "routeName": "wildcard_page",
///   "wildcardPage": "page2",
///   "arguments": { "anyKey": "anyValue" }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StWildcardPageNavAction extends StacAction {
  const StWildcardPageNavAction({
    this.navigationType = WildcardPageNavType.push,
    required this.wildcardPage,
    this.arguments,
    this.result,
  });

  /// Which [StacNavigator] navigation to perform.
  final WildcardPageNavType navigationType;

  /// The page (child key) of the destination `StPageSwitcher` to render.
  /// Always injected into the route `arguments` as `wildcardPage`.
  final String wildcardPage;

  /// Extra arguments to pass along in addition to `wildcardPage`.
  final Map<String, dynamic>? arguments;

  /// Optional result payload for replacement / pop styles.
  final Map<String, dynamic>? result;

  @override
  String get actionType => 'wildcard_page_nav';

  /// The arguments actually shipped with the navigation. `wildcardPage` is
  /// always present, on top of any caller-supplied [arguments].
  Map<String, dynamic> get navigationArguments => {
    ...?arguments,
    'wildcardPage': wildcardPage,
  };

  factory StWildcardPageNavAction.fromJson(Map<String, dynamic> json) =>
      _$StWildcardPageNavActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StWildcardPageNavActionToJson(this);
}
