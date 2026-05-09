import 'package:http/http.dart' as http;
import 'package:starshipit/src/api/labels_api.dart';
import 'package:starshipit/src/api/orders_api.dart';
import 'package:starshipit/src/api/rates_api.dart';
import 'package:starshipit/src/api/shipped_api.dart';
import 'package:starshipit/src/api/tracking_api.dart';
import 'package:starshipit/src/api/validate_api.dart';
import 'package:starshipit/src/config.dart';
import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/raw/starshipit_raw_client.dart';

/// Facade for the Starshipit HTTP API.
class StarshipitClient {
  StarshipitClient(this.config, {http.Client? httpClient})
    : _http = AuthHttpClient(config, inner: httpClient) {
    orders = OrdersApi(_http);
    rates = RatesApi(_http);
    shipped = ShippedApi(_http);
    labels = LabelsApi(_http);
    tracking = TrackingApi(_http);
    validate = ValidateApi(_http);
    raw = StarshipitRawClient(_http);
  }

  final StarshipitConfig config;
  final AuthHttpClient _http;

  late final OrdersApi orders;
  late final RatesApi rates;
  late final ShippedApi shipped;
  late final LabelsApi labels;
  late final TrackingApi tracking;
  late final ValidateApi validate;
  late final StarshipitRawClient raw;

  void close() => _http.close();
}
