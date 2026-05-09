import 'package:starshipit/src/models/api_error.dart';
import 'package:starshipit/src/models/order_details.dart';

/// Standard wrapper for single-order API responses (`success`, `errors`, `order`).
class OrderEnvelope {
  const OrderEnvelope({this.success, this.errors, this.order});

  final bool? success;
  final List<ApiError>? errors;
  final OrderDetails? order;

  factory OrderEnvelope.fromJson(Map<String, dynamic> json) {
    return OrderEnvelope(
      success: _coerceBool(json['success']),
      errors: _coerceErrors(json['errors']),
      order: json['order'] is Map<String, dynamic>
          ? OrderDetails.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'errors': errors?.map((e) => e.toJson()).toList(),
    'order': order?.toJson(),
  };
}

bool? _coerceBool(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final v = value.toLowerCase();
    if (v == 'true' || v == '1') {
      return true;
    }
    if (v == 'false' || v == '0') {
      return false;
    }
  }
  return null;
}

List<ApiError>? _coerceErrors(Object? value) {
  if (value is! List) {
    return null;
  }
  return value
      .whereType<Map<String, dynamic>>()
      .map(ApiError.fromJson)
      .toList();
}
