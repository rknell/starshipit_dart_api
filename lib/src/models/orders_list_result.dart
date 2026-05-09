import 'package:starshipit/src/models/order_details.dart';

/// Response for [GET /orders] with optional filters. Shape varies; this captures common fields.
class OrdersListResult {
  const OrdersListResult({this.orders, this.page, this.pageSize, this.total});

  final List<OrderDetails>? orders;
  final int? page;

  /// Some responses use `page_size`, `PageSize`, etc.
  final int? pageSize;
  final int? total;

  /// Handles either a bare JSON array of orders or a wrapped object.
  factory OrdersListResult.fromDecoded(Object? decoded) {
    if (decoded is List) {
      final list = <OrderDetails>[
        for (final e in decoded)
          if (e is Map) OrderDetails.fromJson(Map<String, dynamic>.from(e)),
      ];
      return OrdersListResult(orders: list);
    }
    if (decoded is Map<String, dynamic>) {
      return OrdersListResult.fromJson(decoded);
    }
    return OrdersListResult(orders: const []);
  }

  factory OrdersListResult.fromJson(Map<String, dynamic> json) {
    List<OrderDetails>? list;
    Object? rawOrders = json['orders'] ?? json['Orders'];
    final data = json['data'];
    if (rawOrders == null && data is Map<String, dynamic>) {
      rawOrders = data['orders'] ?? data['Orders'];
    }
    if (rawOrders is List) {
      list = <OrderDetails>[
        for (final e in rawOrders)
          if (e is Map) OrderDetails.fromJson(Map<String, dynamic>.from(e)),
      ];
    }
    return OrdersListResult(
      orders: list,
      page: _intAny(json['page'] ?? json['page_number'] ?? json['Page']),
      pageSize: _intAny(
        json['page_size'] ?? json['pageSize'] ?? json['PageSize'],
      ),
      total: _intAny(json['total'] ?? json['total_records'] ?? json['Total']),
    );
  }
}

int? _intAny(Object? v) {
  if (v == null) {
    return null;
  }
  if (v is int) {
    return v;
  }
  if (v is num) {
    return v.toInt();
  }
  if (v is String) {
    return int.tryParse(v);
  }
  return null;
}
