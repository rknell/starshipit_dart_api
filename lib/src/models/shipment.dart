import 'package:json_annotation/json_annotation.dart';
import 'package:starshipit/src/models/starshipit_package.dart';

part 'shipment.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CreateShipmentRequest {
  const CreateShipmentRequest({
    this.orderId,
    this.orderNumber,
    this.carrier,
    this.carrierServiceCode,
    this.packages,
    this.reprint,
  });

  @JsonKey(name: 'order_id')
  final int? orderId;

  @JsonKey(name: 'order_number')
  final String? orderNumber;

  /// Carrier identifier (tenant-specific string or code from docs / Postman).
  final String? carrier;

  @JsonKey(name: 'carrier_service_code')
  final String? carrierServiceCode;

  final List<StarshipitPackage>? packages;

  /// When true, asks the API for another label copy (re-print / redownload).
  final bool? reprint;

  factory CreateShipmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateShipmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShipmentRequestToJson(this);
}

/// Label / shipment generation response — schemas differ; modeled fields are optional.
class ShipmentResponse {
  const ShipmentResponse({
    this.success,
    this.orderId,
    this.trackingNumber,
    this.trackingNumbers,
    this.labelData,
    this.labels,
    this.labelTypes,
    this.labelFormat,
    this.messages,
  });

  final bool? success;
  final int? orderId;
  final String? trackingNumber;

  /// When the API returns `tracking_numbers` (list); [trackingNumber] mirrors the first entry when present.
  final List<String>? trackingNumbers;

  /// Single inline base64 payload (legacy/alternate shape).
  final String? labelData;

  /// One or more base64 PDF payloads (common on `POST /orders/shipment`).
  final List<String>? labels;

  /// Parallel to [labels] when the API returns `label_types`.
  final List<String>? labelTypes;

  final String? labelFormat;
  final List<String>? messages;

  factory ShipmentResponse.fromJson(Map<String, dynamic> json) {
    List<String>? msgs;
    final m = json['messages'] ?? json['Errors'];
    if (m is List) {
      msgs = m.map((e) => e.toString()).toList();
    }

    List<String>? labelList;
    final rawLabels = json['labels'] ?? json['Labels'];
    if (rawLabels is List) {
      labelList = rawLabels
          .map((e) => e?.toString())
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
    }

    List<String>? labelTypesList;
    final rawTypes = json['label_types'] ?? json['LabelTypes'];
    if (rawTypes is List) {
      labelTypesList = rawTypes
          .map((e) => e?.toString())
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
    }

    List<String>? tnList;
    final rawTn = json['tracking_numbers'] ?? json['TrackingNumbers'];
    if (rawTn is List) {
      tnList = rawTn
          .map((e) => e?.toString())
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
    }

    final inline =
        json['label_data'] as String? ?? json['LabelData'] as String?;
    final singleTn =
        json['tracking_number'] as String? ?? json['TrackingNumber'] as String?;

    return ShipmentResponse(
      success: json['success'] as bool? ?? json['Success'] as bool?,
      orderId: _int(json['order_id'] ?? json['OrderId']),
      trackingNumber:
          singleTn ??
          (tnList != null && tnList.isNotEmpty ? tnList.first : null),
      trackingNumbers: tnList,
      labelData:
          inline ??
          (labelList != null && labelList.isNotEmpty ? labelList.first : null),
      labels: labelList,
      labelTypes: labelTypesList,
      labelFormat:
          json['label_format'] as String? ?? json['LabelFormat'] as String?,
      messages: msgs,
    );
  }
}

int? _int(Object? v) {
  if (v == null) {
    return null;
  }
  if (v is int) {
    return v;
  }
  if (v is num) {
    return v.toInt();
  }
  return int.tryParse(v.toString());
}
