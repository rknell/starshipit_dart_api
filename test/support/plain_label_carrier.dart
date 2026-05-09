import 'package:dotenv/dotenv.dart';
import 'package:starshipit/starshipit.dart';

/// Couriers → Plain Label plus the shipping method string your store uses with it.
class PlainLabelCarrier {
  PlainLabelCarrier({required this.carrierId, required this.shippingMethod});

  final int carrierId;
  final String shippingMethod;
}

/// Resolves Plain Label settings for API order creation.
///
/// 1. [STARSHIPIT_PLAIN_LABEL_CARRIER_ID] (+ optional [STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD])
/// 2. Else scan recent orders for `carrier_name` containing `"plain"` (case-insensitive)
/// 3. Else returns null — set env or create one Plain Label order in the UI once.
Future<PlainLabelCarrier?> resolvePlainLabelCarrier(
  StarshipitClient client,
  DotEnv env,
) async {
  final envId = int.tryParse(env['STARSHIPIT_PLAIN_LABEL_CARRIER_ID'] ?? '');
  if (envId != null) {
    final method =
        env['STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD'] ?? 'FREEDELIVERY';
    return PlainLabelCarrier(carrierId: envId, shippingMethod: method);
  }

  final listed = await client.orders.list(const OrdersListQuery(pageSize: 100));
  final orders = listed.orders ?? [];
  for (final o in orders) {
    final id = o.carrier;
    final name = o.carrierName?.toLowerCase() ?? '';
    if (id != null && id > 0 && name.contains('plain')) {
      return PlainLabelCarrier(
        carrierId: id,
        shippingMethod: o.shippingMethod ?? 'FREEDELIVERY',
      );
    }
  }

  return null;
}
