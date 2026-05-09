// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      order: OrderDetails.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{'order': instance.order.toJson()};
