// Ana sayfa ekrani - Premium modern tasarim.
// Animasyonlu header, glassmorphism arama, modern kategori kartlari
// ve buyuk one cikan urun kartlari icerir.
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../constants/app_helpers.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  final List<Product> allProducts;
  final Function(String) onToggleFavorite;

  const HomeScreen({super.key, required this.allProducts, required this.onToggleFavorite});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final AnimationController _contentController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _contentController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));
    _contentFade = CurvedAnimation(parent: _contentController, curve: Curves.easeOut);

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredProducts = widget.allProducts.take(6).toList();
    final categories = widget.allProducts.map((p) => p.category).toSet().toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _contentFade,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 24), _buildSearchBar(context), const SizedBox(height: 32), _buildCategoriesSection(categories), const SizedBox(height: 32), _buildFeaturedSection(featuredProducts), const SizedBox(height: 32), _buildAllProductsGrid(), const SizedBox(height: 24)]),
            ),
          ),
        ],
      ),
    );
  }

  /// Animasyonlu gradient header - SliverAppBar ile dinamik boyut.
  Widget _buildSliverHeader() {
    final favoriteCount = widget.allProducts.where((p) => p.isFavorite).length;

    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: SlideTransition(
          position: _headerSlide,
          child: FadeTransition(
            opacity: _headerFade,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.secondary.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.08), AppColors.background], stops: const [0.0, 0.5, 1.0]),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hoş Geldiniz 👋', style: TextStyle(fontSize: 15, color: AppColors.textSecondary, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.secondary, AppColors.accentLight]).createShader(bounds),
                                  child: const Text(
                                    AppStrings.appName,
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('${widget.allProducts.length} ürün keşfet', style: TextStyle(fontSize: 13, color: AppColors.textLight, letterSpacing: 0.3)),
                              ],
                            ),
                          ),
                          _buildFavoritesButton(favoriteCount),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Favoriler butonu - parlayan vurgu efekti.
  Widget _buildFavoritesButton(int favoriteCount) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.accent.withValues(alpha: 0.08)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        child: Badge(
          label: Text('$favoriteCount', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.accent,
          isLabelVisible: favoriteCount > 0,
          child: const Icon(Icons.favorite_rounded, color: AppColors.accent, size: 22),
        ),
      ),
    );
  }

  /// Glassmorphism arama cubugu.
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.productList),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.search_rounded, color: AppColors.secondary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(AppStrings.search, style: TextStyle(color: AppColors.textLight, fontSize: 15, letterSpacing: 0.3)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.tune_rounded, color: AppColors.secondary, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Modern kategori kartlari - glassmorphism ile yatay kaydirma.
  Widget _buildCategoriesSection(List<String> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.secondary, AppColors.accent]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                AppStrings.categories,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.productList, arguments: {'category': category});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.secondary.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.08)]),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(getCategoryIcon(category), color: AppColors.secondary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// One cikan urunler - buyuk kartlarla yatay kaydirma.
  Widget _buildFeaturedSection(List<Product> featuredProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.secondary, AppColors.accent]),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AppStrings.featuredProducts,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.3),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.productList);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    AppStrings.seeAll,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary, letterSpacing: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return _buildFeaturedCard(product, index);
            },
          ),
        ),
      ],
    );
  }

  /// Tekil one cikan urun karti - buyuk gorsel, gradient overlay.
  Widget _buildFeaturedCard(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gorsel alani
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product-image-${product.id}',
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: buildProductImage(imagePath: product.imagePath, category: product.category, fallbackIconSize: 48, fallbackIconColor: AppColors.secondary),
                        ),
                      ),
                    ),
                    // Ust gradient overlay
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent]),
                        ),
                      ),
                    ),
                    // Favori butonu
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => widget.onToggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: product.isFavorite ? AppColors.accent : Colors.white, size: 18),
                        ),
                      ),
                    ),
                    // Kategori etiketi
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          product.category,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black, letterSpacing: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bilgi alani
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2),
                      ),
                      Row(
                        children: [
                          // Yildiz rating
                          ...List.generate(5, (i) {
                            return Icon(i < product.rating.floor() ? Icons.star_rounded : (i < product.rating ? Icons.star_half_rounded : Icons.star_border_rounded), size: 14, color: AppColors.starColor);
                          }),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      // Fiyat
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.secondary, AppColors.secondaryLight]).createShader(bounds),
                        child: Text(
                          '${AppStrings.currency}${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tum urunlerin grid gorunumu.
  Widget _buildAllProductsGrid() {
    if (widget.allProducts.length <= 6) return const SizedBox.shrink();

    final remainingProducts = widget.allProducts.skip(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.secondary, AppColors.accent]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Daha Fazla Ürün',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: remainingProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 14, mainAxisSpacing: 14),
            itemBuilder: (context, index) {
              final product = remainingProducts[index];
              return _buildGridCard(product);
            },
          ),
        ),
      ],
    );
  }

  /// Grid urun karti.
  Widget _buildGridCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: buildProductImage(imagePath: product.imagePath, category: product.category, fallbackIconSize: 36, fallbackIconColor: AppColors.secondary),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => widget.onToggleFavorite(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                        child: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: product.isFavorite ? AppColors.accent : Colors.white70, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.starColor),
                        const SizedBox(width: 3),
                        Text(product.rating.toStringAsFixed(1), style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    Text(
                      '${AppStrings.currency}${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
