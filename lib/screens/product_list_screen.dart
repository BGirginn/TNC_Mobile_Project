// Urun listesi ekrani - Premium tasarim.
// Gradient header, glassmorphism arama, animasyonlu grid ve kategori filtreleme.
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../models/product.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final List<Product> allProducts;
  final Function(String) onToggleFavorite;
  final String? initialCategory;

  const ProductListScreen({super.key, required this.allProducts, required this.onToggleFavorite, this.initialCategory});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    var products = widget.allProducts;
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      products = products.where((p) {
        return p.name.toLowerCase().contains(lowerQuery) || p.description.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.allProducts.map((p) => p.category).toSet().toList()..sort();
    final filteredProducts = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(filteredProducts.length),
          SliverToBoxAdapter(child: _buildFilters(categories)),
          filteredProducts.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 14, mainAxisSpacing: 14),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = filteredProducts[index];
                      return FadeTransition(
                        opacity: _fadeAnim,
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
                          },
                          onFavoriteTap: () {
                            widget.onToggleFavorite(product.id);
                          },
                        ),
                      );
                    }, childCount: filteredProducts.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(int count) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.secondary.withValues(alpha: 0.12), AppColors.accent.withValues(alpha: 0.06), AppColors.background], stops: const [0.0, 0.5, 1.0]),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(56, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.secondary, AppColors.accentLight]).createShader(bounds),
                    child: const Text(
                      AppStrings.products,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('$count ürün listeleniyor', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.favorite_rounded, color: AppColors.accent, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(List<String> categories) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.15)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  cursorColor: AppColors.secondary,
                  decoration: InputDecoration(
                    hintText: AppStrings.search,
                    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 15),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.search_rounded, color: AppColors.secondary, size: 18),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 40),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.textLight, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategoryChip(label: AppStrings.allCategories, isSelected: _selectedCategory == null, onTap: () => setState(() => _selectedCategory = null)),
              ),
              ...categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategoryChip(
                    label: cat,
                    isSelected: _selectedCategory == cat,
                    onTap: () {
                      setState(() {
                        _selectedCategory = _selectedCategory == cat ? null : cat;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(Icons.search_off_rounded, size: 48, color: AppColors.textLight),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.noProducts,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text('Farklı bir arama deneyin', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
        ],
      ),
    );
  }
}
