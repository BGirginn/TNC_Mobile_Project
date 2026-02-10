// Urun detay ekrani - Premium tasarim.
// Gradient overlay SliverAppBar, Hero animasyonu, ShaderMask fiyat,
// animasyonlu bilgi satirlari ve favori toggle icerir.
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_helpers.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(String) onToggleFavorite;

  const ProductDetailScreen({super.key, required this.product, required this.onToggleFavorite});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(opacity: _fadeAnim, child: _buildProductInfo(context)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Urun gorseli
            Hero(
              tag: 'product-image-${widget.product.id}',
              child: Container(
                color: AppColors.surfaceLight,
                child: buildProductImage(imagePath: widget.product.imagePath, category: widget.product.category, fallbackIconSize: 80, fallbackIconColor: AppColors.secondary),
              ),
            ),
            // Alt gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [AppColors.background, AppColors.background.withValues(alpha: 0.6), Colors.transparent], stops: const [0.0, 0.4, 1.0]),
                ),
              ),
            ),
            // Ust gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent]),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            widget.onToggleFavorite(widget.product.id);
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(widget.product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: widget.product.isFavorite ? AppColors.accent : Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      transform: Matrix4.translationValues(0, -28, 0),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori ve puan
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  widget.product.category,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 0.3),
                ),
              ),
              const SizedBox(width: 12),
              ...List.generate(5, (index) {
                return Icon(index < widget.product.rating.floor() ? Icons.star_rounded : (index < widget.product.rating ? Icons.star_half_rounded : Icons.star_border_rounded), size: 18, color: AppColors.starColor);
              }),
              const SizedBox(width: 6),
              Text(
                widget.product.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Urun adi
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2),
          ),
          const SizedBox(height: 12),

          // Fiyat - ShaderMask gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.secondary, AppColors.secondaryLight]).createShader(bounds),
            child: Text(
              '${AppStrings.currency}${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Aciklama Bolumu
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.secondary, AppColors.accent]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.description,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(widget.product.description, style: const TextStyle(fontSize: 15, height: 1.7, color: AppColors.textSecondary, letterSpacing: 0.2)),
          const SizedBox(height: 28),

          // Bilgi satirlari
          _buildInfoRow(Icons.local_shipping_outlined, 'Ücretsiz Kargo', 'Tüm siparişlerde geçerli'),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.verified_outlined, '2 Yıl Garanti', 'Resmi distribütör garantisi'),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.replay_outlined, '14 Gün İade', 'Koşulsuz iade hakkı'),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.secondary.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.08)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: AppColors.secondary),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Fiyat bolumu
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Toplam Fiyat', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 2),
                  Text(
                    '${AppStrings.currency}${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
            // Favori butonu
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  final wasAdded = !widget.product.isFavorite;
                  widget.onToggleFavorite(widget.product.id);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(wasAdded ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(wasAdded ? AppStrings.addToFavorites : AppStrings.removeFromFavorites)),
                        ],
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.surfaceLight,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.product.isFavorite ? [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)] : [AppColors.secondary, AppColors.secondaryLight]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: (widget.product.isFavorite ? AppColors.accent : AppColors.secondary).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.isFavorite ? AppStrings.removeFromFavorites : AppStrings.addToFavorites,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
