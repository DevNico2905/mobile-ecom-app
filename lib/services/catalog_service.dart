import 'package:dio/dio.dart';

import '../models/product.dart';

/// Lee el catálogo (productos y categorías) desde el backend (Node + MySQL).
///
/// Mismo `baseUrl` que [AuthService]; ajusta a `10.0.2.2` si usas emulador
/// Android. Lanza una excepción si el servidor no responde, para que la UI
/// pueda mostrar un estado de error con opción de reintentar.
class CatalogService {
  static const String _baseUrl = 'http://localhost:3000/api';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// `GET /api/products` → lista de productos.
  static Future<List<Product>> fetchProducts() async {
    final response = await _dio.get<List<dynamic>>('/products');
    final data = response.data ?? const [];
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /api/categories` → lista de categorías.
  static Future<List<Category>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>('/categories');
    final data = response.data ?? const [];
    return data
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
