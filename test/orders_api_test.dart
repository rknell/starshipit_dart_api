import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com/'));
  });

  test(
    'listUnshipped GET targets orders/unshipped and sends auth headers',
    () async {
      final mock = _MockClient();
      when(() => mock.get(any(), headers: any(named: 'headers'))).thenAnswer((
        invocation,
      ) async {
        final uri = invocation.positionalArguments[0] as Uri;
        final headers =
            invocation.namedArguments[#headers] as Map<String, String>?;
        expect(uri.path, endsWith('/orders/unshipped'));
        expect(headers?['StarShipIT-Api-Key'], 'api-key');
        expect(headers?['Ocp-Apim-Subscription-Key'], 'sub-key');
        return http.Response('{"orders":[]}', 200);
      });

      final client = StarshipitClient(
        StarshipitConfig(apiKey: 'api-key', subscriptionKey: 'sub-key'),
        httpClient: mock,
      );
      addTearDown(client.close);

      final result = await client.orders.listUnshipped();
      expect(result.orders, isEmpty);
      verify(() => mock.get(any(), headers: any(named: 'headers'))).called(1);
    },
  );

  test(
    'listUnshipped sends page/limit and page_number/page_size for API compatibility',
    () async {
      final mock = _MockClient();
      when(() => mock.get(any(), headers: any(named: 'headers'))).thenAnswer((
        invocation,
      ) async {
        final uri = invocation.positionalArguments[0] as Uri;
        final q = uri.queryParameters;
        expect(q['limit'], '25');
        expect(q['page_size'], '25');
        expect(q['page'], '2');
        expect(q['page_number'], '2');
        return http.Response('{"orders":[]}', 200);
      });

      final client = StarshipitClient(
        StarshipitConfig(apiKey: 'api-key', subscriptionKey: 'sub-key'),
        httpClient: mock,
      );
      addTearDown(client.close);

      await client.orders.listUnshipped(limit: 25, page: 2);
      verify(() => mock.get(any(), headers: any(named: 'headers'))).called(1);
    },
  );

  test('listShipped GET targets orders/shipped', () async {
    final mock = _MockClient();
    when(() => mock.get(any(), headers: any(named: 'headers'))).thenAnswer((
      invocation,
    ) async {
      final uri = invocation.positionalArguments[0] as Uri;
      expect(uri.path, endsWith('/orders/shipped'));
      return http.Response('{"orders":[]}', 200);
    });

    final client = StarshipitClient(
      StarshipitConfig(apiKey: 'api-key', subscriptionKey: 'sub-key'),
      httpClient: mock,
    );
    addTearDown(client.close);

    await client.orders.listShipped(limit: 1);
    verify(() => mock.get(any(), headers: any(named: 'headers'))).called(1);
  });

  test('create POST sends JSON order wrapper', () async {
    final mock = _MockClient();
    when(
      () => mock.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((invocation) async {
      final body = invocation.namedArguments[#body] as String?;
      expect(body, contains('"order"'));
      expect(body, contains('"order_number":"POS-1"'));
      return http.Response(
        '{"success":true,"order":{"order_id":99,"order_number":"POS-1"}}',
        200,
      );
    });

    final client = StarshipitClient(
      StarshipitConfig(apiKey: 'api-key', subscriptionKey: 'sub-key'),
      httpClient: mock,
    );
    addTearDown(client.close);

    final res = await client.orders.create(
      OrderDetails(
        orderNumber: 'POS-1',
        destination: const Address(
          name: 'A',
          street: 'B',
          suburb: 'C',
          state: 'VIC',
          postCode: '3000',
          country: 'Australia',
        ),
        items: [
          LineItem(description: 'Item', quantity: 1, weight: 0.1, value: 10),
        ],
      ),
    );
    expect(res.order?.orderId, 99);
    verify(
      () => mock.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).called(1);
  });
}
