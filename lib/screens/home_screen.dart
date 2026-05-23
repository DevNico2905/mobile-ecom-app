import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/theme_toggle_button.dart';
import 'tabs/cart_tab.dart';
import 'tabs/catalog_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/search_tab.dart';

/// Shell de la app autenticada: AppBar + 4 pestañas con [NavigationBar].
///
/// Cada pestaña es una vista independiente (Inicio, Buscar, Carrito, Perfil).
/// Se usa [IndexedStack] para conservar el estado de cada una al cambiar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _tabs = [CatalogTab(), SearchTab(), CartTab(), ProfileTab()];
  static const _titles = ['Tienda', 'Buscar', 'Carrito', 'Perfil'];

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cartCount = context.watch<CartProvider>().totalCount;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: _index == 0
            ? Row(
                children: [
                  Icon(Icons.storefront_outlined,
                      color: scheme.primary, size: 26),
                  const SizedBox(width: 8),
                  const Text('Tienda'),
                ],
              )
            : Text(_titles[_index]),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Carrito',
            onPressed: () => _select(2),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Carrito',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
