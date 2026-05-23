import 'package:flutter/material.dart';

import '../core/product_icons.dart';

/// Modelo de producto para el e-commerce.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.icon = Icons.shopping_bag,
  });

  /// Crea un producto a partir del JSON del backend (`GET /api/products`).
  ///
  /// Nota: MySQL devuelve `price` (DECIMAL) como String vía mysql2, por eso se
  /// acepta tanto `num` como `String`.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String,
      price: _toDouble(json['price']),
      categoryId: json['category_id'] as String,
      icon: iconFromName(json['icon_name'] as String?),
    );
  }

  final String id;
  final String name;
  final double price;
  final String categoryId;
  final IconData icon;

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

/// Categoría del catálogo.
class Category {
  const Category({required this.id, required this.name, required this.icon});

  /// Crea una categoría a partir del JSON del backend (`GET /api/categories`).
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: iconFromName(json['icon_name'] as String?),
    );
  }

  final String id;
  final String name;
  final IconData icon;
}
