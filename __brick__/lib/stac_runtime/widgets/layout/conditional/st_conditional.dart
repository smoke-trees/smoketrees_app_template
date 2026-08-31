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

  static T? resolve<T>(dynamic when, {T? whenTrue, T? whenFalse, T? fallback}) {
    final picked = isTruthy(when) ? whenTrue : whenFalse;
    return picked ?? fallback;
  }
}
