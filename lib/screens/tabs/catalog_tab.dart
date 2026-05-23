import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/catalog_provider.dart';
import '../../providers/login_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/state_views.dart';

/// Pestaña "Inicio": catálogo navegable por categoría.
class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  String _selectedCategoryId = 'all';

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
    final text = Theme.of(context).textTheme;

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

    final username = context.watch<LoginProvider>().username;
    final chips = <Category>[
      const Category(id: 'all', name: 'Todos', icon: Icons.apps),
      ...catalog.categories,
    ];
    final products = _selectedCategoryId == 'all'
        ? catalog.products
        : catalog.products
            .where((p) => p.categoryId == _selectedCategoryId)
            .toList();

    return RefreshIndicator(
      onRefresh: catalog.load,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, ${username.isNotEmpty ? username : 'Usuario'} 👋',
                    style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descubre productos seleccionados para ti',
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PromoCard(scheme: scheme, text: text),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = chips[index];
                  final selected = _selectedCategoryId == category.id;
                  return FilterChip(
                    selected: selected,
                    showCheckmark: false,
                    avatar: Icon(
                      category.icon,
                      size: 18,
                      color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurfaceVariant,
                    ),
                    label: Text(category.name),
                    onSelected: (_) =>
                        setState(() => _selectedCategoryId = category.id),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.inventory_2_outlined,
                title: 'Sin productos',
                message: 'No hay productos en esta categoría todavía',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 210,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
              ),
            ),
        ],
      ),
    );
  }
}

/// Banner promocional tonal en la cabecera del catálogo.
class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.scheme, required this.text});

  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Envío gratis',
                  style: text.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'En tu primera compra de la temporada',
                  style: text.bodySmall?.copyWith(
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_shipping_outlined,
            size: 40,
            color: scheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}
