/// Dart client for the Starshipit API (orders, labels, rates, tracking).
library;

export 'package:http/http.dart' show Response;

export 'package:starshipit/src/api/labels_api.dart';
export 'package:starshipit/src/api/orders_api.dart';
export 'package:starshipit/src/api/orders_list_query.dart';
export 'package:starshipit/src/api/rates_api.dart';
export 'package:starshipit/src/api/shipped_api.dart';
export 'package:starshipit/src/api/tracking_api.dart';
export 'package:starshipit/src/api/validate_api.dart';
export 'package:starshipit/src/config.dart';
export 'package:starshipit/src/exceptions/starshipit_exception.dart';
export 'package:starshipit/src/models/address.dart';
export 'package:starshipit/src/models/api_error.dart';
export 'package:starshipit/src/models/contact.dart';
export 'package:starshipit/src/models/create_order_request.dart';
export 'package:starshipit/src/models/error_response.dart';
export 'package:starshipit/src/models/line_item.dart';
export 'package:starshipit/src/models/metadata.dart';
export 'package:starshipit/src/models/order_details.dart';
export 'package:starshipit/src/models/order_envelope.dart';
export 'package:starshipit/src/models/order_statuses.dart';
export 'package:starshipit/src/models/orders_list_result.dart';
export 'package:starshipit/src/models/rates.dart';
export 'package:starshipit/src/models/shipment.dart';
export 'package:starshipit/src/models/shipped.dart';
export 'package:starshipit/src/models/starshipit_package.dart';
export 'package:starshipit/src/models/track_envelope.dart';
export 'package:starshipit/src/models/tracking_details.dart';
export 'package:starshipit/src/models/tracking_event.dart';
export 'package:starshipit/src/raw/starshipit_raw_client.dart';
export 'package:starshipit/src/starshipit_client.dart';
