import 'dart:convert';
import 'dart:io';

import 'package:starshipit/src/models/order_envelope.dart';
import 'package:test/test.dart';

void main() {
  test('OrderEnvelope parses success as int and nested order', () async {
    final path = 'test/fixtures/order_envelope.json';
    final json =
        jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    final env = OrderEnvelope.fromJson(json);
    expect(env.success, isTrue);
    expect(env.order?.orderId, 12345);
    expect(env.order?.orderNumber, 'WEB-001');
    expect(env.order?.destination?.suburb, 'Melbourne');
  });
}
