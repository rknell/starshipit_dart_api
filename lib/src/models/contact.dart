import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable(includeIfNull: false)
class Contact {
  const Contact({
    this.name,
    this.email,
    this.phone,
    this.building,
    this.company,
    this.street,
    this.suburb,
    this.city,
    this.state,
    this.postCode,
    this.country,
  });

  final String? name;
  final String? email;
  final String? phone;
  final String? building;
  final String? company;
  final String? street;
  final String? suburb;
  final String? city;
  final String? state;

  @JsonKey(name: 'post_code')
  final String? postCode;

  final String? country;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
