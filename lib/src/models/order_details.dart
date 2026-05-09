import 'package:json_annotation/json_annotation.dart';
import 'package:starshipit/src/json_converters.dart';
import 'package:starshipit/src/models/address.dart';
import 'package:starshipit/src/models/contact.dart';
import 'package:starshipit/src/models/line_item.dart';
import 'package:starshipit/src/models/metadata.dart';
import 'package:starshipit/src/models/starshipit_package.dart';

part 'order_details.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class OrderDetails {
  const OrderDetails({
    this.orderId,
    this.orderDate,
    this.orderNumber,
    this.reference,
    this.carrier,
    this.carrierName,
    this.carrierServiceCode,
    this.shippingMethod,
    this.signatureRequired,
    this.currency,
    this.senderDetails,
    this.destination,
    this.items,
    this.packages,
    this.metadatas,
  });

  @JsonKey(
    name: 'order_id',
    fromJson: nullableIntFromJson,
    toJson: nullableIntToJson,
  )
  final int? orderId;

  @JsonKey(name: 'order_date')
  final String? orderDate;

  @JsonKey(name: 'order_number')
  final String? orderNumber;

  final String? reference;

  @JsonKey(
    fromJson: nullableIntFromJson,
    toJson: nullableIntToJson,
    readValue: readCarrierOrCarrierId,
  )
  final int? carrier;

  @JsonKey(name: 'carrier_name')
  final String? carrierName;

  @JsonKey(
    name: 'carrier_service_code',
    fromJson: nullableIntFromJson,
    toJson: nullableIntToJson,
  )
  final int? carrierServiceCode;

  @JsonKey(name: 'shipping_method')
  final String? shippingMethod;

  @JsonKey(
    name: 'signature_required',
    fromJson: signatureRequiredFromJson,
    toJson: nullableIntToJson,
  )
  final int? signatureRequired;

  final String? currency;

  @JsonKey(name: 'sender_details')
  final Contact? senderDetails;

  final Address? destination;
  final List<LineItem>? items;
  final List<StarshipitPackage>? packages;
  final List<Metadata>? metadatas;

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
