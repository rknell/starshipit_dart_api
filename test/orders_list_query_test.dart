import 'package:starshipit/src/api/orders_list_query.dart';
import 'package:test/test.dart';

void main() {
  test('OrdersListQuery maps page to page_number query key', () {
    final q = const OrdersListQuery(pageNumber: 3, pageSize: 50).toParameters();
    expect(q['page_number'], '3');
    expect(q['page_size'], '50');
  });
}
