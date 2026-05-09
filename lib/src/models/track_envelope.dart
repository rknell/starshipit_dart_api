import 'package:starshipit/src/models/api_error.dart';
import 'package:starshipit/src/models/tracking_details.dart';

/// Wrapper for [GET /track] — `results` is a list of tracking detail objects in current API docs.
class TrackEnvelope {
  const TrackEnvelope({this.success, this.errors, required this.results});

  final bool? success;
  final List<ApiError>? errors;

  /// Tracking rows returned for the query (empty when none).
  final List<TrackingDetails> results;

  /// First row when [results] is non-empty (convenience for single-match callers).
  TrackingDetails? get firstResult => results.isEmpty ? null : results.first;

  factory TrackEnvelope.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];
    var list = <TrackingDetails>[];
    if (raw is List) {
      list = raw
          .whereType<Map<String, dynamic>>()
          .map(TrackingDetails.fromJson)
          .toList();
    } else if (raw is Map<String, dynamic>) {
      list = [TrackingDetails.fromJson(raw)];
    }

    return TrackEnvelope(
      success: _coerceBoolStatic(json['success']),
      errors: _coerceErrorsStatic(json['errors']),
      results: list,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'errors': errors?.map((e) => e.toJson()).toList(),
    'results': results.map((e) => e.toJson()).toList(),
  };
}

bool? _coerceBoolStatic(Object? value) => switch (value) {
  null => null,
  final bool b => b,
  final num n => n != 0,
  final String s when s.toLowerCase() == 'true' || s == '1' => true,
  final String s when s.toLowerCase() == 'false' || s == '0' => false,
  _ => null,
};

List<ApiError>? _coerceErrorsStatic(Object? value) {
  if (value is! List) {
    return null;
  }
  return value
      .whereType<Map<String, dynamic>>()
      .map(ApiError.fromJson)
      .toList();
}
