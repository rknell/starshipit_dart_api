import 'package:json_annotation/json_annotation.dart';

part 'starshipit_package.g.dart';

@JsonSerializable(includeIfNull: false)
class StarshipitPackage {
  const StarshipitPackage({
    this.packageId,
    this.name,
    this.weight,
    this.height,
    this.width,
    this.length,
    this.packagingType,
    this.carrierServiceCode,
    this.trackingNumber,
    this.trackingUrl,
    this.shipmentType,
  });

  @JsonKey(name: 'package_id')
  final int? packageId;

  final String? name;
  final double? weight;
  final double? height;
  final double? width;
  final double? length;

  @JsonKey(name: 'packaging_type')
  final String? packagingType;

  @JsonKey(name: 'carrier_service_code')
  final String? carrierServiceCode;

  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;

  @JsonKey(name: 'tracking_url')
  final String? trackingUrl;

  @JsonKey(name: 'shipment_type')
  final String? shipmentType;

  factory StarshipitPackage.fromJson(Map<String, dynamic> json) =>
      _$StarshipitPackageFromJson(json);

  Map<String, dynamic> toJson() => _$StarshipitPackageToJson(this);
}
