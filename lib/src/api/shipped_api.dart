import 'dart:convert';

import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/models/shipped.dart';

class ShippedApi {
  ShippedApi(this._http);

  final AuthHttpClient _http;

  /// [POST /orders/shipped] — create tracking-only (externally manifested) orders.
  Future<ShippedResponse> createTrackingOrders(
    ShippedBatchRequest request,
  ) async {
    final res = await _http.post('orders/shipped', jsonBody: request.toJson());
    return ShippedResponse.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }
}
