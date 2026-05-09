import 'dart:convert';

import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/models/rates.dart';

class RatesApi {
  RatesApi(this._http);

  final AuthHttpClient _http;

  /// Shipping quotes: [POST /rates] with destination, packages, optional sender and [RatesRequest.currency].
  ///
  /// [RatesRequest.includePricing] is optional; Starshipit’s published **Delivery Services** request
  /// documents `include_pricing` on [deliveryServices] ([POST /deliveryservices]).
  Future<RatesResponse> quote(RatesRequest request) async {
    final res = await _http.post('rates', jsonBody: request.toJson());
    return RatesResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Available carrier services (checkout or order-scoped): [POST /deliveryservices].
  ///
  /// Supply [DeliveryServicesRequest.orderId] to refresh rates for an existing order, or use
  /// sender/destination + [DeliveryServicesRequest.packages] for quote-style listing.
  Future<RatesResponse> deliveryServices(
    DeliveryServicesRequest request,
  ) async {
    final res = await _http.post(
      'deliveryservices',
      jsonBody: request.toJson(),
    );
    return RatesResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Alias for [quote] — same [POST /rates] endpoint.
  Future<RatesResponse> shippingQuote(RatesRequest request) => quote(request);
}
