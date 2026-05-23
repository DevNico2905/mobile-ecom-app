import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/login_provider.dart';
import '../../providers/theme_provider.dart';
import '../login_screen.dart';

/// Pestaña "Perfil": datos de la cuenta, preferencias y cierre de sesión.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Próximamente')),
      );
  }

  void _logout(BuildContext context) {
    context.read<CartProvider>().clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final login = context.watch<LoginProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final username = login.username.isNotEmpty ? login.username : 'Usuario';
    final email = login.email.isNotEmpty ? login.email : 'Sin correo';
    final initial = username.characters.first.toUpperCase();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        // Cabecera con avatar
        Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                initial,
                style: text.displaySmall?.copyWith(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Preferencias
        _SectionCard(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Modo oscuro'),
              value: themeProvider.isDark(context),
              onChanged: (_) => themeProvider.toggle(context),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Opciones de cuenta (decorativas por ahora)
        _SectionCard(
          children: [
            _OptionTile(
              icon: Icons.receipt_long_outlined,
              label: 'Mis pedidos',
              onTap: () => _comingSoon(context),
            ),
            _Divider(scheme: scheme),
            _OptionTile(
              icon: Icons.location_on_outlined,
              label: 'Direcciones',
              onTap: () => _comingSoon(context),
            ),
            _Divider(scheme: scheme),
            _OptionTile(
              icon: Icons.help_outline,
              label: 'Ayuda y soporte',
              onTap: () => _comingSoon(context),
            ),
          ],
        ),
        const SizedBox(height: 32),

        OutlinedButton.icon(
          onPressed: () => _logout(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.error,
            side: BorderSide(color: scheme.error.withValues(alpha: 0.4)),
          ),
          icon: const Icon(Icons.logout, size: 20),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}

/// Tarjeta tonal que agrupa filas de opciones.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(children: children),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: scheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}
