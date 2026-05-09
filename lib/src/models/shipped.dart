import 'package:json_annotation/json_annotation.dart';

part 'shipped.g.dart';

@JsonSerializable(includeIfNull: false)
class ShippedOrderEntry {
  const ShippedOrderEntry({
    required this.carrier,
    required this.trackingNumber,
    this.orderNumber,
    this.name,
    this.country,
    this.postcode,
    this.carrierServiceCode,
  });

  /// Carrier name / enum value as returned by the API (e.g. `AusPost`).
  final String carrier;

  @JsonKey(name: 'tracking_number')
  final String trackingNumber;

  @JsonKey(name: 'order_number')
  final String? orderNumber;

  /// Recipient / customer name when creating tracking-only rows (API field `name`).
  final String? name;

  final String? country;

  final String? postcode;

  @JsonKey(name: 'carrier_service_code')
  final String? carrierServiceCode;

  factory ShippedOrderEntry.fromJson(Map<String, dynamic> json) =>
      _$ShippedOrderEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ShippedOrderEntryToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ShippedBatchRequest {
  const ShippedBatchRequest({required this.orders});

  final List<ShippedOrderEntry> orders;

  factory ShippedBatchRequest.fromJson(Map<String, dynamic> json) =>
      _$ShippedBatchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShippedBatchRequestToJson(this);
}

/// Response for [POST /orders/shipped] — includes created order ids mapped to tracking numbers when successful.
class ShippedResponse {
  const ShippedResponse({this.success, this.errors, this.orders});

  final bool? success;
  final List<String>? errors;

  /// Created Starshipit order ids (string keys) → tracking numbers from the request.
  final Map<String, String>? orders;

  factory ShippedResponse.fromJson(Map<String, dynamic> json) {
    final err = json['errors'];
    Map<String, String>? orderMap;
    final rawOrders = json['orders'];
    if (rawOrders is Map) {
      orderMap = rawOrders.map(
        (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
      );
    }
    return ShippedResponse(
      success: json['success'] as bool? ?? (json['Success'] as bool?),
      errors: err is List ? err.map((e) => e.toString()).toList() : null,
      orders: orderMap,
    );
  }
}
