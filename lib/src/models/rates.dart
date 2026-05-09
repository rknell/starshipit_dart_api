import 'package:json_annotation/json_annotation.dart';

part 'rates.g.dart';

/// Destination / sender fragment for [POST /rates] (uses `country_code` per Starshipit examples).
@JsonSerializable(includeIfNull: false)
class RatesLocation {
  const RatesLocation({
    this.street,
    this.suburb,
    this.city,
    this.state,
    this.postCode,
    this.countryCode,
  });

  final String? street;
  final String? suburb;
  final String? city;
  final String? state;

  @JsonKey(name: 'post_code')
  final String? postCode;

  @JsonKey(name: 'country_code')
  final String? countryCode;

  factory RatesLocation.fromJson(Map<String, dynamic> json) =>
      _$RatesLocationFromJson(json);

  Map<String, dynamic> toJson() => _$RatesLocationToJson(this);
}

@JsonSerializable(includeIfNull: false)
class RatesPackage {
  const RatesPackage({
    this.weight,
    this.height,
    this.width,
    this.length,
    this.packageName,
  });

  final double? weight;
  final double? height;
  final double? width;
  final double? length;

  /// Used by [POST /deliveryservices] (`package_name` in the API).
  @JsonKey(name: 'package_name')
  final String? packageName;

  factory RatesPackage.fromJson(Map<String, dynamic> json) =>
      _$RatesPackageFromJson(json);

  Map<String, dynamic> toJson() => _$RatesPackageToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RatesRequest {
  const RatesRequest({
    required this.destination,
    required this.packages,
    this.sender,
    this.currency,

    /// Optional; some tenants accept this on [POST /rates]. The published docs emphasise
    /// [DeliveryServicesRequest.includePricing] for [POST /deliveryservices].
    this.includePricing,
  });

  final RatesLocation destination;
  final List<RatesPackage> packages;
  final RatesLocation? sender;

  /// ISO currency code when required by your tenant (e.g. `AUD`).
  final String? currency;

  @JsonKey(name: 'include_pricing')
  final bool? includePricing;

  factory RatesRequest.fromJson(Map<String, dynamic> json) =>
      _$RatesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RatesRequestToJson(this);
}

/// Request body for [POST /deliveryservices] — order-scoped or address-based service listing.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DeliveryServicesRequest {
  const DeliveryServicesRequest({
    required this.packages,
    this.orderId,
    this.refreshRate,
    this.sender,
    this.destination,
    this.declaredValue,
    this.returnOrder,
    this.includePricing,
    this.signatureRequired,
    this.authorityToLeave,
    this.dangerousGoods,
    this.insuranceValue,
  });

  @JsonKey(name: 'order_id')
  final int? orderId;

  @JsonKey(name: 'refresh_rate')
  final bool? refreshRate;

  final RatesLocation? sender;
  final RatesLocation? destination;

  final List<RatesPackage> packages;

  @JsonKey(name: 'declared_value')
  final double? declaredValue;

  @JsonKey(name: 'return_order')
  final bool? returnOrder;

  @JsonKey(name: 'include_pricing')
  final bool? includePricing;

  @JsonKey(name: 'signature_required')
  final bool? signatureRequired;

  @JsonKey(name: 'authority_to_leave')
  final bool? authorityToLeave;

  @JsonKey(name: 'dangerous_goods')
  final bool? dangerousGoods;

  @JsonKey(name: 'insurance_value')
  final double? insuranceValue;

  factory DeliveryServicesRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliveryServicesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryServicesRequestToJson(this);
}

/// One quoted service line; field names differ by carrier — all optional.
class RatesQuote {
  const RatesQuote({
    this.carrier,
    this.carrierName,
    this.serviceCode,
    this.serviceName,
    this.totalPrice,
    this.currency,
    this.raw = const {},
  });

  final String? carrier;

  @JsonKey(name: 'carrier_name')
  final String? carrierName;

  @JsonKey(name: 'service_code')
  final String? serviceCode;

  @JsonKey(name: 'service_name')
  final String? serviceName;

  @JsonKey(name: 'total_price')
  final Object? totalPrice;

  final String? currency;

  /// Unmodeled fields from the API (never null — empty when nothing extra).
  final Map<String, Object?> raw;

  factory RatesQuote.fromJson(Map<String, dynamic> json) {
    final known = {
      'carrier',
      'carrier_name',
      'service_code',
      'service_name',
      'total_price',
      'currency',
    };
    final extra = <String, Object?>{};
    for (final e in json.entries) {
      if (!known.contains(e.key)) {
        extra[e.key] = e.value;
      }
    }
    return RatesQuote(
      carrier: json['carrier']?.toString(),
      carrierName: json['carrier_name']?.toString(),
      serviceCode: json['service_code']?.toString(),
      serviceName: json['service_name'] as String?,
      totalPrice: json['total_price'],
      currency: json['currency'] as String?,
      raw: extra,
    );
  }

  Map<String, dynamic> toJson() => {
    if (carrier != null) 'carrier': carrier,
    if (carrierName != null) 'carrier_name': carrierName,
    if (serviceCode != null) 'service_code': serviceCode,
    if (serviceName != null) 'service_name': serviceName,
    if (totalPrice != null) 'total_price': totalPrice,
    if (currency != null) 'currency': currency,
    ...raw,
  };
}

/// Parsed response from [POST /rates], [POST /deliveryservices], and similarly shaped payloads.
///
/// Starshipit responses vary; this unwraps common envelopes and array property names.
class RatesResponse {
  const RatesResponse({
    this.quotes = const [],
    this.rawKeys,
    this.defaultService,
  });

  final List<RatesQuote> quotes;

  /// Which key yielded the quote list (for debugging).
  final String? rawKeys;

  /// Populated for [POST /deliveryservices] when the API returns `default_service`.
  final RatesQuote? defaultService;

  factory RatesResponse.fromJson(Map<String, dynamic> json) {
    final parsed = _parseRatesResponse(json, depth: 0);
    RatesQuote? def;
    final ds = json['default_service'] ?? json['DefaultService'];
    if (ds is Map<String, dynamic>) {
      def = RatesQuote.fromJson(ds);
    }
    return RatesResponse(
      quotes: parsed.quotes,
      rawKeys: parsed.rawKeys,
      defaultService: def,
    );
  }

  static RatesResponse _parseRatesResponse(
    Map<String, dynamic> json, {
    required int depth,
  }) {
    const maxDepth = 4;
    if (depth > maxDepth) {
      return const RatesResponse(quotes: []);
    }

    const candidates = [
      'services',
      'rates',
      'quotes',
      'Results',
      'results',
      'delivery_services',
      'DeliveryServices',
      'Services',
      'Items',
      'items',
    ];

    for (final key in candidates) {
      final v = json[key];
      if (v is List) {
        final maps = v
            .whereType<Map<String, dynamic>>()
            .map(RatesQuote.fromJson)
            .toList();
        if (maps.isNotEmpty) {
          return RatesResponse(quotes: maps, rawKeys: key);
        }
      }
    }

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final inner = _parseRatesResponse(data, depth: depth + 1);
      if (inner.quotes.isNotEmpty) {
        return RatesResponse(
          quotes: inner.quotes,
          rawKeys: inner.rawKeys ?? 'data',
        );
      }
    }

    final result = json['result'];
    if (result is Map<String, dynamic>) {
      final inner = _parseRatesResponse(result, depth: depth + 1);
      if (inner.quotes.isNotEmpty) {
        return RatesResponse(
          quotes: inner.quotes,
          rawKeys: inner.rawKeys ?? 'result',
        );
      }
    }

    return const RatesResponse(quotes: []);
  }
}
