// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineItem _$LineItemFromJson(Map<String, dynamic> json) => LineItem(
  itemId: nullableIntFromJson(json['item_id']),
  description: json['description'] as String?,
  sku: json['sku'] as String?,
  countryOfOrigin: json['country_of_origin'] as String?,
  quantity: nullableIntFromJson(json['quantity']),
  quantityToShip: nullableIntFromJson(json['quantity_to_ship']),
  weight: nullableDoubleFromJson(json['weight']),
  value: nullableDoubleFromJson(json['value']),
);

Map<String, dynamic> _$LineItemToJson(LineItem instance) => <String, dynamic>{
  'item_id': ?instance.itemId,
  'description': ?instance.description,
  'sku': ?instance.sku,
  'country_of_origin': ?instance.countryOfOrigin,
  'quantity': ?instance.quantity,
  'quantity_to_ship': ?instance.quantityToShip,
  'weight': ?instance.weight,
  'value': ?instance.value,
};
