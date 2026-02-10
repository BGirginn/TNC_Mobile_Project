/// WantAPI yapilandirma sabitleri.
/// API baglantisi varsayilan olarak aktiftir.
/// Lokal JSON veriye fallback destegi vardir.
class WantApiConfig {
  static const String baseUrl = 'https://www.wantapi.com';
  static const String productsPath = '/products.php';

  /// API her zaman aktif - baglanti hatalarinda lokal veriye doner.
  static bool get isConfigured => baseUrl.isNotEmpty;

  static Uri get productsUri => Uri.parse('$baseUrl$productsPath');

  static Map<String, String> get headers {
    return {'Accept': 'application/json', 'Content-Type': 'application/json'};
  }
}
