import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/state_views.dart';

/// Pestaña "Buscar": campo de búsqueda + resultados en vivo sobre el catálogo.
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(Product product) {
    context.read<CartProvider>().add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${product.name}" añadido al carrito'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final scheme = Theme.of(context).colorScheme;

    if (catalog.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (catalog.error != null) {
      return ErrorView(
        title: 'No se pudo cargar el catálogo',
        message: catalog.error!,
        onRetry: catalog.load,
      );
    }

    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? const <Product>[]
        : catalog.products
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: TextField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar productos',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _controller.clear();
                        _query = '';
                      }),
                    ),
              filled: true,
              fillColor: scheme.surfaceContainerHigh,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: scheme.primary, width: 2),
              ),
            ),
          ),
        ),
        Expanded(child: _buildResults(query, results, catalog.products.length)),
      ],
    );
  }

  Widget _buildResults(String query, List<Product> results, int total) {
    if (query.isEmpty) {
      return EmptyView(
        icon: Icons.search,
        title: 'Busca en la tienda',
        message: 'Escribe el nombre de un producto. Tenemos $total disponibles.',
      );
    }
    if (results.isEmpty) {
      return const EmptyView(
        icon: Icons.search_off,
        title: 'Sin resultados',
        message: 'No encontramos productos con ese nombre',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.70,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ProductCard(
          product: product,
          accentIndex: index,
          onTap: () => showProductSheet(
            context,
            product: product,
            onAdd: () => _add(product),
          ),
          onAdd: () => _add(product),
        );
      },
    );
  }
}
