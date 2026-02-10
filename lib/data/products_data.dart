// Mock urun verileri ve veri erisim katmani.
// assets/data/products.json dosyasindan veri okur.
// Filtreleme, arama ve kategorileme islevleri icerir.
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class ProductsData {
  /// Parse edilmis urun listesi - tekrar tekrar JSON parse etmeyi onler.
  static List<Product>? _cachedProducts;

  /// assets/data/products.json dosyasindan urunleri async olarak yukler.
  static Future<List<Product>> loadProductsFromJson() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    _cachedProducts = jsonList.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    return _cachedProducts!;
  }

  /// Tum benzersiz kategorileri alfabetik sirada dondurur.
  static List<String> getCategories(List<Product> products) {
    final cats = products.map((p) => p.category).toSet().toList();
    cats.sort();
    return cats;
  }

  /// Belirli bir kategoriye ait urunleri filtreler.
  static List<Product> getProductsByCategory(List<Product> products, String category) {
    return products.where((p) => p.category == category).toList();
  }

  /// Urun adi, aciklama ve kategoride arama yapar (trim ile temizlenir).
  static List<Product> searchProducts(List<Product> products, String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) return products;
    return products.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) || p.description.toLowerCase().contains(lowerQuery) || p.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Kategori ve arama sorgusuna gore birlestirip filtreler.
  static List<Product> filterProducts({required List<Product> products, String? category, String? searchQuery}) {
    var filtered = products;

    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final lowerQuery = searchQuery.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(lowerQuery) || p.description.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    return filtered;
  }
}
