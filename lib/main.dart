// Mini Katalog uygulamasi giris noktasi.
// MaterialApp, tema ayarlari, Named Routes ve state yonetimi burada tanimlanir.
import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'data/products_repository.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const MiniKatalogApp());
}

/// Uygulamanin kok widget'i - StatefulWidget ile favori state yonetimi saglar.
class MiniKatalogApp extends StatefulWidget {
  final ProductsRepository? repository;

  const MiniKatalogApp({super.key, this.repository});

  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  late final ProductsRepository _productsRepository;
  List<Product> _allProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _productsRepository = widget.repository ?? ProductsRepository();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productsRepository.loadProducts();
    if (!mounted) {
      return;
    }
    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
  }

  /// Urunun favori durumunu tersine cevirir ve setState ile UI'i gunceller.
  void _toggleFavorite(String productId) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _allProducts[index].isFavorite = !_allProducts[index].isFavorite;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(primary: AppColors.secondary, onPrimary: Colors.white, secondary: AppColors.accent, onSecondary: Colors.white, surface: AppColors.surface, onSurface: AppColors.textPrimary, error: AppColors.error, onError: Colors.white),
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.surface, foregroundColor: AppColors.textPrimary, elevation: 0, centerTitle: true),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: const TextStyle(color: AppColors.textPrimary),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ),
      home: HomeScreen(allProducts: _allProducts, onToggleFavorite: _toggleFavorite),

      /// Named Routes ile sayfa yonlendirmesi - onGenerateRoute kullanilir.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.productList:
            final args = settings.arguments as Map<String, dynamic>?;
            final category = args?['category'] as String?;
            return _buildRoute(ProductListScreen(allProducts: _allProducts, onToggleFavorite: _toggleFavorite, initialCategory: category));
          case AppRoutes.productDetail:
            final product = settings.arguments;
            if (product is! Product) {
              return _buildRoute(HomeScreen(allProducts: _allProducts, onToggleFavorite: _toggleFavorite));
            }
            return _buildRoute(ProductDetailScreen(product: product, onToggleFavorite: _toggleFavorite));
          case AppRoutes.favorites:
            return _buildRoute(FavoritesScreen(allProducts: _allProducts, onToggleFavorite: _toggleFavorite));
          default:
            return _buildRoute(HomeScreen(allProducts: _allProducts, onToggleFavorite: _toggleFavorite));
        }
      },
    );
  }

  /// Slide+Fade sayfa gecis animasyonu olusturur.
  Route _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.25, 0), end: Offset.zero).animate(curve),
          child: FadeTransition(opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curve), child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
