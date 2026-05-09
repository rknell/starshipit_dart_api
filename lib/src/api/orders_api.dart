import 'dart:convert';

import 'package:starshipit/src/api/orders_list_query.dart';
import 'package:starshipit/src/http/auth_http_client.dart';
import 'package:starshipit/src/models/create_order_request.dart';
import 'package:starshipit/src/models/order_details.dart';
import 'package:starshipit/src/models/order_envelope.dart';
import 'package:starshipit/src/models/orders_list_result.dart';

class OrdersApi {
  OrdersApi(this._http);

  final AuthHttpClient _http;

  /// [POST /orders] — create a new order.
  Future<OrderEnvelope> create(OrderDetails order) async {
    final res = await _http.post(
      'orders',
      jsonBody: CreateOrderRequest(order: order).toJson(),
    );
    return OrderEnvelope.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// [PUT /orders] — update an existing order (include `order_id` on [order]).
  Future<OrderEnvelope> update(OrderDetails order) async {
    final res = await _http.put(
      'orders',
      jsonBody: CreateOrderRequest(order: order).toJson(),
    );
    return OrderEnvelope.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// [GET /orders] — fetch by Starshipit order id.
  Future<OrderEnvelope> getByOrderId(String orderId) async {
    final res = await _http.get('orders', query: {'order_id': orderId});
    return OrderEnvelope.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// [GET /orders] — fetch by your channel order number.
  Future<OrderEnvelope> getByOrderNumber(String orderNumber) async {
    final res = await _http.get('orders', query: {'order_number': orderNumber});
    return OrderEnvelope.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// [GET /orders] — list or filter orders (e.g. status, includes, paging).
  Future<OrdersListResult> list([
    OrdersListQuery query = const OrdersListQuery(),
  ]) async {
    final res = await _http.get('orders', query: query.toParameters());
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/unshipped] — unshipped list (documented query: `limit`, `page`, `ids_only`, …).
  Future<OrdersListResult> listUnshipped({
    List<String>? include,
    int? limit,
    int? page,
    bool? idsOnly,
    String? sinceOrderDate,
    String? sinceLastUpdated,
  }) async {
    final m = _pagedOrdersSublistParams(
      include: include,
      limit: limit,
      page: page,
      idsOnly: idsOnly,
      sinceOrderDate: sinceOrderDate,
      sinceLastUpdated: sinceLastUpdated,
    );
    final res = await _http.get(
      'orders/unshipped',
      query: m.isEmpty ? null : m,
    );
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/shipped] — shipped orders (same query shape as [listUnshipped] in published docs).
  Future<OrdersListResult> listShipped({
    List<String>? include,
    int? limit,
    int? page,
    bool? idsOnly,
    String? sinceOrderDate,
    String? sinceLastUpdated,
  }) async {
    final m = _pagedOrdersSublistParams(
      include: include,
      limit: limit,
      page: page,
      idsOnly: idsOnly,
      sinceOrderDate: sinceOrderDate,
      sinceLastUpdated: sinceLastUpdated,
    );
    final res = await _http.get('orders/shipped', query: m.isEmpty ? null : m);
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/shipments] — printed / unmanifested shipments (`status`, paging, …).
  Future<OrdersListResult> listShipments({
    String? status,
    String? sinceCreatedDate,
    int? limit,
    int? page,
  }) async {
    final m = <String, Object?>{};
    if (status != null) {
      m['status'] = status;
    }
    if (sinceCreatedDate != null) {
      m['since_created_date'] = sinceCreatedDate;
    }
    if (limit != null) {
      m['limit'] = '$limit';
    }
    if (page != null) {
      m['page'] = '$page';
    }
    final res = await _http.get(
      'orders/shipments',
      query: m.isEmpty ? null : m,
    );
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/delivered] — delivered orders (optional `order_ref` filter per docs).
  Future<OrdersListResult> listDelivered({String? orderRef}) async {
    final res = await _http.get(
      'orders/delivered',
      query: orderRef == null ? null : {'order_ref': orderRef},
    );
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/summary] — order summary report (`order_status`, paging, …).
  Future<OrdersListResult> summary({
    String? orderStatus,
    String? sort,
    String? sortDirection,
    String? filter,
    int? page,
    int? pageSize,
  }) async {
    final m = <String, Object?>{};
    if (orderStatus != null) {
      m['order_status'] = orderStatus;
    }
    if (sort != null) {
      m['sort'] = sort;
    }
    if (sortDirection != null) {
      m['sort_direction'] = sortDirection;
    }
    if (filter != null) {
      m['filter'] = filter;
    }
    if (page != null) {
      m['page'] = '$page';
    }
    if (pageSize != null) {
      m['page_size'] = '$pageSize';
    }
    final res = await _http.get('orders/summary', query: m.isEmpty ? null : m);
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }

  /// [GET /orders/search] — search by free-text phrase.
  Future<OrdersListResult> search(String phrase) async {
    final res = await _http.get('orders/search', query: {'phrase': phrase});
    return OrdersListResult.fromDecoded(jsonDecode(res.body));
  }
}

Map<String, Object?> _pagedOrdersSublistParams({
  List<String>? include,
  int? limit,
  int? page,
  bool? idsOnly,
  String? sinceOrderDate,
  String? sinceLastUpdated,
}) {
  final m = <String, Object?>{};
  if (include != null && include.isNotEmpty) {
    m['include'] = include;
  }
  if (limit != null) {
    // Some endpoints honor `limit`/`page`; others match [GET /orders] with `page_size`/`page_number`.
    m['limit'] = '$limit';
    m['page_size'] = '$limit';
  }
  if (page != null) {
    m['page'] = '$page';
    m['page_number'] = '$page';
  }
  if (idsOnly != null) {
    m['ids_only'] = idsOnly ? 'true' : 'false';
  }
  if (sinceOrderDate != null) {
    m['since_order_date'] = sinceOrderDate;
  }
  if (sinceLastUpdated != null) {
    m['since_last_updated'] = sinceLastUpdated;
  }
  return m;
}
