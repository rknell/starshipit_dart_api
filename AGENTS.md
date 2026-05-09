# Agent / LLM guide — `starshipit` Dart package

Use this file when editing or extending the client with automation (Cursor, Codex, etc.).

## Architecture

- **Public barrel:** [`lib/starshipit.dart`](lib/starshipit.dart) — re-exports APIs, models, `StarshipitClient`, `StarshipitRawClient`.
- **Facade:** [`lib/src/starshipit_client.dart`](lib/src/starshipit_client.dart) — holds `orders`, `rates`, `labels`, `tracking`, `shipped`, `validate`, `raw`.
- **HTTP:** [`lib/src/http/auth_http_client.dart`](lib/src/http/auth_http_client.dart) — adds `StarShipIT-Api-Key`, `Ocp-Apim-Subscription-Key`, throws `StarshipitException` on errors.
- **Typed APIs:** `lib/src/api/*.dart` — one class per surface (`OrdersApi`, `RatesApi`, …). Paths are relative strings (e.g. `'orders/unshipped'`) resolved against `StarshipitConfig.baseUri`.
- **Models:** `lib/src/models/*.dart` — many use `json_annotation` + generated `*.g.dart` **part** files.

## Generated code

- Files matching `lib/src/models/*.g.dart` are **generated**. Do not hand-edit them.
- After changing `@JsonSerializable` classes or `part 'foo.g.dart'` models, run from package root:

  ```bash
  dart run build_runner build
  ```

## Tests

- **Default / CI:** `dart test --exclude-tags integration` — mocked HTTP, no credentials.
- **Integration:** tests under `test/integration/` use `tags: ['integration']`. They call the live API when `STARSHIPIT_API_KEY` and `STARSHIPIT_SUBSCRIPTION_KEY` are set (see `test/support/integration_dotenv.dart`).
- Timeout multiplier for integration: [`dart_test.yaml`](dart_test.yaml).

## Safety and Starshipit etiquette

- **Never** add examples, integration tests, or agent scripts that create **paid carrier labels** or manifest real billable shipments without explicit human approval.
- Lifecycle integration tests are **Plain Label only** (see `test/support/plain_label_carrier.dart`). Optional env: `STARSHIPIT_PLAIN_LABEL_CARRIER_ID`, `STARSHIPIT_PLAIN_LABEL_SHIPPING_METHOD`.
- Prefer **rates** (`POST /rates`) and **delivery services** (`POST /deliveryservices`) for “live” checks that must not spend label quota.
- `StarshipitConfig.defaultRequestsPerSecondLimit` documents a conservative default; respect tenant and API limits.

## `validate` vs documented API

- `ValidateApi.validate()` calls **`GET /health`**. This is a practical connectivity check; it is **not** listed in the published Starshipit OpenAPI/Postman surface. Do not assume every tenant documents it.

## Adding a new typed endpoint

1. Prefer extending the existing `*Api` class in `lib/src/api/`.
2. Add or extend models with `json_serializable` where appropriate; run `build_runner`.
3. Export new types from `lib/starshipit.dart` if they are public API.
4. Add a **mocked** unit test (see `test/*_api_test.dart`).
5. Update [`README.md`](README.md) endpoint matrix.
6. Add integration tests only if **cost-safe** and aligned with Plain Label / read-only rules above.

## Raw fallback

- [`StarshipitRawClient`](lib/src/raw/starshipit_raw_client.dart) exposes `get` / `post` / `put` / `delete` with the same auth as typed APIs. Use for undocumented or not-yet-wrapped routes; return type is `package:http` `Response` — callers parse JSON.

## Secrets

- Before commit or push: ensure `.env` is **not** tracked (`git status`). The package `.gitignore` excludes `.env`.
- Do not paste real API keys into README, AGENTS.md, or issues.

## Commands checklist

```bash
dart analyze
dart test --exclude-tags integration
dart pub publish --dry-run
```
