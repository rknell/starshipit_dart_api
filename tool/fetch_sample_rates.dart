// Sample live POST /rates call — run from package root:
//   dart run tool/fetch_sample_rates.dart
//
// Requires STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY in `.env` or env.

import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:starshipit/starshipit.dart';

Future<void> main() async {
  final env = DotEnv(includePlatformEnvironment: true, quiet: true);
  final cwd = Directory.current.path;
  final dotEnvFile = File(p.join(cwd, '.env'));
  if (dotEnvFile.existsSync()) {
    env.load([dotEnvFile.path]);
  } else {
    env.load();
  }

  final apiKey = env['STARSHIPIT_API_KEY'];
  final subKey = env['STARSHIPIT_SUBSCRIPTION_KEY'];
  if (apiKey == null || subKey == null || apiKey.isEmpty || subKey.isEmpty) {
    stderr.writeln(
      'Set STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY in .env or environment.',
    );
    exitCode = 1;
    return;
  }

  final client = StarshipitClient(
    StarshipitConfig(apiKey: apiKey, subscriptionKey: subKey),
  );

  final request = RatesRequest(
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
  );

  try {
    final httpResponse = await client.raw.post(
      'rates',
      jsonBody: request.toJson(),
    );
    stdout.writeln('HTTP ${httpResponse.statusCode}');
    final decoded = jsonDecode(httpResponse.body);
    if (decoded is! Map<String, dynamic>) {
      stdout.writeln('Body is not a JSON object: ${decoded.runtimeType}');
      return;
    }

    stdout.writeln('Top-level keys: ${decoded.keys.toList()}');

    for (final entry in decoded.entries) {
      final v = entry.value;
      if (v is List) {
        stdout.writeln('  ${entry.key}: List(len=${v.length})');
        if (v.isNotEmpty && v.first is Map) {
          stdout.writeln(
            '    first element keys: ${(v.first as Map).keys.toList()}',
          );
        }
      } else if (v is Map) {
        stdout.writeln('  ${entry.key}: Map(keys=${v.keys.toList()})');
      } else {
        stdout.writeln('  ${entry.key}: $v');
      }
    }

    final parsed = RatesResponse.fromJson(decoded);
    stdout.writeln(
      '\nRatesResponse: quotes=${parsed.quotes.length}, rawKeys=${parsed.rawKeys}',
    );
    for (var i = 0; i < parsed.quotes.length && i < 8; i++) {
      final q = parsed.quotes[i];
      stdout.writeln(
        '  [$i] carrier=${q.carrier} name=${q.carrierName} '
        'svc=${q.serviceCode} price=${q.totalPrice} ${q.currency} '
        'extra=${q.raw.keys.take(6).join(",")}',
      );
    }
    if (parsed.quotes.isEmpty && decoded.isNotEmpty) {
      stdout.writeln(
        '\nTip: extend RatesResponse.fromJson candidates if the array lives under another key.',
      );
    }
  } on StarshipitException catch (e) {
    stderr.writeln('$e');
    exitCode = 1;
  } finally {
    client.close();
  }
}
