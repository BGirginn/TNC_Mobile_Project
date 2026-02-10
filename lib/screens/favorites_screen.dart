// Favoriler ekrani - Premium tasarim.
// Gradient header, animasyonlu bos durum, Dismissible kartlar icerir.
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../constants/app_helpers.dart';
import '../models/product.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Product> allProducts;
  final Function(String) onToggleFavorite;

  const FavoritesScreen({super.key, required this.allProducts, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = allProducts.where((p) => p.isFavorite).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(favoriteProducts.length),
          favoriteProducts.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = favoriteProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Dismissible(
                          key: Key(product.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => onToggleFavorite(product.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.transparent, AppColors.accent.withValues(alpha: 0.3)]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_rounded, color: AppColors.accent, size: 28),
                                SizedBox(height: 4),
                                Text(
                                  'Kaldır',
                                  style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          child: _buildFavoriteItem(context, product),
                        ),
                      );
                    }, childCount: favoriteProducts.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(int count) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.accent.withValues(alpha: 0.15), AppColors.secondary.withValues(alpha: 0.06), AppColors.background], stops: const [0.0, 0.5, 1.0]),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(56, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.accent, AppColors.accentLight]).createShader(bounds),
                    child: const Text(
                      AppStrings.favorites,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(count > 0 ? '$count ürün favorilerde' : 'Henüz favori eklenmedi', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppColors.accent.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.05)]),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
            ),
            child: Icon(Icons.favorite_border_rounded, size: 56, color: AppColors.accent.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.noFavorites,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text('Ürünlere göz atarak favorilerinize ekleyin', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Urun gorseli
            Hero(
              tag: 'product-image-${product.id}',
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                  child: buildProductImage(imagePath: product.imagePath, category: product.category, fallbackIconSize: 36, fallbackIconColor: AppColors.secondary),
                ),
              ),
            ),

            // Urun bilgileri
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori etiketi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    // Yildiz
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(i < product.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded, size: 14, color: AppColors.starColor);
                        }),
                        const SizedBox(width: 4),
                        Text(product.rating.toStringAsFixed(1), style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppStrings.currency}${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ),

            // Favori butonu
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onToggleFavorite(product.id),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_rounded, color: AppColors.accent, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
