// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatesLocation _$RatesLocationFromJson(Map<String, dynamic> json) =>
    RatesLocation(
      street: json['street'] as String?,
      suburb: json['suburb'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postCode: json['post_code'] as String?,
      countryCode: json['country_code'] as String?,
    );

Map<String, dynamic> _$RatesLocationToJson(RatesLocation instance) =>
    <String, dynamic>{
      'street': ?instance.street,
      'suburb': ?instance.suburb,
      'city': ?instance.city,
      'state': ?instance.state,
      'post_code': ?instance.postCode,
      'country_code': ?instance.countryCode,
    };

RatesPackage _$RatesPackageFromJson(Map<String, dynamic> json) => RatesPackage(
  weight: (json['weight'] as num?)?.toDouble(),
  height: (json['height'] as num?)?.toDouble(),
  width: (json['width'] as num?)?.toDouble(),
  length: (json['length'] as num?)?.toDouble(),
  packageName: json['package_name'] as String?,
);

Map<String, dynamic> _$RatesPackageToJson(RatesPackage instance) =>
    <String, dynamic>{
      'weight': ?instance.weight,
      'height': ?instance.height,
      'width': ?instance.width,
      'length': ?instance.length,
      'package_name': ?instance.packageName,
    };

RatesRequest _$RatesRequestFromJson(Map<String, dynamic> json) => RatesRequest(
  destination: RatesLocation.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
  packages: (json['packages'] as List<dynamic>)
      .map((e) => RatesPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
  sender: json['sender'] == null
      ? null
      : RatesLocation.fromJson(json['sender'] as Map<String, dynamic>),
  currency: json['currency'] as String?,
  includePricing: json['include_pricing'] as bool?,
);

Map<String, dynamic> _$RatesRequestToJson(RatesRequest instance) =>
    <String, dynamic>{
      'destination': instance.destination.toJson(),
      'packages': instance.packages.map((e) => e.toJson()).toList(),
      'sender': ?instance.sender?.toJson(),
      'currency': ?instance.currency,
      'include_pricing': ?instance.includePricing,
    };

DeliveryServicesRequest _$DeliveryServicesRequestFromJson(
  Map<String, dynamic> json,
) => DeliveryServicesRequest(
  packages: (json['packages'] as List<dynamic>)
      .map((e) => RatesPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
  orderId: (json['order_id'] as num?)?.toInt(),
  refreshRate: json['refresh_rate'] as bool?,
  sender: json['sender'] == null
      ? null
      : RatesLocation.fromJson(json['sender'] as Map<String, dynamic>),
  destination: json['destination'] == null
      ? null
      : RatesLocation.fromJson(json['destination'] as Map<String, dynamic>),
  declaredValue: (json['declared_value'] as num?)?.toDouble(),
  returnOrder: json['return_order'] as bool?,
  includePricing: json['include_pricing'] as bool?,
  signatureRequired: json['signature_required'] as bool?,
  authorityToLeave: json['authority_to_leave'] as bool?,
  dangerousGoods: json['dangerous_goods'] as bool?,
  insuranceValue: (json['insurance_value'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DeliveryServicesRequestToJson(
  DeliveryServicesRequest instance,
) => <String, dynamic>{
  'order_id': ?instance.orderId,
  'refresh_rate': ?instance.refreshRate,
  'sender': ?instance.sender?.toJson(),
  'destination': ?instance.destination?.toJson(),
  'packages': instance.packages.map((e) => e.toJson()).toList(),
  'declared_value': ?instance.declaredValue,
  'return_order': ?instance.returnOrder,
  'include_pricing': ?instance.includePricing,
  'signature_required': ?instance.signatureRequired,
  'authority_to_leave': ?instance.authorityToLeave,
  'dangerous_goods': ?instance.dangerousGoods,
  'insurance_value': ?instance.insuranceValue,
};
