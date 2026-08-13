// st_conditional.dart
/// Generic true/false picker used inside any parser's `parse()` once both
/// branches have already been deserialized to their real Dart type â€”
/// StacWidget, StacBoxDecoration, StacColor, StacTextStyle, String, whatever.
///
/// This is intentionally NOT a registered Stac parser/widget type on its
/// own â€” it's a helper other parsers call directly, so no new "conditional_X"
/// widget type needs to exist per property kind.
class StConditional {
  const StConditional._();

  static bool isTruthy(dynamic when) {
    if (when is bool) return when;
    if (when is String) {
      final v = when.trim().toLowerCase();
      return v == 'true' || v == '1' || v == 'yes';
    }
    return false;
  }

  /// Returns [whenTrue] or [whenFalse] based on [when], falling back to
  /// [fallback] if the chosen branch is null.
  static T? resolve<T>(dynamic when, {T? whenTrue, T? whenFalse, T? fallback}) {
    final picked = isTruthy(when) ? whenTrue : whenFalse;
    return picked ?? fallback;
  }
}
