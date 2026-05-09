import 'dart:convert';

import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

void main() {
  test('ShipmentResponse parses labels array from POST orders/shipment', () {
    final json =
        jsonDecode(
              '{"order_id":1,"success":true,"labels":["%PDF"],"messages":[]}',
            )
            as Map<String, dynamic>;
    final s = ShipmentResponse.fromJson(json);
    expect(s.labels, ['%PDF']);
    expect(s.labelData, '%PDF');
    expect(s.success, isTrue);
  });

  test('ShipmentResponse parses tracking_numbers and label_types lists', () {
    final json =
        jsonDecode(
              '{"order_id":2,"success":true,"tracking_numbers":["TN1","TN2"],"label_types":["PDF","PDF"],"labels":["YQ=="]}',
            )
            as Map<String, dynamic>;
    final s = ShipmentResponse.fromJson(json);
    expect(s.trackingNumbers, ['TN1', 'TN2']);
    expect(s.trackingNumber, 'TN1');
    expect(s.labelTypes, ['PDF', 'PDF']);
  });
}
