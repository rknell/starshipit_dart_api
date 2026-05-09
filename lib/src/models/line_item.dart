import 'package:json_annotation/json_annotation.dart';
import 'package:starshipit/src/json_converters.dart';

part 'line_item.g.dart';

@JsonSerializable(includeIfNull: false)
class LineItem {
  const LineItem({
    this.itemId,
    this.description,
    this.sku,
    this.countryOfOrigin,
    this.quantity,
    this.quantityToShip,
    this.weight,
    this.value,
  });

  @JsonKey(name: 'item_id', fromJson: nullableIntFromJson)
  final int? itemId;

  final String? description;
  final String? sku;

  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;

  @JsonKey(fromJson: nullableIntFromJson)
  final int? quantity;

  @JsonKey(name: 'quantity_to_ship', fromJson: nullableIntFromJson)
  final int? quantityToShip;

  @JsonKey(fromJson: nullableDoubleFromJson)
  final double? weight;

  @JsonKey(fromJson: nullableDoubleFromJson)
  final double? value;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);

  Map<String, dynamic> toJson() => _$LineItemToJson(this);
}
