// WantAPI urun verileri servisi.
// https://www.wantapi.com/products.php adresinden urun verilerini ceker.
// Yanit formati: { "status": "success", "data": [...] }
import 'dart:convert';
import 'dart:io';

import '../config/wantapi_config.dart';
import '../models/product.dart';

class ProductsApiService {
  final HttpClient _client;

  ProductsApiService({HttpClient? client}) : _client = client ?? HttpClient();

  /// WantAPI'den urunleri ceker ve Product listesine donusturur.
  Future<List<Product>> fetchProducts() async {
    final request = await _client.getUrl(WantApiConfig.productsUri);
    WantApiConfig.headers.forEach(request.headers.set);
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('WantAPI error: ${response.statusCode}');
    }

    final decoded = jsonDecode(responseBody);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected WantAPI response format');
    }

    // status kontrolu
    if (decoded['status'] != 'success') {
      throw Exception('WantAPI returned status: ${decoded['status']}');
    }

    final rawProducts = decoded['data'];
    if (rawProducts is! List<dynamic>) {
      throw Exception('WantAPI data is not a list');
    }

    return rawProducts.map(_toProduct).toList();
  }

  /// WantAPI JSON formatindan Product nesnesine donusturur.
  /// API alanlari: id, name, tagline, description, price("$999"),
  /// currency, image(URL), specs
  Product _toProduct(dynamic raw) {
    if (raw is! Map) {
      throw Exception('Invalid product entry');
    }

    final map = Map<String, dynamic>.from(raw);

    final id = (map['id'] ?? '').toString();
    final name = (map['name'] ?? 'Ürün').toString();

    // tagline ve description birlestir
    final tagline = (map['tagline'] ?? '').toString();
    final desc = (map['description'] ?? '').toString();
    final description = tagline.isNotEmpty ? '$tagline\n\n$desc' : desc;

    // Kategori: specs icerigine gore otomatik atama
    final category = _detectCategory(name);

    // Gorsel: WantAPI 'image' alanini kullanir (URL)
    final imagePath = (map['image'] ?? '').toString();

    // Fiyat: "$999" veya "$1,299" formatindan double'a cevir
    final price = _parsePrice(map['price']);

    // Rating: WantAPI'de yok, varsayilan 4.5
    final rating = _toDouble(map['rating'] ?? 4.5);

    return Product(id: id.isEmpty ? DateTime.now().microsecondsSinceEpoch.toString() : id, name: name, description: description, price: price, category: category, imagePath: imagePath, rating: rating, isFavorite: (map['isFavorite'] as bool?) ?? false);
  }

  /// Urun adina gore kategori tahmini yapar.
  String _detectCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('iphone') || lower.contains('ipad')) {
      return 'iPhone & iPad';
    }
    if (lower.contains('macbook') || lower.contains('imac')) {
      return 'Mac';
    }
    if (lower.contains('watch')) {
      return 'Apple Watch';
    }
    if (lower.contains('airpods') || lower.contains('homepod')) {
      return 'Ses & Aksesuarlar';
    }
    if (lower.contains('pencil') || lower.contains('keyboard') || lower.contains('magic') || lower.contains('airtag') || lower.contains('vision')) {
      return 'Aksesuarlar';
    }
    return 'Diğer';
  }

  /// "$999" veya "$1,299" gibi string fiyatlari double'a cevirir.
  double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    final str = value.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(str) ?? 0.0;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
