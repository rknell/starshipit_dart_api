/// Builds `application/x-www-form-urlencoded` query strings with repeated keys.
String encodeQueryParameters(Map<String, Object?> params) {
  final parts = <String>[];
  void addPair(String key, String value) {
    parts.add(
      '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value)}',
    );
  }

  for (final e in params.entries) {
    final v = e.value;
    if (v == null) {
      continue;
    }
    if (v is String) {
      addPair(e.key, v);
    } else if (v is Iterable<String>) {
      for (final s in v) {
        addPair(e.key, s);
      }
    } else {
      addPair(e.key, v.toString());
    }
  }
  return parts.join('&');
}
