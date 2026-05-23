import 'package:flutter/material.dart';

import '../models/product.dart';

/// Categorías del e-commerce.
const List<Category> categories = [
  Category(id: 'all', name: 'Todos', icon: Icons.apps),
  Category(id: 'electronics', name: 'Electrónica', icon: Icons.devices),
  Category(id: 'clothing', name: 'Ropa', icon: Icons.checkroom),
  Category(id: 'home', name: 'Hogar', icon: Icons.home),
  Category(id: 'sports', name: 'Deportes', icon: Icons.sports_soccer),
];

/// Productos de ejemplo.
const List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Audífonos inalámbricos',
    price: 89.99,
    categoryId: 'electronics',
    icon: Icons.headphones,
  ),
  Product(
    id: '2',
    name: 'Smartwatch',
    price: 149.99,
    categoryId: 'electronics',
    icon: Icons.watch,
  ),
  Product(
    id: '3',
    name: 'Camiseta básica',
    price: 24.99,
    categoryId: 'clothing',
    icon: Icons.checkroom,
  ),
  Product(
    id: '4',
    name: 'Pantalón jeans',
    price: 59.99,
    categoryId: 'clothing',
    icon: Icons.checkroom,
  ),
  Product(
    id: '5',
    name: 'Lámpara LED',
    price: 34.99,
    categoryId: 'home',
    icon: Icons.lightbulb_outline,
  ),
  Product(
    id: '6',
    name: 'Set de sábanas',
    price: 45.99,
    categoryId: 'home',
    icon: Icons.bed,
  ),
  Product(
    id: '7',
    name: 'Balón de fútbol',
    price: 29.99,
    categoryId: 'sports',
    icon: Icons.sports_soccer,
  ),
  Product(
    id: '8',
    name: 'Mochila deportiva',
    price: 54.99,
    categoryId: 'sports',
    icon: Icons.backpack,
  ),
  Product(
    id: '9',
    name: 'Teclado mecánico',
    price: 119.99,
    categoryId: 'electronics',
    icon: Icons.keyboard,
  ),
];
