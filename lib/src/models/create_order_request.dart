import 'package:json_annotation/json_annotation.dart';
import 'package:starshipit/src/models/order_details.dart';

part 'create_order_request.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CreateOrderRequest {
  const CreateOrderRequest({required this.order});

  final OrderDetails order;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
