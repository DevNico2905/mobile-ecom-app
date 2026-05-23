import 'package:flutter/material.dart';

/// Traduce el `icon_name` que llega de la base de datos (texto) al `IconData`
/// correspondiente de Material.
///
/// Se usa un mapa explícito (en vez de `IconData(codePoint)`) para no romper
/// el *tree-shaking* de iconos en compilaciones release/web. Si en la BD
/// aparece un nombre que no está aquí, se usa [_fallback].
const IconData _fallback = Icons.devices_other;

const Map<String, IconData> _iconByName = {
  // Categorías / productos tecnológicos
  'smartphone': Icons.smartphone,
  'laptop': Icons.laptop,
  'laptop_mac': Icons.laptop_mac,
  'headphones': Icons.headphones,
  'speaker': Icons.speaker,
  'sports_esports': Icons.sports_esports,
  'videogame_asset': Icons.videogame_asset,
  'view_in_ar': Icons.view_in_ar,
  'headset_mic': Icons.headset_mic,
  'keyboard': Icons.keyboard,
  'mouse': Icons.mouse,
  'watch': Icons.watch,
  'monitor_heart': Icons.monitor_heart,
  'visibility': Icons.visibility,
  'devices': Icons.devices,
  // Filtro "Todos" de la UI
  'apps': Icons.apps,
};

/// Devuelve el icono para [name], o un icono por defecto si no se reconoce.
IconData iconFromName(String? name) {
  if (name == null || name.isEmpty) return _fallback;
  return _iconByName[name] ?? _fallback;
}
