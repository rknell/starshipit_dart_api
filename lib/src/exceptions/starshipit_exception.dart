import 'package:starshipit/src/models/api_error.dart';

/// Thrown when the HTTP status is not successful or the response cannot be parsed.
class StarshipitException implements Exception {
  StarshipitException({
    required this.statusCode,
    required this.uri,
    this.body,
    this.parsedErrors,
  });

  final int statusCode;
  final Uri uri;
  final String? body;
  final List<ApiError>? parsedErrors;

  @override
  String toString() {
    final buf = StringBuffer('StarshipitException($statusCode $uri');
    if (parsedErrors != null && parsedErrors!.isNotEmpty) {
      buf.write(', errors: $parsedErrors');
    } else if (body != null && body!.isNotEmpty) {
      final snippet = body!.length > 200 ? '${body!.substring(0, 200)}…' : body;
      buf.write(', body: $snippet');
    }
    buf.write(')');
    return buf.toString();
  }
}
