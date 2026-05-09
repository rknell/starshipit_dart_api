// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipped.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippedOrderEntry _$ShippedOrderEntryFromJson(Map<String, dynamic> json) =>
    ShippedOrderEntry(
      carrier: json['carrier'] as String,
      trackingNumber: json['tracking_number'] as String,
      orderNumber: json['order_number'] as String?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      postcode: json['postcode'] as String?,
      carrierServiceCode: json['carrier_service_code'] as String?,
    );

Map<String, dynamic> _$ShippedOrderEntryToJson(ShippedOrderEntry instance) =>
    <String, dynamic>{
      'carrier': instance.carrier,
      'tracking_number': instance.trackingNumber,
      'order_number': ?instance.orderNumber,
      'name': ?instance.name,
      'country': ?instance.country,
      'postcode': ?instance.postcode,
      'carrier_service_code': ?instance.carrierServiceCode,
    };

ShippedBatchRequest _$ShippedBatchRequestFromJson(Map<String, dynamic> json) =>
    ShippedBatchRequest(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => ShippedOrderEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShippedBatchRequestToJson(
  ShippedBatchRequest instance,
) => <String, dynamic>{
  'orders': instance.orders.map((e) => e.toJson()).toList(),
};
