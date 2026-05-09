import 'package:http/http.dart' as http;
import 'package:starshipit/src/http/auth_http_client.dart';

/// Escape hatch for endpoints not yet wrapped in typed APIs.
class StarshipitRawClient {
  StarshipitRawClient(this._http);

  final AuthHttpClient _http;

  Future<http.Response> get(String path, {Map<String, Object?>? query}) =>
      _http.get(path, query: query);

  Future<http.Response> post(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
  }) => _http.post(path, query: query, jsonBody: jsonBody);

  Future<http.Response> put(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
  }) => _http.put(path, query: query, jsonBody: jsonBody);

  Future<http.Response> delete(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
  }) => _http.delete(path, query: query, jsonBody: jsonBody);
}
