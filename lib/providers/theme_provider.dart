import 'package:flutter/material.dart';

/// Maneja el modo de tema (claro / oscuro / sistema) y permite alternarlo.
///
/// Arranca siguiendo el sistema; al pulsar el toggle pasa a un modo explícito
/// (claro u oscuro) calculado a partir del brillo efectivo en pantalla.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  /// Brillo efectivo actual (resuelve `system` con el brillo de la plataforma).
  bool isDark(BuildContext context) {
    if (_mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  /// Alterna entre claro y oscuro respecto a lo que se ve ahora mismo.
  void toggle(BuildContext context) {
    _mode = isDark(context) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
