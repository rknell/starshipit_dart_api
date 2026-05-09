import 'dart:convert';
import 'dart:io';

import 'package:starshipit/src/models/orders_list_result.dart';
import 'package:test/test.dart';

void main() {
  test('OrdersListResult parses data.orders and carrier_id', () async {
    final json =
        jsonDecode(
              await File('test/fixtures/orders_list_paged.json').readAsString(),
            )
            as Map<String, dynamic>;
    final r = OrdersListResult.fromJson(json);
    expect(r.orders, hasLength(2));
    expect(r.orders!.first.carrier, 9);
    expect(r.orders!.first.carrierName, 'Plain Label');
    expect(r.total, 2);
    expect(r.page, 1);
    expect(r.pageSize, 2);
  });
}
