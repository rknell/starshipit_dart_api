import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable(includeIfNull: false)
class ApiError {
  const ApiError({this.message, this.details});

  final String? message;
  final String? details;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  String toString() => 'ApiError(message: $message, details: $details)';
}
