// Lists "New" / unshipped orders (same filter as the dashboard New tab) via
// [GET /orders] with status=Unshipped, paginating until all rows are fetched.
// Each row is then loaded with [GET /orders?order_id=…] so line items and the
// destination address are included (the list response is often summary-only).
//
// Run from repo root:
//   dart example/bin/list_new_orders.dart
//
// Or from this package:
//   cd example && dart run bin/list_new_orders.dart
//
// Optional: --limit 100
//
// Loads env from (first match): `example/.env` under the starshipit package root,
// package root `.env`, then cwd `.env`; variables can still be set in the process
// environment. Requires STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY.

import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:starshipit/starshipit.dart';

Future<void> main(List<String> args) async {
  final pageSize = _parseIntArg(args, '--limit') ?? 25;

  final env = _loadExampleDotEnv();

  final apiKey = env['STARSHIPIT_API_KEY'];
  final subKey = env['STARSHIPIT_SUBSCRIPTION_KEY'];
  if (apiKey == null || subKey == null || apiKey.isEmpty || subKey.isEmpty) {
    stderr.writeln(
      'Set STARSHIPIT_API_KEY and STARSHIPIT_SUBSCRIPTION_KEY in example/.env '
      '(or package root .env) or in the environment.',
    );
    exitCode = 1;
    return;
  }

  final client = StarshipitClient(
    StarshipitConfig(apiKey: apiKey, subscriptionKey: subKey),
  );

  try {
    final summaries = await _fetchAllUnshippedOrders(
      client,
      pageSize: pageSize,
    );
    final orders = <OrderDetails>[];
    for (final s in summaries) {
      orders.add(await _enrichOrder(client, s));
    }

    stdout.writeln('Unshipped orders: ${orders.length}');
    stdout.writeln();

    if (orders.isEmpty) {
      stdout.writeln(
        'No unshipped orders returned by GET /orders?status=Unshipped.',
      );
      return;
    }

    for (var i = 0; i < orders.length; i++) {
      _printOrder(orders[i]);
      if (i < orders.length - 1) {
        stdout.writeln('══════════════════════════════════════');
        stdout.writeln();
      }
    }
  } on StarshipitException catch (e) {
    stderr.writeln('$e');
    exitCode = 1;
  } finally {
    client.close();
  }
}

/// Fetches every page until [OrdersListResult.total] is satisfied or a page is empty.
Future<List<OrderDetails>> _fetchAllUnshippedOrders(
  StarshipitClient client, {
  required int pageSize,
}) async {
  final all = <OrderDetails>[];
  var pageNumber = 1;
  const maxPages = 500;

  for (var i = 0; i < maxPages; i++) {
    final result = await client.orders.list(
      OrdersListQuery(
        status: OrderStatuses.unshipped,
        pageNumber: pageNumber,
        pageSize: pageSize,
      ),
    );
    final batch = result.orders ?? const <OrderDetails>[];
    all.addAll(batch);
    final total = result.total;

    if (batch.isEmpty) {
      break;
    }
    if (total != null && all.length >= total) {
      break;
    }
    if (total == null && batch.length < pageSize) {
      break;
    }
    if (total != null && all.length < total) {
      pageNumber++;
      continue;
    }
    if (total == null && batch.length == pageSize) {
      pageNumber++;
      continue;
    }
    break;
  }

  return all;
}

/// Single-order [GET /orders] returns full `items` and `destination`; list does not.
Future<OrderDetails> _enrichOrder(
  StarshipitClient client,
  OrderDetails listed,
) async {
  final id = listed.orderId;
  if (id != null) {
    try {
      final env = await client.orders.getByOrderId('$id');
      final full = env.order;
      if (full != null) {
        return full;
      }
    } on StarshipitException {
      // keep summary
    }
  }
  final num = listed.orderNumber?.trim();
  if (num != null && num.isNotEmpty) {
    try {
      final env = await client.orders.getByOrderNumber(num);
      final full = env.order;
      if (full != null) {
        return full;
      }
    } on StarshipitException {
      // keep summary
    }
  }
  return listed;
}

void _printOrder(OrderDetails o) {
  final date = _formatOrderDate(o.orderDate);
  final orderLabel = _orderLabel(o);
  stdout.writeln('$date - $orderLabel');

  final dest = o.destination;
  stdout.writeln(_customerName(dest));
  stdout.writeln(_formatAddress(dest));

  stdout.writeln(_orEmDash(o.shippingMethod));
  stdout.writeln();
  stdout.writeln('items');
  stdout.writeln('---------');

  final items = o.items ?? const <LineItem>[];
  if (items.isEmpty) {
    stdout.writeln('(no line items)');
  } else {
    for (final li in items) {
      final q = li.quantityToShip ?? li.quantity ?? 1;
      final name = _nonEmpty(li.description, fallback: 'Item');
      final sku = li.sku?.trim();
      final skuSuffix = (sku != null && sku.isNotEmpty) ? ' $sku' : '';
      stdout.writeln('${q}x $name$skuSuffix');
    }
  }
}

String _orderLabel(OrderDetails o) {
  final n = o.orderNumber?.trim();
  if (n != null && n.isNotEmpty) {
    return n;
  }
  final r = o.reference?.trim();
  if (r != null && r.isNotEmpty) {
    return r;
  }
  final id = o.orderId;
  if (id != null) {
    return '#$id';
  }
  return '—';
}

String _customerName(Address? dest) {
  if (dest == null) {
    return '—';
  }
  final name = dest.name?.trim();
  if (name != null && name.isNotEmpty) {
    return name;
  }
  final company = dest.company?.trim();
  if (company != null && company.isNotEmpty) {
    return company;
  }
  return '—';
}

String _formatAddress(Address? a) {
  if (a == null) {
    return '—';
  }
  final parts = <String>[];

  final streetLine = <String>[
    for (final s in [a.building?.trim(), a.street?.trim()])
      if (s != null && s.isNotEmpty) s,
  ].join(' ');
  if (streetLine.isNotEmpty) {
    parts.add(streetLine);
  }

  final locality = <String>[];
  final suburb = a.suburb?.trim();
  if (suburb != null && suburb.isNotEmpty) {
    locality.add(suburb);
  }
  final state = a.state?.trim();
  final post = a.postCode?.trim();
  final statePost = [
    if (state != null && state.isNotEmpty) state,
    if (post != null && post.isNotEmpty) post,
  ].join(' ');
  if (statePost.isNotEmpty) {
    locality.add(statePost);
  }
  if (locality.isNotEmpty) {
    parts.add(locality.join(' '));
  }

  final country = a.country?.trim();
  if (country != null && country.isNotEmpty) {
    parts.add(country);
  }

  if (parts.isEmpty) {
    return '—';
  }
  return parts.join(', ');
}

String _nonEmpty(String? value, {required String fallback}) {
  final t = value?.trim();
  if (t == null || t.isEmpty) {
    return fallback;
  }
  return t;
}

String _orEmDash(String? value) {
  final t = value?.trim();
  if (t == null || t.isEmpty) {
    return '—';
  }
  return t;
}

String _formatOrderDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return '—';
  }
  final dt = DateTime.tryParse(raw.trim());
  if (dt != null) {
    final y = dt.year.toString().padLeft(4, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$mo-$d $h:$min';
  }
  return raw.trim();
}

int? _parseIntArg(List<String> args, String flag) {
  final i = args.indexOf(flag);
  if (i < 0 || i + 1 >= args.length) {
    return null;
  }
  return int.tryParse(args[i + 1]);
}

/// Resolves the package root (directory containing `pubspec.yaml`) from cwd or
/// this script’s path, then loads the first existing `.env` among
/// `example/.env` (under that root), root `.env`, and cwd `.env`.
DotEnv _loadExampleDotEnv() {
  final env = DotEnv(includePlatformEnvironment: true, quiet: true);
  final root = _findPackageRoot();
  if (root != null) {
    final exampleEnv = File(p.join(root.path, 'example', '.env'));
    if (exampleEnv.existsSync()) {
      env.load([exampleEnv.path]);
      return env;
    }
    final packageEnv = File(p.join(root.path, '.env'));
    if (packageEnv.existsSync()) {
      env.load([packageEnv.path]);
      return env;
    }
  }
  final cwdEnv = File(p.join(Directory.current.path, '.env'));
  if (cwdEnv.existsSync()) {
    env.load([cwdEnv.path]);
    return env;
  }
  env.load();
  return env;
}

Directory? _findPackageRoot() {
  Directory? walk(Directory start) {
    var dir = start;
    for (var i = 0; i < 12; i++) {
      if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
        return dir;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break;
      }
      dir = parent;
    }
    return null;
  }

  final fromCwd = walk(Directory.current);
  if (fromCwd != null) {
    return fromCwd;
  }

  try {
    final scriptPath = Platform.script.toFilePath();
    return walk(Directory(p.dirname(scriptPath)));
  } catch (_) {
    return null;
  }
}
