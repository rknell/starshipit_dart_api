import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ErrorResponse {
  const ErrorResponse({this.message, this.statusCode});

  final String? message;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
