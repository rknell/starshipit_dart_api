int? nullableIntFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

Object? nullableIntToJson(int? value) => value;

double? nullableDoubleFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? signatureRequiredFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value ? 1 : 0;
  }
  return nullableIntFromJson(value);
}

/// List payloads use `carrier_id`; create/update responses use `carrier`.
Object? readCarrierOrCarrierId(Map<dynamic, dynamic> json, String key) =>
    json['carrier'] ?? json['carrier_id'];
