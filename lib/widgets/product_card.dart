// Urun karti widget'i - GridView icinde urun gosterimi icin kullanilir.
// Hero animasyonu, favori butonu, kategori etiketi ve yildiz puanlama icerir.
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_helpers.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ProductCard({super.key, required this.product, required this.onTap, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Urun gorseli, kategori etiketi ve favori butonu
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
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.25), Colors.transparent]),
                      ),
                    ),
                  ),
                  // Kategori etiketi
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black, letterSpacing: 0.2),
                      ),
                    ),
                  ),
                  // Favori butonu
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: product.isFavorite ? AppColors.accent : Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Urun adi, puan ve fiyat bilgisi
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(index < product.rating.floor() ? Icons.star_rounded : (index < product.rating ? Icons.star_half_rounded : Icons.star_border_rounded), size: 13, color: AppColors.starColor);
                        }),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
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
