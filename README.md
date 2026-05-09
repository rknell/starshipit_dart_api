# starshipit

Dart client for the [Starshipit](https://www.starshipit.com/) HTTP API (`https://api.starshipit.com/api/`). Official reference: [API documentation](https://api-docs.starshipit.com/).

**For AI assistants and code agents:** read [AGENTS.md](AGENTS.md) first for layout, codegen, tests, and safety rules.

## Install

After this package is published to pub.dev:

```bash
dart pub add starshipit
```

Until then, use a path or git dependency:

```yaml
dependencies:
  starshipit:
    path: ../starshipit_dart_api  # or git: url: https://github.com/rknell/starshipit_dart_api.git
```

## Authentication

Set these environment variables (never commit them):

| Variable | Source in Starshipit UI |
|----------|-------------------------|
| `STARSHIPIT_API_KEY` | Settings → API → API Key |
| `STARSHIPIT_SUBSCRIPTION_KEY` | Settings → API → Subscription key |

The repo [`.gitignore`](.gitignore) excludes `.env`. **Tests** and **tool/** may load `.env` via `dotenv`. The **`example/`** program `bin/list_new_orders.dart` loads `example/.env` first (then the package root `.env` or process environment).

## Quick start

```dart
import 'package:starshipit/starshipit.dart';

void main() async {
  final client = StarshipitClient(
    StarshipitConfig(
      apiKey: const String.fromEnvironment('STARSHIPIT_API_KEY'),
      subscriptionKey: const String.fromEnvironment('STARSHIPIT_SUBSCRIPTION_KEY'),
    ),
  );
  try {
    await client.validate.validate(); // GET /health — connectivity only; see AGENTS.md
    final orders = await client.orders.list(const OrdersListQuery(pageNumber: 1, pageSize: 10));
    // ...
  } finally {
    client.close();
  }
}
```

## Endpoint coverage

| HTTP | Path (under `/api/`) | Typed API |
|------|----------------------|-----------|
| GET | `health` | `client.validate.validate()` |
| POST | `orders` | `client.orders.create` |
| PUT | `orders` | `client.orders.update` |
| GET | `orders` | `client.orders.getByOrderId`, `getByOrderNumber`, `list` |
| GET | `orders/unshipped` | `client.orders.listUnshipped` |
| GET | `orders/shipped` | `client.orders.listShipped` |
| GET | `orders/shipments` | `client.orders.listShipments` |
| GET | `orders/delivered` | `client.orders.listDelivered` |
| GET | `orders/summary` | `client.orders.summary` |
| GET | `orders/search` | `client.orders.search` |
| POST | `orders/shipped` (tracking-only batch) | `client.shipped.createTrackingOrders` |
| POST | `orders/shipment` | `client.labels.createShipment`, `redownloadLabel` |
| POST | `rates` | `client.rates.quote` / `shippingQuote` |
| POST | `deliveryservices` | `client.rates.deliveryServices` |
| GET | `track` | `client.tracking.get`, `getByTrackingNumber`, `getByOrderNumber` |

**Use `client.raw`** (`get` / `post` / `put` / `delete`) for documented routes not yet wrapped, for example (non-exhaustive): `orders/import`, `orders/batchupdate`, `orders/delete`, `orders/archive`, `orders/restore`, `orders/assign`, `orders/merge`, `orders/mergeable`, `orders/packingslips`, `orders/shipment/replace`, `orders/shipment/clone`, `orders/manifest`, `manifests`, `manifests/files`, `manifests/carrier`, `manifests/shipments`, `products`, `addressbook`, etc.

## Examples

See the [`example/`](example/) package. Put API keys in `example/.env` or export them, then:

```bash
# From repo root (resolves the example package automatically):
dart example/bin/list_new_orders.dart
dart example/bin/list_new_orders.dart --limit 50

# Or from example/ after dart pub get:
cd example
dart run bin/list_new_orders.dart
```

Illustrative snippets:

```dart
// Rates (no label cost)
final quotes = await client.rates.quote(RatesRequest(
  destination: RatesLocation(countryCode: 'AU', postCode: '2000', state: 'NSW', suburb: 'Sydney', street: '1 St'),
  packages: [RatesPackage(weight: 0.5)],
  currency: 'AUD',
));

// Delivery services (order-scoped or address + packages)
final services = await client.rates.deliveryServices(DeliveryServicesRequest(
  orderId: 12345,
  packages: [RatesPackage(weight: 1)],
  includePricing: true,
));

// Tracking
final track = await client.tracking.getByTrackingNumber('TRACK123');

// Raw fallback (path relative to /api/ — parse response.body yourself)
final res = await client.raw.get('orders', query: {'page_number': '1', 'page_size': '1'});
```

**Labels:** `labels.createShipment` can incur carrier charges. For automated tests use **Plain Label** only; never add examples or tests that book paid carrier labels. See [AGENTS.md](AGENTS.md).

## Tests

```bash
# CI-safe (no live API)
dart test --exclude-tags integration

# Live API — requires STARSHIPIT_* env vars; may create/update orders (Plain Label in lifecycle test)
dart test
```

Optional Plain Label hints for integration tests: `STARSHIPIT_PLAIN_LABEL_CARRIER_ID`, `STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD`.

## Regenerating JSON code

After editing `@JsonSerializable` models:

```bash
dart run build_runner build
```

## Development (hooks and CI)

**Git hooks:** after cloning, install the shared hooks once (runs `dart format`, `dart analyze`, and `dart test` before each commit):

```bash
./tool/install_git_hooks.sh
```

**CI:** [GitHub Actions](.github/workflows/ci.yml) runs on pushes and pull requests to `main` / `master` (format check, analyze, tests, plus the `example` package analyze).

## Publishing / Git

- `dart pub publish --dry-run` — verify package layout before publishing.
- Before pushing: `git status --short` and confirm `.env` is untracked and no secrets in tracked files.
- Create the public repo (after your security audit), for example:

  ```bash
  gh repo create rknell/starshipit_dart_api --public --source=. --remote=origin --push
  ```

## License

See [LICENSE](LICENSE).
