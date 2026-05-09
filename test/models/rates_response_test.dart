import 'dart:convert';
import 'dart:io';

import 'package:starshipit/src/models/rates.dart';
import 'package:test/test.dart';

void main() {
  test(
    'RatesResponse parses default_service from delivery services payload',
    () {
      final json =
          jsonDecode(
                '{"success":true,"services":[{"carrier":"A","total_price":5}],'
                '"default_service":{"carrier":"A","service_code":"STD"}}',
              )
              as Map<String, dynamic>;
      final r = RatesResponse.fromJson(json);
      expect(r.quotes, hasLength(1));
      expect(r.defaultService?.serviceCode, 'STD');
    },
  );

  test('RatesResponse unwraps data.services', () async {
    final json =
        jsonDecode(await File('test/fixtures/rates_nested.json').readAsString())
            as Map<String, dynamic>;
    final r = RatesResponse.fromJson(json);
    expect(r.quotes, hasLength(1));
    expect(r.quotes.first.carrier, '12');
    expect(r.quotes.first.totalPrice, 14.5);
    expect(r.rawKeys, isNotNull);
  });
}
