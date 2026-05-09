import 'package:json_annotation/json_annotation.dart';
import 'package:starshipit/src/models/tracking_event.dart';

part 'tracking_details.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TrackingDetails {
  const TrackingDetails({
    this.orderNumber,
    this.orderStatus,
    this.carrierName,
    this.carrierService,
    this.trackingNumber,
    this.shipmentDate,
    this.trackingStatus,
    this.carrierServiceCode,
    this.lastUpdatedDate,
    this.trackingEvents,
  });

  @JsonKey(name: 'order_number')
  final String? orderNumber;

  @JsonKey(name: 'order_status')
  final String? orderStatus;

  @JsonKey(name: 'carrier_name')
  final String? carrierName;

  @JsonKey(name: 'carrier_service')
  final String? carrierService;

  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;

  @JsonKey(name: 'shipment_date')
  final String? shipmentDate;

  @JsonKey(name: 'tracking_status')
  final String? trackingStatus;

  @JsonKey(name: 'carrier_service_code')
  final String? carrierServiceCode;

  @JsonKey(name: 'last_updated_date')
  final String? lastUpdatedDate;

  @JsonKey(name: 'tracking_events')
  final List<TrackingEvent>? trackingEvents;

  factory TrackingDetails.fromJson(Map<String, dynamic> json) =>
      _$TrackingDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDetailsToJson(this);
}
