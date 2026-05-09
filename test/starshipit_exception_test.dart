import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com/'));
  });

  test('non-JSON error body still throws StarshipitException', () async {
    final mock = _MockClient();
    when(
      () => mock.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('gateway problem', 502));

    final client = StarshipitClient(
      StarshipitConfig(apiKey: 'k', subscriptionKey: 's'),
      httpClient: mock,
    );
    addTearDown(client.close);

    expect(
      () => client.validate.validate(),
      throwsA(
        isA<StarshipitException>()
            .having((e) => e.statusCode, 'status', 502)
            .having((e) => e.body, 'body', contains('gateway')),
      ),
    );
  });

  test('JSON error envelope maps to parsedErrors when possible', () async {
    final mock = _MockClient();
    when(() => mock.get(any(), headers: any(named: 'headers'))).thenAnswer(
      (_) async => http.Response(
        '{"errors":[{"message":"Invalid key","details":"auth"}]}',
        401,
      ),
    );

    final client = StarshipitClient(
      StarshipitConfig(apiKey: 'k', subscriptionKey: 's'),
      httpClient: mock,
    );
    addTearDown(client.close);

    try {
      await client.validate.validate();
      fail('expected throw');
    } on StarshipitException catch (e) {
      expect(e.parsedErrors, isNotNull);
      expect(e.parsedErrors!.first.message, 'Invalid key');
    }
  });
}
