// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShipmentRequest _$CreateShipmentRequestFromJson(
  Map<String, dynamic> json,
) => CreateShipmentRequest(
  orderId: (json['order_id'] as num?)?.toInt(),
  orderNumber: json['order_number'] as String?,
  carrier: json['carrier'] as String?,
  carrierServiceCode: json['carrier_service_code'] as String?,
  packages: (json['packages'] as List<dynamic>?)
      ?.map((e) => StarshipitPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
  reprint: json['reprint'] as bool?,
);

Map<String, dynamic> _$CreateShipmentRequestToJson(
  CreateShipmentRequest instance,
) => <String, dynamic>{
  'order_id': ?instance.orderId,
  'order_number': ?instance.orderNumber,
  'carrier': ?instance.carrier,
  'carrier_service_code': ?instance.carrierServiceCode,
  'packages': ?instance.packages?.map((e) => e.toJson()).toList(),
  'reprint': ?instance.reprint,
};
