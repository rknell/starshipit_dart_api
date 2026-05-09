import 'dart:convert';

import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

void main() {
  test('ShippedResponse parses orders map from POST orders/shipped', () {
    final json =
        jsonDecode(
              '{"success":true,"orders":{"398667087":"XYZ-111","398667099":"ABC-222"}}',
            )
            as Map<String, dynamic>;
    final r = ShippedResponse.fromJson(json);
    expect(r.success, isTrue);
    expect(r.orders, {'398667087': 'XYZ-111', '398667099': 'ABC-222'});
  });
}
