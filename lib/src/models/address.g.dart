// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  building: json['building'] as String?,
  street: json['street'] as String?,
  company: json['company'] as String?,
  suburb: json['suburb'] as String?,
  state: json['state'] as String?,
  postCode: json['post_code'] as String?,
  country: json['country'] as String?,
  deliveryInstructions: json['delivery_instructions'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'name': ?instance.name,
  'phone': ?instance.phone,
  'email': ?instance.email,
  'building': ?instance.building,
  'street': ?instance.street,
  'company': ?instance.company,
  'suburb': ?instance.suburb,
  'state': ?instance.state,
  'post_code': ?instance.postCode,
  'country': ?instance.country,
  'delivery_instructions': ?instance.deliveryInstructions,
};
