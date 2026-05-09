import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:starshipit/src/config.dart';
import 'package:starshipit/src/exceptions/starshipit_exception.dart';
import 'package:starshipit/src/http/query_encoding.dart';
import 'package:starshipit/src/models/api_error.dart';
import 'package:starshipit/src/models/error_response.dart';

typedef JsonMap = Map<String, dynamic>;

/// Internal HTTP layer: injects auth headers and maps failures to [StarshipitException].
class AuthHttpClient {
  AuthHttpClient(this.config, {http.Client? inner})
    : _inner = inner ?? http.Client();

  final StarshipitConfig config;
  final http.Client _inner;

  Uri resolve(String path, [Map<String, Object?>? query]) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    final base = config.baseUri;
    var target = base.resolve(normalized);
    if (query != null && query.isNotEmpty) {
      final q = encodeQueryParameters(query);
      target = target.replace(query: q);
    }
    return target;
  }

  Map<String, String> get _headers => {
    'StarShipIT-Api-Key': config.apiKey,
    'Ocp-Apim-Subscription-Key': config.subscriptionKey,
    'User-Agent': config.userAgent,
  };

  Future<http.Response> get(
    String path, {
    Map<String, Object?>? query,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = resolve(path, query);
    final response = await _inner.get(
      uri,
      headers: {..._headers, ...?extraHeaders},
    );
    _throwIfFailed(response, uri);
    return response;
  }

  Future<http.Response> post(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = resolve(path, query);
    final headers = {
      ..._headers,
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };
    final response = await _inner.post(
      uri,
      headers: headers,
      body: jsonBody == null ? null : jsonEncode(jsonBody),
    );
    _throwIfFailed(response, uri);
    return response;
  }

  Future<http.Response> put(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = resolve(path, query);
    final headers = {
      ..._headers,
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };
    final response = await _inner.put(
      uri,
      headers: headers,
      body: jsonBody == null ? null : jsonEncode(jsonBody),
    );
    _throwIfFailed(response, uri);
    return response;
  }

  Future<http.Response> delete(
    String path, {
    Map<String, Object?>? query,
    Object? jsonBody,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = resolve(path, query);
    final headers = {
      ..._headers,
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };
    final response = await _inner.delete(
      uri,
      headers: headers,
      body: jsonBody == null ? null : jsonEncode(jsonBody),
    );
    _throwIfFailed(response, uri);
    return response;
  }

  void close() {
    _inner.close();
  }

  void _throwIfFailed(http.Response response, Uri uri) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      return;
    }
    final text = response.body;
    List<ApiError>? parsed;
    try {
      final decoded = jsonDecode(text);
      if (decoded is JsonMap) {
        if (decoded.containsKey('errors')) {
          final errs = decoded['errors'];
          if (errs is List) {
            parsed = errs.whereType<JsonMap>().map(ApiError.fromJson).toList();
          }
        }
        final er = ErrorResponse.fromJson(decoded);
        if (parsed == null && er.message != null) {
          parsed = [
            ApiError(message: er.message, details: er.statusCode?.toString()),
          ];
        }
      }
    } catch (_) {
      // ignore parse errors
    }
    throw StarshipitException(
      statusCode: code,
      uri: uri,
      body: text.isEmpty ? null : text,
      parsedErrors: parsed,
    );
  }
}
