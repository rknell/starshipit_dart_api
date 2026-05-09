/// Base URL must include trailing slash, e.g. `https://api.starshipit.com/api/`.
class StarshipitConfig {
  StarshipitConfig({
    required this.apiKey,
    required this.subscriptionKey,
    Uri? baseUri,
    this.userAgent = 'starshipit-dart/0.1.0',
  }) : baseUri = baseUri ?? defaultBaseUri;

  static final Uri defaultBaseUri = Uri.parse(
    'https://api.starshipit.com/api/',
  );

  /// StarShipIT-Api-Key — account API token (use a child-account token for multi-origin).
  final String apiKey;

  /// Ocp-Apim-Subscription-Key from the developer profile.
  final String subscriptionKey;

  /// API root; paths are resolved relative to this URI.
  final Uri baseUri;

  final String userAgent;

  static const defaultRequestsPerSecondLimit = 20;
}
