import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Una línea del carrito: un producto y su cantidad.
class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.price * quantity;
}

/// Estado global del carrito de compras (en memoria).
///
/// Lo comparten el catálogo/búsqueda (agregar), la insignia del AppBar y la
/// pestaña Carrito (ver, modificar cantidades, eliminar).
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // clave: product.id

  List<CartItem> get items => _items.values.toList(growable: false);
  bool get isEmpty => _items.isEmpty;

  /// Suma de cantidades (para la insignia).
  int get totalCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Importe total del carrito.
  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  String get formattedTotal => '\$${totalPrice.toStringAsFixed(0)}';

  void add(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void increment(String productId) {
    final item = _items[productId];
    if (item == null) return;
    item.quantity++;
    notifyListeners();
  }

  /// Resta una unidad; si llega a 0, elimina la línea.
  void decrement(String productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
