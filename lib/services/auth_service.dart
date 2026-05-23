import 'dart:convert';

import 'package:dio/dio.dart';

class AuthService {
  // Ajusta baseUrl si usas emulador Android (10.0.2.2) u otro host.
  static const String _baseUrl = 'http://localhost:3000/api';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Registra un nuevo usuario en el backend (Node + MySQL).
  /// Devuelve true si se registró correctamente, false si ya existe o hubo error controlado.
  static Future<bool> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: jsonEncode({
          'username': username.trim(),
          'fullName': fullName.trim(),
          'email': email.trim(),
          'password': password,
        }),
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      // 409 = usuario/correo ya registrado.
      if (e.response?.statusCode == 409) {
        return false;
      }
      // Para cualquier otro error (conexión, 500, etc.) devolvemos false
      // para que la UI no se quede cargando.
      return false;
    }
  }

  /// Verifica credenciales contra el backend.
  /// Devuelve true si el email/contraseña son correctos.
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 401) {
        return false;
      }
      // Cualquier otro error (por ejemplo el servidor no responde)
      // se interpreta como login inválido para no bloquear la UI.
      return false;
    }
  }
}

