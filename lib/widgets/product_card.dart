import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/product.dart';

/// Tarjeta de producto con tono de acento rotativo (estética Material You).
///
/// Reutilizada por las pestañas Inicio y Buscar. No conoce el carrito: avisa
/// vía [onAdd] / [onTap] para que cada vista decida qué hacer.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.accentIndex,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final int accentIndex;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final accent = _accentColors(scheme)[accentIndex % 3];

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent[0],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(product.icon, size: 52, color: accent[1]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.formattedPrice,
                    style: text.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: onAdd,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tres pares container/onContainer para dar color al grid.
List<List<Color>> _accentColors(ColorScheme scheme) => [
      [scheme.primaryContainer, scheme.onPrimaryContainer],
      [scheme.secondaryContainer, scheme.onSecondaryContainer],
      [scheme.tertiaryContainer, scheme.onTertiaryContainer],
    ];

/// Hoja inferior con el detalle del producto y botón para agregar al carrito.
Future<void> showProductSheet(
  BuildContext context, {
  required Product product,
  required VoidCallback onAdd,
}) {
  final scheme = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: scheme.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  product.icon,
                  size: 64,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.formattedPrice,
              style: text.titleLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Producto seleccionado de nuestra colección. Calidad garantizada '
              'y envío disponible a todo el país.',
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                onAdd();
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              label: const Text('Agregar al carrito'),
            ),
          ],
        ),
      );
    },
  );
}
