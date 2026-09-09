/// Deep-copies a JSON tree replacing `{{key}}` placeholders with values
/// from [data]. Scalar values are coerced to [String] so they can be safely
/// injected into string fields (e.g. `StacText.data`).
dynamic injectData(dynamic node, Map<String, dynamic> data) {
  if (node is String) {
    final match = RegExp(r'^\{\{(\w+)\}\}$').firstMatch(node);
    if (match != null) {
      final value = data[match.group(1)];
      return value == null ? node : value.toString();
    }
    return node.replaceAllMapped(
      RegExp(r'\{\{(\w+)\}\}'),
      (m) => data[m.group(1)]?.toString() ?? m.group(0)!,
    );
  }
  if (node is Map<String, dynamic>) {
    return node.map((k, v) => MapEntry(k, injectData(v, data)));
  }
  if (node is List) {
    return node.map((e) => injectData(e, data)).toList();
  }
  return node;
}
