// Mini Katalog uygulamasi icin widget ve birim testleri.
// Product model, ProductsData ve uygulama widget testlerini icerir.
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/data/products_data.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson creates product correctly', () {
      final json = {'id': '1', 'name': 'Test Ürün', 'description': 'Test açıklama', 'price': 99.99, 'category': 'Elektronik', 'imagePath': 'assets/images/test.png', 'rating': 4.5, 'isFavorite': false};

      final product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.name, 'Test Ürün');
      expect(product.price, 99.99);
      expect(product.category, 'Elektronik');
      expect(product.rating, 4.5);
      expect(product.isFavorite, false);
    });

    test('Product.toJson converts product correctly', () {
      final product = Product(id: '1', name: 'Test', description: 'Desc', price: 50.0, category: 'Giyim', imagePath: 'test.png', rating: 3.0);

      final json = product.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test');
      expect(json['price'], 50.0);
      expect(json['isFavorite'], false);
    });

    test('Product.copyWith works correctly', () {
      final product = Product(id: '1', name: 'Test', description: 'Desc', price: 50.0, category: 'Giyim', imagePath: 'test.png');

      final updated = product.copyWith(isFavorite: true, price: 100.0);

      expect(updated.isFavorite, true);
      expect(updated.price, 100.0);
      expect(updated.name, 'Test');
    });
  });

  group('ProductsData Tests', () {
    // Test verisi - JSON dosyasindan bagimsiz birim testi icin
    final sampleProducts = [Product(id: '1', name: 'Kablosuz Kulaklık', description: 'Bluetooth kulaklık', price: 1299.99, category: 'Elektronik', imagePath: 'assets/images/headphones.png', rating: 4.5), Product(id: '2', name: 'Akıllı Saat', description: 'Nabız ölçer saat', price: 2499.99, category: 'Elektronik', imagePath: 'assets/images/smartwatch.png', rating: 4.8), Product(id: '3', name: 'Deri Cüzdan', description: 'El yapımı cüzdan', price: 449.99, category: 'Aksesuar', imagePath: 'assets/images/wallet.png', rating: 4.2), Product(id: '4', name: 'Spor Ayakkabı', description: 'Hafif ayakkabı', price: 899.99, category: 'Giyim', imagePath: 'assets/images/shoes.png', rating: 4.6), Product(id: '5', name: 'Masa Lambası', description: 'LED lamba', price: 349.99, category: 'Ev & Yaşam', imagePath: 'assets/images/lamp.png', rating: 4.1)];

    test('getCategories returns correct categories', () {
      final categories = ProductsData.getCategories(sampleProducts);
      expect(categories.contains('Elektronik'), true);
      expect(categories.contains('Giyim'), true);
      expect(categories.contains('Aksesuar'), true);
      expect(categories.contains('Ev & Yaşam'), true);
      expect(categories.length, 4);
    });

    test('getProductsByCategory filters correctly', () {
      final electronics = ProductsData.getProductsByCategory(sampleProducts, 'Elektronik');
      expect(electronics.every((p) => p.category == 'Elektronik'), true);
      expect(electronics.length, 2);
    });

    test('searchProducts searches name and description', () {
      final results = ProductsData.searchProducts(sampleProducts, 'kulaklık');
      expect(results.isNotEmpty, true);
      expect(results.first.name, 'Kablosuz Kulaklık');
    });

    test('filterProducts with category and search', () {
      final results = ProductsData.filterProducts(products: sampleProducts, category: 'Elektronik', searchQuery: 'saat');
      expect(results.isNotEmpty, true);
      expect(results.first.category, 'Elektronik');
    });
  });

  group('App Widget Tests', () {
    testWidgets('App renders home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MiniKatalogApp());
      await tester.pumpAndSettle();

      expect(find.text('Mini Katalog'), findsOneWidget);
      expect(find.text('Hoş Geldiniz 👋'), findsOneWidget);
    });

    testWidgets('Home shows categories section', (WidgetTester tester) async {
      await tester.pumpWidget(const MiniKatalogApp());
      await tester.pumpAndSettle();

      expect(find.text('Kategoriler'), findsOneWidget);
    });

    testWidgets('Tapping search navigates to product list', (WidgetTester tester) async {
      await tester.pumpWidget(const MiniKatalogApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ürün ara...'));
      await tester.pumpAndSettle();

      expect(find.text('Ürünler'), findsOneWidget);
    });
  });
}
