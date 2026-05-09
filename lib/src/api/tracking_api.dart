import 'dart:convert';

import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/models/track_envelope.dart';

class TrackingApi {
  TrackingApi(this._http);

  final AuthHttpClient _http;

  /// [GET /track] — pass [trackingNumber] and/or [order_number] (at least one required).
  Future<TrackEnvelope> get({
    String? trackingNumber,
    String? orderNumber,
  }) async {
    if (trackingNumber == null && orderNumber == null) {
      throw ArgumentError('Provide trackingNumber and/or orderNumber');
    }
    final q = <String, Object?>{};
    if (trackingNumber != null) {
      q['tracking_number'] = trackingNumber;
    }
    if (orderNumber != null) {
      q['order_number'] = orderNumber;
    }
    final res = await _http.get('track', query: q);
    return TrackEnvelope.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// [GET /track?tracking_number=…]
  Future<TrackEnvelope> getByTrackingNumber(String trackingNumber) =>
      get(trackingNumber: trackingNumber);

  /// [GET /track?order_number=…]
  Future<TrackEnvelope> getByOrderNumber(String orderNumber) =>
      get(orderNumber: orderNumber);
}
