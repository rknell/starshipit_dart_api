import 'dart:convert';

import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/models/order_envelope.dart';
import 'package:starshipit/src/models/shipment.dart';

class LabelsApi {
  LabelsApi(this._http);

  final AuthHttpClient _http;

  /// [POST /orders/shipment] — book / generate shipment & label data for an order.
  ///
  /// Some tenants return an [OrderEnvelope]; others return [ShipmentResponse] fields.
  /// This method tries [ShipmentResponse] first, then falls back to [OrderEnvelope].
  Future<ShipmentOrOrder> createShipment(CreateShipmentRequest request) async {
    final res = await _http.post('orders/shipment', jsonBody: request.toJson());
    return _parseShipmentResponse(res.body);
  }

  /// Second label fetch for an order that has already been printed / manifested.
  ///
  /// Sends `{ "order_id", "reprint": true }`. If your tenant ignores `reprint`,
  /// a plain second [createShipment] call may still return label data.
  Future<ShipmentOrOrder> redownloadLabel(int orderId) =>
      createShipment(CreateShipmentRequest(orderId: orderId, reprint: true));

  ShipmentOrOrder _parseShipmentResponse(String body) {
    final map = jsonDecode(body);
    if (map is! Map<String, dynamic>) {
      return ShipmentOrOrder.raw(body);
    }

    final labels = map['labels'] ?? map['Labels'];
    final trackingNums = map['tracking_numbers'] ?? map['TrackingNumbers'];
    final looksLikeShipmentPayload =
        map.containsKey('label_data') ||
        map.containsKey('LabelData') ||
        (labels is List && labels.isNotEmpty) ||
        (trackingNums is List && trackingNums.isNotEmpty) ||
        map.containsKey('label_types') ||
        map.containsKey('LabelTypes') ||
        (map.containsKey('tracking_number') && map.containsKey('success')) ||
        (map.containsKey('success') == true &&
            map.containsKey('order_id') &&
            !map.containsKey('order'));

    if (looksLikeShipmentPayload) {
      return ShipmentOrOrder.shipment(ShipmentResponse.fromJson(map));
    }
    return ShipmentOrOrder.order(OrderEnvelope.fromJson(map));
  }
}

/// Union of common shipment responses.
sealed class ShipmentOrOrder {
  const ShipmentOrOrder();

  factory ShipmentOrOrder.shipment(ShipmentResponse value) = _ShipmentBranch;
  factory ShipmentOrOrder.order(OrderEnvelope value) = _OrderBranch;
  factory ShipmentOrOrder.raw(String body) = _RawBranch;

  ShipmentResponse? get asShipment => switch (this) {
    _ShipmentBranch(:final value) => value,
    _ => null,
  };

  OrderEnvelope? get asOrder => switch (this) {
    _OrderBranch(:final value) => value,
    _ => null,
  };

  String? get asRawBody => switch (this) {
    _RawBranch(:final body) => body,
    _ => null,
  };
}

final class _ShipmentBranch extends ShipmentOrOrder {
  const _ShipmentBranch(this.value);
  final ShipmentResponse value;
}

final class _OrderBranch extends ShipmentOrOrder {
  const _OrderBranch(this.value);
  final OrderEnvelope value;
}

final class _RawBranch extends ShipmentOrOrder {
  const _RawBranch(this.body);
  final String body;
}
