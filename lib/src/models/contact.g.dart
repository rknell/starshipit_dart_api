// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  building: json['building'] as String?,
  company: json['company'] as String?,
  street: json['street'] as String?,
  suburb: json['suburb'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  postCode: json['post_code'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
  'name': ?instance.name,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'building': ?instance.building,
  'company': ?instance.company,
  'street': ?instance.street,
  'suburb': ?instance.suburb,
  'city': ?instance.city,
  'state': ?instance.state,
  'post_code': ?instance.postCode,
  'country': ?instance.country,
};
