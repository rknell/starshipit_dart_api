// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDetails _$TrackingDetailsFromJson(Map<String, dynamic> json) =>
    TrackingDetails(
      orderNumber: json['order_number'] as String?,
      orderStatus: json['order_status'] as String?,
      carrierName: json['carrier_name'] as String?,
      carrierService: json['carrier_service'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      shipmentDate: json['shipment_date'] as String?,
      trackingStatus: json['tracking_status'] as String?,
      carrierServiceCode: json['carrier_service_code'] as String?,
      lastUpdatedDate: json['last_updated_date'] as String?,
      trackingEvents: (json['tracking_events'] as List<dynamic>?)
          ?.map((e) => TrackingEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackingDetailsToJson(
  TrackingDetails instance,
) => <String, dynamic>{
  'order_number': ?instance.orderNumber,
  'order_status': ?instance.orderStatus,
  'carrier_name': ?instance.carrierName,
  'carrier_service': ?instance.carrierService,
  'tracking_number': ?instance.trackingNumber,
  'shipment_date': ?instance.shipmentDate,
  'tracking_status': ?instance.trackingStatus,
  'carrier_service_code': ?instance.carrierServiceCode,
  'last_updated_date': ?instance.lastUpdatedDate,
  'tracking_events': ?instance.trackingEvents?.map((e) => e.toJson()).toList(),
};
