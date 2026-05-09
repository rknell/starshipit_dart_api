# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-05-09

### Added

- `StarshipitClient` facade with typed APIs: `orders`, `rates`, `labels`, `tracking`, `shipped`, `validate`, and `raw` for unwrapped HTTP.
- Orders: create/update, get by id or order number, list with `page_number` / `page_size`, `listUnshipped`, `listShipped`, `listShipments`, `listDelivered`, `summary`, search.
- Rates: `POST /rates` (`quote` / `shippingQuote`) and `POST /deliveryservices` (`deliveryServices`) with `DeliveryServicesRequest`.
- Labels: `POST /orders/shipment` with `ShipmentResponse` supporting `labels`, `tracking_numbers`, `label_types`.
- Tracking-only orders: `POST /orders/shipped` via `ShippedApi`.
- Tracking: `GET /track` by tracking number and/or order number; list-shaped `results` parsing.
- Connectivity helper: `GET /health` via `validate` (not part of published OpenAPI; useful for key checks).
- JSON models with `json_serializable`; `StarshipitException` for API errors.
- Unit tests with mocks; optional integration tests tagged `integration` (Plain Label–safe lifecycle checks).

[0.1.0]: https://github.com/rknell/starshipit_dart_api/releases/tag/v0.1.0
