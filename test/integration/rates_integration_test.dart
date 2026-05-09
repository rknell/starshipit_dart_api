import 'package:dotenv/dotenv.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

import '../support/integration_dotenv.dart';

/// Live [POST /rates] — requires API keys in `.env` (saved to disk).
void main() {
  final DotEnv env = loadIntegrationDotEnv();

  group('integration rates', () {
    test(
      'POST /rates returns quotable services for AU sample destination',
      () async {
        final client = StarshipitClient(
          StarshipitConfig(
            apiKey: env['STARSHIPIT_API_KEY']!,
            subscriptionKey: env['STARSHIPIT_SUBSCRIPTION_KEY']!,
          ),
        );
        addTearDown(client.close);

        final res = await client.rates.shippingQuote(
          RatesRequest(
            destination: const RatesLocation(
              street: '20 George Street',
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

        expect(
          res.quotes,
          isNotEmpty,
          reason: 'Account should return at least one rate row for AU metro',
        );
      },
      skip: _skipRates(env),
    );
  }, tags: ['integration']);
}

Object? _skipRates(DotEnv env) {
  if (!env.isDefined('STARSHIPIT_API_KEY') ||
      !env.isDefined('STARSHIPIT_SUBSCRIPTION_KEY')) {
    return 'Set STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY';
  }
  return false;
}
