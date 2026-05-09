import 'package:starshipit/src/models/order_statuses.dart';

/// Query parameters for [GET /orders] (see published API docs for `page_number`, `page_size`, …).
class OrdersListQuery {
  const OrdersListQuery({
    this.status,
    this.include,
    this.pageNumber,
    this.pageSize,
    this.filter,
    this.sortColumn,
    this.sortDirection,
    this.since,
    this.until,
  });

  /// e.g. [OrderStatuses.unshipped], `Printed`, `Shipped`.
  final String? status;

  /// Repeated `include` query keys (e.g. `Shipping_Price`, `Shipment_Attributes`).
  final List<String>? include;

  /// Doc query name: `page_number`.
  final int? pageNumber;

  /// Doc query name: `page_size`.
  final int? pageSize;

  /// Optional filter expression when supported by your tenant/API version.
  final String? filter;

  final String? sortColumn;

  /// e.g. `asc`, `desc`.
  final String? sortDirection;

  /// Optional date filters if supported by your plan / API version (ISO-8601 strings).
  final String? since;
  final String? until;

  Map<String, Object?> toParameters() {
    final m = <String, Object?>{};
    if (status != null) {
      m['status'] = status;
    }
    if (include != null && include!.isNotEmpty) {
      m['include'] = include!;
    }
    if (pageNumber != null) {
      m['page_number'] = '$pageNumber';
    }
    if (pageSize != null) {
      m['page_size'] = '$pageSize';
    }
    if (filter != null) {
      m['filter'] = filter;
    }
    if (sortColumn != null) {
      m['sort_column'] = sortColumn;
    }
    if (sortDirection != null) {
      m['sort_direction'] = sortDirection;
    }
    if (since != null) {
      m['since'] = since;
    }
    if (until != null) {
      m['until'] = until;
    }
    return m;
  }
}
