String safeString(String? Function() getter, {required String fallback}) {
  try {
    final value = getter();

    if (value == null) return fallback;

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  } catch (_) {
    return fallback;
  }
}