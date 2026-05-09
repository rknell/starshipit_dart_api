import 'package:starshipit/src/http/query_encoding.dart';
import 'package:test/test.dart';

void main() {
  test('encodeQueryParameters repeats keys for iterable values', () {
    final q = encodeQueryParameters({
      'a': '1',
      'include': ['Shipping_Price', 'Shipment_Attributes'],
    });
    expect(q, contains('a=1'));
    expect(q, contains('include=Shipping_Price'));
    expect(q, contains('include=Shipment_Attributes'));
  });
}
