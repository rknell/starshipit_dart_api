// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
  orderId: nullableIntFromJson(json['order_id']),
  orderDate: json['order_date'] as String?,
  orderNumber: json['order_number'] as String?,
  reference: json['reference'] as String?,
  carrier: nullableIntFromJson(readCarrierOrCarrierId(json, 'carrier')),
  carrierName: json['carrier_name'] as String?,
  carrierServiceCode: nullableIntFromJson(json['carrier_service_code']),
  shippingMethod: json['shipping_method'] as String?,
  signatureRequired: signatureRequiredFromJson(json['signature_required']),
  currency: json['currency'] as String?,
  senderDetails: json['sender_details'] == null
      ? null
      : Contact.fromJson(json['sender_details'] as Map<String, dynamic>),
  destination: json['destination'] == null
      ? null
      : Address.fromJson(json['destination'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  packages: (json['packages'] as List<dynamic>?)
      ?.map((e) => StarshipitPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
  metadatas: (json['metadatas'] as List<dynamic>?)
      ?.map((e) => Metadata.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'order_id': ?nullableIntToJson(instance.orderId),
      'order_date': ?instance.orderDate,
      'order_number': ?instance.orderNumber,
      'reference': ?instance.reference,
      'carrier': ?nullableIntToJson(instance.carrier),
      'carrier_name': ?instance.carrierName,
      'carrier_service_code': ?nullableIntToJson(instance.carrierServiceCode),
      'shipping_method': ?instance.shippingMethod,
      'signature_required': ?nullableIntToJson(instance.signatureRequired),
      'currency': ?instance.currency,
      'sender_details': ?instance.senderDetails?.toJson(),
      'destination': ?instance.destination?.toJson(),
      'items': ?instance.items?.map((e) => e.toJson()).toList(),
      'packages': ?instance.packages?.map((e) => e.toJson()).toList(),
      'metadatas': ?instance.metadatas?.map((e) => e.toJson()).toList(),
    };
