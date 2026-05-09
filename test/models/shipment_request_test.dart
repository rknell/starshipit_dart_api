import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

void main() {
  test('CreateShipmentRequest serializes reprint when true', () {
    final json = const CreateShipmentRequest(
      orderId: 42,
      reprint: true,
    ).toJson();
    expect(json['order_id'], 42);
    expect(json['reprint'], true);
  });
}
