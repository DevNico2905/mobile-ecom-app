import 'package:flutter/foundation.dart' hide Category;

import '../models/product.dart';
import '../services/catalog_service.dart';

/// Carga y mantiene el catálogo (productos y categorías) desde el backend.
///
/// Lo consumen las pestañas Inicio y Buscar. La carga arranca al crearse el
/// provider (la primera vez que alguien lo lee) y puede reintentarse con
/// [load].
class CatalogProvider extends ChangeNotifier {
  CatalogProvider() {
    load();
  }

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _loading = true;
  String? _error;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await CatalogService.fetchProducts();
      _categories = await CatalogService.fetchCategories();
    } catch (_) {
      _error = 'No se pudo cargar el catálogo. Revisa que el backend esté '
          'encendido en http://localhost:3000.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
