import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

void main() {
  test('LineItem parses string quantity and weight from API payloads', () {
    final li = LineItem.fromJson({
      'description': 'White Stag Vodka',
      'sku': 'VOD-1',
      'quantity': '4',
      'quantity_to_ship': '4',
      'weight': '1.25',
      'value': '99.00',
    });
    expect(li.quantity, 4);
    expect(li.quantityToShip, 4);
    expect(li.weight, closeTo(1.25, 0.001));
    expect(li.value, closeTo(99.0, 0.001));
  });
}
