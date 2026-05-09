import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(includeIfNull: false)
class Address {
  const Address({
    this.name,
    this.phone,
    this.email,
    this.building,
    this.street,
    this.company,
    this.suburb,
    this.state,
    this.postCode,
    this.country,
    this.deliveryInstructions,
  });

  final String? name;
  final String? phone;
  final String? email;
  final String? building;
  final String? street;
  final String? company;
  final String? suburb;
  final String? state;

  @JsonKey(name: 'post_code')
  final String? postCode;

  final String? country;

  @JsonKey(name: 'delivery_instructions')
  final String? deliveryInstructions;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
