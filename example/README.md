# starshipit examples

Small executables that depend on the parent package via `path: ..`.

## Setup

```bash
cd example
dart pub get
export STARSHIPIT_API_KEY=your_api_key
export STARSHIPIT_SUBSCRIPTION_KEY=your_subscription_key
```

## `list_new_orders.dart`

Paginates `GET /orders?status=Unshipped` and prints each order.

```bash
dart run bin/list_new_orders.dart
dart run bin/list_new_orders.dart --limit 50
```

Keys are read from `Platform.environment` only (no extra packages).
