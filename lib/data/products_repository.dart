import '../config/wantapi_config.dart';
import '../models/product.dart';
import 'products_api_service.dart';
import 'products_data.dart';

class ProductsRepository {
  final ProductsApiService _apiService;

  ProductsRepository({ProductsApiService? apiService}) : _apiService = apiService ?? ProductsApiService();

  Future<List<Product>> loadProducts() async {
    if (!WantApiConfig.isConfigured) {
      return ProductsData.loadProductsFromJson();
    }

    try {
      final remoteProducts = await _apiService.fetchProducts();
      if (remoteProducts.isNotEmpty) {
        return remoteProducts;
      }
    } catch (_) {
      // Fall back to local products if WantAPI is unavailable.
    }

    return ProductsData.loadProductsFromJson();
  }
}
