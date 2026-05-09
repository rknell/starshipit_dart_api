import 'package:dotenv/dotenv.dart';
import 'package:starshipit/starshipit.dart';
import 'package:test/test.dart';

import '../support/integration_dotenv.dart';
import '../support/plain_label_carrier.dart';

/// Live API: Plain Label (`carrier` + `shipping_method`) avoids integrated courier booking.
///
/// Requires `STARSHIPIT_API_KEY` and `STARSHIPIT_SUBSCRIPTION_KEY` in `.env`.
///
/// Plain Label resolution (first match wins):
/// 1. `STARSHIPIT_PLAIN_LABEL_CARRIER_ID` and optional `STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD`
///    (defaults to `FREEDELIVERY` when id is set from env without method)
/// 2. A recent order whose `carrier_name` contains `"Plain"` — reuses its `carrier_id` and
///    `shipping_method` (e.g. `FREEDELIVERY`)
/// 3. Otherwise the test fails with instructions (create Plain Label in Settings → Couriers,
///    ship one order once, or set the env vars).
void main() {
  final DotEnv env = loadIntegrationDotEnv();

  group('integration order lifecycle', () {
    test(
      'create, update, plain-label ship, redownload label, list orders',
      () async {
        final client = StarshipitClient(
          StarshipitConfig(
            apiKey: env['STARSHIPIT_API_KEY']!,
            subscriptionKey: env['STARSHIPIT_SUBSCRIPTION_KEY']!,
          ),
        );
        addTearDown(client.close);

        final plain = await resolvePlainLabelCarrier(client, env);
        if (plain == null) {
          fail(
            'Could not resolve Plain Label: add STARSHIPIT_PLAIN_LABEL_CARRIER_ID / '
            'STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD to .env, or ensure at least one '
            'order in Starshipit uses Plain Label (carrier_name contains Plain).',
          );
        }

        final suffix = DateTime.now().millisecondsSinceEpoch;
        final orderNumber = 'DART-INT-$suffix';

        const destination = Address(
          name: 'Integration Test',
          email: 'integration-test@example.com',
          phone: '0400000000',
          street: '20 George Street',
          suburb: 'Sydney',
          state: 'NSW',
          postCode: '2000',
          country: 'Australia',
          deliveryInstructions: 'Integration test order',
        );

        final lineItem = LineItem(
          description: 'Integration line',
          sku: 'INT-SKU-$suffix',
          quantity: 1,
          weight: 0.5,
          value: 25,
        );

        final created = await client.orders.create(
          OrderDetails(
            orderNumber: orderNumber,
            reference: 'integration-create',
            carrier: plain.carrierId,
            shippingMethod: plain.shippingMethod,
            signatureRequired: 0,
            currency: 'AUD',
            destination: destination,
            items: [lineItem],
          ),
        );

        expect(created.success, isNot(false));
        final orderId = created.order?.orderId;
        expect(
          orderId,
          isNotNull,
          reason: 'create order should return order_id',
        );
        expect(created.order?.carrierName?.toLowerCase(), contains('plain'));

        final updated = await client.orders.update(
          OrderDetails(
            orderId: orderId,
            orderNumber: orderNumber,
            reference: 'integration-updated',
            carrier: plain.carrierId,
            shippingMethod: plain.shippingMethod,
            signatureRequired: 0,
            currency: 'AUD',
            destination: destination,
            items: [lineItem],
          ),
        );
        expect(updated.success, isNot(false));
        expect(updated.order?.reference, 'integration-updated');

        final shipped = await client.labels.createShipment(
          CreateShipmentRequest(orderId: orderId!),
        );
        expect(
          _hasLabelPayload(shipped),
          isTrue,
          reason: 'dispatch should return label or order payload',
        );

        final redownload = await client.labels.redownloadLabel(orderId);
        expect(
          _hasLabelPayload(redownload),
          isTrue,
          reason: 'redownload should return label or order payload',
        );

        final listed = await client.orders.list(
          const OrdersListQuery(pageNumber: 1, pageSize: 25),
        );
        expect(listed.orders, isNotNull);
        expect(listed.orders, isNotEmpty);
        expect(listed.total, greaterThan(0));
      },
      skip: _skipLifecycle(env),
    );
  }, tags: ['integration']);
}

Object? _skipLifecycle(DotEnv env) {
  if (!env.isDefined('STARSHIPIT_API_KEY') ||
      !env.isDefined('STARSHIPIT_SUBSCRIPTION_KEY')) {
    return 'Set STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY';
  }
  return false;
}

bool _hasLabelPayload(ShipmentOrOrder result) {
  final ship = result.asShipment;
  if (ship != null) {
    final hasPdfLabels = ship.labels != null && ship.labels!.isNotEmpty;
    final hasInline = ship.labelData != null && ship.labelData!.isNotEmpty;
    final hasTrackingList =
        ship.trackingNumbers != null && ship.trackingNumbers!.isNotEmpty;
    final hasTrackingScalar =
        ship.trackingNumber != null && ship.trackingNumber!.trim().isNotEmpty;
    return hasPdfLabels || hasInline || hasTrackingList || hasTrackingScalar;
  }
  final ord = result.asOrder;
  if (ord != null && ord.order != null) {
    return true;
  }
  return false;
}
