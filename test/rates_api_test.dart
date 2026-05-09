import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com/'));
  });

  test('quote POST /rates with destination and packages', () async {
    final mock = _MockClient();
    when(
      () => mock.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments[0] as Uri;
      final body = invocation.namedArguments[#body] as String?;
      expect(uri.path, endsWith('/rates'));
      expect(body, contains('country_code'));
      expect(body, contains('AU'));
      return http.Response(
        '{"services":[{"carrier":"AusPost","total_price":12.5}]}',
        200,
      );
    });

    final client = StarshipitClient(
      StarshipitConfig(apiKey: 'k', subscriptionKey: 's'),
      httpClient: mock,
    );
    addTearDown(client.close);

    final res = await client.rates.quote(
      RatesRequest(
        destination: const RatesLocation(
          street: '1 St',
          suburb: 'Sydney',
          city: 'Sydney',
          state: 'NSW',
          postCode: '2000',
          countryCode: 'AU',
        ),
        packages: [const RatesPackage(weight: 0.5)],
        includePricing: true,
      ),
    );
    expect(res.quotes, hasLength(1));
    expect(res.quotes.first.carrier, 'AusPost');
    expect(res.rawKeys, 'services');
  });

  test(
    'deliveryServices POST /deliveryservices with order-scoped body',
    () async {
      final mock = _MockClient();
      when(
        () => mock.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        final body = invocation.namedArguments[#body] as String?;
        expect(uri.path, endsWith('/deliveryservices'));
        expect(body, contains('"order_id":100'));
        expect(body, contains('"include_pricing":true'));
        return http.Response(
          '{"success":true,"services":[{"carrier":"X","service_code":"Y"}],"default_service":{"carrier":"X"}}',
          200,
        );
      });

      final client = StarshipitClient(
        StarshipitConfig(apiKey: 'k', subscriptionKey: 's'),
        httpClient: mock,
      );
      addTearDown(client.close);

      final res = await client.rates.deliveryServices(
        DeliveryServicesRequest(
          orderId: 100,
          packages: const [RatesPackage(weight: 1)],
          includePricing: true,
        ),
      );
      expect(res.quotes, hasLength(1));
      expect(res.defaultService?.carrier, 'X');
    },
  );
}
