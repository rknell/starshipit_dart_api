import 'package:json_annotation/json_annotation.dart';

part 'metadata.g.dart';

@JsonSerializable(includeIfNull: false)
class Metadata {
  const Metadata({this.metafieldKey, this.value});

  @JsonKey(name: 'metafield_key')
  final String? metafieldKey;

  final String? value;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
