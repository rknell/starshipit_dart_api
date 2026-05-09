import 'package:starshipit/src/http/auth_http_client.dart';

class ValidateApi {
  ValidateApi(this._http);

  final AuthHttpClient _http;

  /// Lightweight connectivity check (valid credentials).
  ///
  /// Uses [GET /health], which is **not** part of the published Starshipit OpenAPI/Postman
  /// surface — treat it only as a helper to verify reachability and keys. The legacy
  /// `/validate` path returns 404 on current API hosts.
  Future<void> validate() async {
    await _http.get('health');
  }
}
