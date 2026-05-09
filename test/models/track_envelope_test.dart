import 'dart:convert';

import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

void main() {
  test('TrackEnvelope parses results as a single object', () {
    final json =
        jsonDecode(
              '{"success":true,"results":{"order_number":"A","tracking_number":"T1"}}',
            )
            as Map<String, dynamic>;
    final e = TrackEnvelope.fromJson(json);
    expect(e.results, hasLength(1));
    expect(e.firstResult?.trackingNumber, 'T1');
  });

  test('TrackEnvelope parses results as a list', () {
    final json =
        jsonDecode(
              '{"success":true,"results":[{"order_number":"A","tracking_number":"T1"},{"order_number":"B","tracking_number":"T2"}]}',
            )
            as Map<String, dynamic>;
    final e = TrackEnvelope.fromJson(json);
    expect(e.results, hasLength(2));
    expect(e.results.last.trackingNumber, 'T2');
  });
}
