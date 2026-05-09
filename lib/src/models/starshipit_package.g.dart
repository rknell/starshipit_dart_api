// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starshipit_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarshipitPackage _$StarshipitPackageFromJson(Map<String, dynamic> json) =>
    StarshipitPackage(
      packageId: (json['package_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      packagingType: json['packaging_type'] as String?,
      carrierServiceCode: json['carrier_service_code'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      trackingUrl: json['tracking_url'] as String?,
      shipmentType: json['shipment_type'] as String?,
    );

Map<String, dynamic> _$StarshipitPackageToJson(StarshipitPackage instance) =>
    <String, dynamic>{
      'package_id': ?instance.packageId,
      'name': ?instance.name,
      'weight': ?instance.weight,
      'height': ?instance.height,
      'width': ?instance.width,
      'length': ?instance.length,
      'packaging_type': ?instance.packagingType,
      'carrier_service_code': ?instance.carrierServiceCode,
      'tracking_number': ?instance.trackingNumber,
      'tracking_url': ?instance.trackingUrl,
      'shipment_type': ?instance.shipmentType,
    };
