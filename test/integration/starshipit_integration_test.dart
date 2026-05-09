import 'package:dotenv/dotenv.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

import '../support/integration_dotenv.dart';

void main() {
  final DotEnv env = loadIntegrationDotEnv();

  group('integration', () {
    test(
      'GET /health succeeds with credentials from .env or environment',
      () async {
        final client = StarshipitClient(
          StarshipitConfig(
            apiKey: env['STARSHIPIT_API_KEY']!,
            subscriptionKey: env['STARSHIPIT_SUBSCRIPTION_KEY']!,
          ),
        );
        addTearDown(client.close);
        await client.validate.validate();
      },
      skip: _hasKeys(env)
          ? false
          : 'Set STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY in .env or the environment',
    );
  }, tags: ['integration']);
}

bool _hasKeys(DotEnv env) {
  return env.isDefined('STARSHIPIT_API_KEY') &&
      env.isDefined('STARSHIPIT_SUBSCRIPTION_KEY');
}
