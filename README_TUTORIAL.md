# Tutorial paso a paso: App E-commerce en Flutter

Este tutorial está pensado para **quien nunca ha programado**. Si sigues cada paso en orden, al final tendrás la aplicación funcionando en tu computador: login, registro y pantalla principal de tienda.

---

## PARTE 0: Qué vamos a construir

- Una app que muestra primero una **pantalla de inicio de sesión** (usuario, correo, contraseña).
- Un enlace **"Regístrate"** que lleva a un **formulario de registro** (nombre, correo, contraseña, confirmar contraseña). Los usuarios se **guardan en el dispositivo** (autenticación real).
- **Solo puedes iniciar sesión si antes te has registrado**: el login comprueba que el correo y la contraseña coincidan con un usuario registrado.
- Después de iniciar sesión correctamente, una **pantalla principal (Home)** con categorías y productos de ejemplo.

Todo el código está explicado con comentarios para que entiendas qué hace cada parte.

---

## PARTE 1: Instalar lo necesario

### Paso 1.1 – Descargar e instalar Flutter

1. Entra a: **https://docs.flutter.dev/get-started/install**
2. Elige tu sistema operativo (Windows, macOS o Linux) y sigue el instalador oficial.
3. En Windows: descarga el ZIP de Flutter, descomprímelo en una carpeta (por ejemplo `C:\flutter`). **No** lo pongas en una ruta con espacios ni en `Program Files`.
4. Añade Flutter al PATH:
   - En Windows: busca "Variables de entorno" en el menú inicio → "Editar las variables de entorno del sistema" → "Variables de entorno" → en "Variables del sistema" selecciona "Path" → "Editar" → "Nuevo" → pega la ruta de la carpeta `flutter` (ej: `C:\flutter`) y también `C:\flutter\bin`. Acepta todo.
5. Abre una **nueva** ventana de terminal (CMD o PowerShell) y escribe:
   ```bash
   flutter doctor
   ```
   Debe aparecer que Flutter está instalado. Si falta algo (por ejemplo Android Studio o Chrome), el mismo comando te dirá qué instalar.

### Paso 1.2 – Instalar un editor de código (IDE)

- **Recomendado:** **Visual Studio Code** (VS Code).
  1. Descarga desde: **https://code.visualstudio.com**
  2. Instálalo y ábrelo.
  3. En VS Code, ve a Extensiones (icono de cuadrados en la barra izquierda), busca **"Flutter"** e instala la extensión oficial de Flutter. Si te pide instalar "Dart", acepta.

Alternativa: **Android Studio** (más pesado pero incluye emulador Android). Descarga desde https://developer.android.com/studio e instala el plugin de Flutter desde Configuración → Plugins.

### Paso 1.3 – Verificar que todo funciona

En la terminal (fuera de VS Code), ejecuta:

```bash
flutter doctor
```

Revisa que no haya errores críticos. Si "Flutter" y "Android toolchain" o "Chrome" están bien, puedes continuar.

---

## PARTE 2: Crear el proyecto Flutter

### Paso 2.1 – Crear la carpeta del proyecto

1. Abre la terminal (o la terminal integrada de VS Code: Ver → Terminal).
2. Ve a la carpeta donde quieras el proyecto, por ejemplo el Escritorio o Documentos:
   ```bash
   cd C:\Users\TuUsuario\Documents
   ```
3. Crea un nuevo proyecto Flutter llamado `project` (o el nombre que prefieras):
   ```bash
   flutter create project
   ```
4. Entra a la carpeta:
   ```bash
   cd project
   ```

### Paso 2.2 – Estructura de carpetas que verás

Dentro de `project` tendrás algo así:

- **lib/** – Aquí va todo el código Dart de la app (es lo que vamos a editar).
- **pubspec.yaml** – Archivo donde se declaran las dependencias (paquetes) del proyecto.
- **test/** – Para pruebas (no lo usaremos en este tutorial).
- **android/**, **ios/**, **web/** – Código específico de cada plataforma; no hace falta tocarlo al principio.

Siempre que digamos "abre el archivo X", será dentro de la carpeta `project` que acabas de crear.

---

## PARTE 3: Configurar dependencias (pubspec.yaml)

### Paso 3.1 – Abrir pubspec.yaml

Abre el archivo **`pubspec.yaml`** que está en la raíz de `project`.

### Paso 3.2 – Asegurar las dependencias

Debajo de `dependencies:` debe haber al menos esto (si falta algo, añádelo respetando la indentación con espacios):

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  shared_preferences: ^2.2.2
  crypto: ^3.0.3
  cupertino_icons: ^1.0.8
```

- **flutter:** ya viene por defecto.
- **provider:** lo usamos para guardar el estado del login (usuario, correo, etc.) y que varias pantallas lo compartan.
- **shared_preferences:** guarda en el dispositivo la lista de usuarios registrados (para que el login pueda comprobar credenciales).
- **crypto:** para hashear la contraseña (SHA-256) y no guardarla en texto plano.
- **cupertino_icons:** iconos que usa Flutter.

Guarda el archivo. Luego en la terminal (dentro de la carpeta `project`) ejecuta:

```bash
flutter pub get
```

Así se descargan los paquetes. Si aparece "Got dependencies", está bien.

---

## PARTE 4: Crear la estructura de carpetas dentro de lib

Dentro de la carpeta **`lib`** vamos a crear varias carpetas para organizar el código. Hazlo en este orden:

1. **lib/core** – Validaciones y tema.
2. **lib/models** – Modelos de datos (producto, categoría).
3. **lib/data** – Datos de ejemplo (listas de productos y categorías).
4. **lib/services** – Servicios (autenticación: guardar y verificar usuarios).
5. **lib/providers** – Estado global (login).
6. **lib/screens** – Pantallas (login, registro, home).
7. **lib/widgets** – Widgets reutilizables (botón social).

Puedes crearlas desde el explorador de archivos o desde VS Code: clic derecho en `lib` → Nueva carpeta → escribe el nombre.

---

## PARTE 5: El punto de entrada – main.dart

### Paso 5.1 – Qué hace main.dart

`main.dart` es el archivo que se ejecuta al abrir la app. Solo hace una cosa: arrancar la aplicación con el widget principal.

### Paso 5.2 – Código de main.dart (con comentarios)

Abre **`lib/main.dart`**, borra todo su contenido y pega esto:

```dart
// ============================================================
// PUNTO DE ENTRADA DE LA APLICACIÓN
// Este archivo se ejecuta cuando el usuario abre la app.
// ============================================================

// Importamos el paquete de Flutter para tener botones, textos, colores, etc.
import 'package:flutter/material.dart';

// Importamos nuestro archivo app.dart donde está definida la aplicación completa.
import 'app.dart';

// "main" es la función que el sistema ejecuta al iniciar la app.
// void = no devuelve ningún valor.
void main() {
  // runApp dice a Flutter: "Dibuja en pantalla este widget (MyApp)".
  // MyApp está definido en app.dart.
  runApp(const MyApp());
}
```

Guarda el archivo (Ctrl+S). No hace falta que entiendas cada palabra aún; lo importante es que aquí solo arrancamos la app y el resto está en `app.dart`.

---

## PARTE 6: La aplicación principal – app.dart

### Paso 6.1 – Qué hace app.dart

En `app.dart` definimos **qué pantalla se muestra primero** (login) y **dónde guardamos el estado del login** (Provider) para que todas las pantallas puedan acceder al nombre de usuario, etc.

### Paso 6.2 – Código de app.dart (con comentarios)

Crea o abre **`lib/app.dart`** y pega:

```dart
// ============================================================
// CONFIGURACIÓN PRINCIPAL DE LA APLICACIÓN
// Aquí definimos la primera pantalla y el estado global (Provider).
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Nuestro "proveedor" de estado para el login (guarda usuario, email, etc.).
import 'providers/login_provider.dart';
// La pantalla de inicio de sesión (la primera que verá el usuario).
import 'screens/login_screen.dart';

// MyApp es el widget raíz: todo lo que se ve en la app está "dentro" de él.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // build construye la interfaz. Cada vez que Flutter necesita dibujar, llama a build.
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider hace que LoginProvider esté disponible en toda la app.
    // create: (_) => LoginProvider() = creamos una sola instancia de LoginProvider.
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      // child = el widget que va "debajo" del Provider (nuestra app con pantallas).
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  // Quitamos la etiqueta "DEBUG" en la esquina.
        title: 'App',                         // Nombre de la app (para el sistema).
        home: const LoginScreen(),            // La primera pantalla que se muestra es Login.
      ),
    );
  }
}
```

Guarda. Si ves errores en rojo es porque aún no existen `LoginProvider` ni `LoginScreen`; los crearemos en los siguientes pasos.

---

## PARTE 7: Validadores – core/validators.dart

### Paso 7.1 – Para qué sirve

Aquí definimos **reglas de validación** para los formularios: que el correo tenga formato correcto, que la contraseña tenga mayúscula y número, etc. Así no repetimos la misma lógica en login y registro.

### Paso 7.2 – Código de core/validators.dart (con comentarios)

Crea el archivo **`lib/core/validators.dart`** y pega:

```dart
// ============================================================
// VALIDADORES REUTILIZABLES PARA FORMULARIOS
// Usamos estas funciones en login y registro para no repetir código.
// ============================================================

// Expresión regular: patrón que define cómo debe verse un correo válido.
// Ejemplo válido: nombre@dominio.com
final RegExp _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

// Devuelve true si el texto parece un correo válido.
bool isValidEmail(String email) {
  return _emailRegex.hasMatch(email.trim());
}

// Valida el campo "usuario": no vacío, mínimo 3 caracteres, solo letras/números/_.
// Si hay error devuelve un texto; si está bien devuelve null.
String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'El usuario es obligatorio';
  }
  if (value.length < 3) {
    return 'El usuario debe tener al menos 3 caracteres';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Solo letras, números y guión bajo';
  }
  return null;
}

// Valida el correo: no vacío y formato correcto.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  }
  if (!isValidEmail(value)) {
    return 'Ingresa un correo electrónico válido (ej: nombre@dominio.com)';
  }
  return null;
}

// Valida la contraseña: no vacía, mínimo 6 caracteres, una mayúscula, una minúscula y un número.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 6) {
    return 'Mínimo 6 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Debe tener al menos una mayúscula';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Debe tener al menos una minúscula';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Debe tener al menos un número';
  }
  return null;
}

// Para el registro: nombre completo, solo letras y espacios, mínimo 2 palabras (nombre y apellido).
String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'El nombre es obligatorio';
  }
  if (value.trim().length < 3) {
    return 'El nombre debe tener al menos 3 caracteres';
  }
  if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$").hasMatch(value)) {
    return 'Solo letras y espacios (sin números ni símbolos)';
  }
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.length < 2) {
    return 'Ingresa nombre y apellido';
  }
  return null;
}

// Para el registro: el campo "confirmar contraseña" debe coincidir con la contraseña.
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Confirma tu contraseña';
  }
  if (value != password) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}
```

Guarda el archivo.

---

## PARTE 8: Tema y estilos – core/app_theme.dart

### Paso 8.1 – Para qué sirve

Aquí definimos **colores y estilos** que usamos en varias pantallas: fondo en gradiente, tarjetas blancas, estilo de los campos de texto. Así si quieres cambiar el color de la app, lo cambias en un solo sitio.

### Paso 8.2 – Código de core/app_theme.dart (con comentarios)

Crea **`lib/core/app_theme.dart`** y pega:

```dart
// ============================================================
// TEMA Y ESTILOS COMPARTIDOS
// Colores, gradientes y estilo de inputs para toda la app.
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();  // Constructor privado: no se pueden crear instancias, solo usar los static.

  // Color principal (azul) para botones y detalles.
  static const Color primaryBlue = Colors.blue;

  // Colores del gradiente de fondo (azul muy suave).
  static const List<Color> gradientColors = [
    Color(0xFFEAF2FF),
    Color(0xFFD6E4FF),
  ];

  // Decoración del fondo de las pantallas de login/registro.
  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: gradientColors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  // Decoración de las tarjetas blancas (login, registro, etc.).
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  );

  // Estilo común para los campos de texto (usuario, correo, contraseña).
  // hintText = texto placeholder; prefixIcon = icono a la izquierda; suffixIcon = opcional a la derecha.
  static InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
```

Guarda.

---

## PARTE 9: Modelos de datos – models/product.dart

### Paso 9.1 – Para qué sirve

Un **modelo** es una clase que describe la forma de un dato. Aquí definimos **Product** (id, nombre, precio, categoría, icono) y **Category** (id, nombre, icono). La pantalla del Home usará estos modelos para mostrar productos.

### Paso 9.2 – Código de models/product.dart (con comentarios)

Crea **`lib/models/product.dart`** y pega:

```dart
// ============================================================
// MODELOS DE DATOS: PRODUCTO Y CATEGORÍA
// Representan un producto y una categoría en nuestra tienda.
// ============================================================

import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.icon = Icons.shopping_bag,
  });

  final String id;           // Identificador único.
  final String name;         // Nombre del producto.
  final double price;        // Precio.
  final String categoryId;  // Id de la categoría a la que pertenece.
  final IconData icon;      // Icono que mostramos (Flutter no guarda imágenes en el modelo, usamos iconos).

  // Getter que formatea el precio como "$90" para mostrarlo en pantalla.
  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
}

class Category {
  const Category({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}
```

Guarda.

---

## PARTE 10: Datos de ejemplo – data/mock_products.dart

### Paso 10.1 – Para qué sirve

Aquí ponemos **listas fijas** de categorías y productos que la pantalla Home mostrará. Más adelante podrías reemplazar esto por datos que vengan de una base de datos o API.

### Paso 10.2 – Código de data/mock_products.dart (con comentarios)

Crea **`lib/data/mock_products.dart`** y pega:

```dart
// ============================================================
// DATOS DE EJEMPLO: CATEGORÍAS Y PRODUCTOS
// La pantalla Home usa estas listas para mostrar el catálogo.
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';

const List<Category> categories = [
  Category(id: 'all', name: 'Todos', icon: Icons.apps),
  Category(id: 'electronics', name: 'Electrónica', icon: Icons.devices),
  Category(id: 'clothing', name: 'Ropa', icon: Icons.checkroom),
  Category(id: 'home', name: 'Hogar', icon: Icons.home),
  Category(id: 'sports', name: 'Deportes', icon: Icons.sports_soccer),
];

const List<Product> mockProducts = [
  Product(id: '1', name: 'Audífonos inalámbricos', price: 89.99, categoryId: 'electronics', icon: Icons.headphones),
  Product(id: '2', name: 'Smartwatch', price: 149.99, categoryId: 'electronics', icon: Icons.watch),
  Product(id: '3', name: 'Camiseta básica', price: 24.99, categoryId: 'clothing', icon: Icons.checkroom),
  Product(id: '4', name: 'Pantalón jeans', price: 59.99, categoryId: 'clothing', icon: Icons.checkroom),
  Product(id: '5', name: 'Lámpara LED', price: 34.99, categoryId: 'home', icon: Icons.lightbulb_outline),
  Product(id: '6', name: 'Set de sábanas', price: 45.99, categoryId: 'home', icon: Icons.bed),
  Product(id: '7', name: 'Balón de fútbol', price: 29.99, categoryId: 'sports', icon: Icons.sports_soccer),
  Product(id: '8', name: 'Mochila deportiva', price: 54.99, categoryId: 'sports', icon: Icons.backpack),
  Product(id: '9', name: 'Teclado mecánico', price: 119.99, categoryId: 'electronics', icon: Icons.keyboard),
];
```

Guarda.

---

## PARTE 11: Servicio de autenticación – services/auth_service.dart

### Paso 11.1 – Para qué sirve

El **AuthService** guarda los usuarios registrados en el dispositivo (SharedPreferences) y comprueba correo y contraseña al iniciar sesión. Las contraseñas se guardan hasheadas (SHA-256), no en texto plano. Así el login solo permite entrar a quien se haya registrado antes y use la contraseña correcta.

### Paso 11.2 – Código de services/auth_service.dart (con comentarios)

Crea la carpeta **`lib/services`** si no existe, luego el archivo **`lib/services/auth_service.dart`** y pega:

```dart
// ============================================================
// SERVICIO DE AUTENTICACIÓN LOCAL
// Guarda usuarios registrados y valida credenciales al iniciar sesión.
// ============================================================

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyUsers = 'registered_users';

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<List<Map<String, String>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyUsers);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>?;
    if (list == null) return [];
    return list
        .map((e) => Map<String, String>.from(e as Map<dynamic, dynamic>))
        .toList();
  }

  static Future<void> _saveUsers(List<Map<String, String>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsers, jsonEncode(users));
  }

  /// Registra un nuevo usuario. Devuelve true si se registró, false si el correo ya existe.
  static Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final emailLower = email.trim().toLowerCase();
    if (users.any((u) => (u['email'] ?? '').toLowerCase() == emailLower)) {
      return false;
    }
    users.add({
      'fullName': fullName.trim(),
      'email': emailLower,
      'passwordHash': _hashPassword(password),
    });
    await _saveUsers(users);
    return true;
  }

  /// Verifica credenciales por correo y contraseña. Devuelve true si son correctas.
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final input = email.trim().toLowerCase();
    final hash = _hashPassword(password);
    for (final u in users) {
      if ((u['email'] ?? '').toLowerCase() == input) {
        return u['passwordHash'] == hash;
      }
    }
    return false;
  }
}
```

Guarda.

---

## PARTE 12: Estado del login – providers/login_provider.dart

### Paso 12.1 – Para qué sirve

El **LoginProvider** guarda todo lo relacionado con el login: nombre de usuario, email, contraseña, si la contraseña está oculta o no, y si está "cargando". Valida con los validadores de core y llama al **AuthService** para comprobar si el usuario está registrado y la contraseña es correcta. Devuelve true/false para que la pantalla solo navegue al Home cuando el login sea exitoso. Google y Facebook siguen siendo simulados (SnackBar).

### Paso 12.2 – Código de providers/login_provider.dart (con comentarios)

Crea **`lib/providers/login_provider.dart`** y pega:

```dart
// ============================================================
// ESTADO GLOBAL DEL LOGIN
// Guarda usuario, email, contraseña y delega la verificación en AuthService.
// ============================================================

import 'package:flutter/material.dart';

import '../core/validators.dart' as validators;
import '../services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool obscurePassword = true;

  void setUsername(String value) => username = value;
  void setEmail(String value) => email = value;
  void setPassword(String value) => password = value;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  String? validateUsername(String? value) => validators.validateUsername(value);
  String? validateEmail(String? value) => validators.validateEmail(value);
  String? validatePassword(String? value) => validators.validatePassword(value);

  /// Intenta iniciar sesión. Devuelve true si las credenciales son correctas.
  Future<bool> loginNormal(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final ok = await AuthService.login(email: email.trim(), password: password);

    isLoading = false;
    notifyListeners();

    if (context.mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido, $username')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales incorrectas o no estás registrado. Regístrate primero.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return ok;
  }

  void loginGoogle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se ha logeado con Google')),
    );
  }

  void loginFacebook(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se ha logeado con Facebook')),
    );
  }
}
```

Guarda.

---

## PARTE 13: Botón social reutilizable – widgets/social_button.dart

### Paso 13.1 – Para qué sirve

Un **widget** es un pedazo de interfaz que podemos reutilizar. Este botón se usa dos veces en el login (Google y Facebook): mismo estilo, solo cambian el icono, el texto y la acción al hacer clic.

### Paso 13.2 – Código de widgets/social_button.dart (con comentarios)

Crea **`lib/widgets/social_button.dart`** y pega:

```dart
// ============================================================
// BOTÓN REUTILIZABLE PARA LOGIN SOCIAL (Google, Facebook, etc.)
// ============================================================

import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;      // Icono a mostrar (ej: Icons.g_mobiledata para Google).
  final String text;       // Texto (ej: "Google").
  final VoidCallback onTap; // Función que se ejecuta al hacer clic.

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,  // En web/PC muestra la manita al pasar el mouse.
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 5),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
```

Guarda.

---

## PARTE 14: Pantalla de login – screens/login_screen.dart

### Paso 14.1 – Qué hace esta pantalla

Muestra el formulario de inicio de sesión (usuario, correo, contraseña), el botón "Ingresar", los botones de Google y Facebook, y el enlace "Regístrate". Al hacer clic en **Ingresar**, se valida el formulario y se llama a `provider.loginNormal(context)`. **Solo si devuelve true** (usuario registrado y contraseña correcta) se navega a la pantalla Home; si devuelve false, se muestra un mensaje de error y el usuario se queda en login.

### Paso 14.2 – Código de screens/login_screen.dart (con comentarios)

Crea **`lib/screens/login_screen.dart`** y pega el contenido que tienes en tu proyecto actual (el que ya incluye `HomeScreen` y `RegistrationScreen`). Importante: el botón Ingresar debe usar el **resultado** de `loginNormal` para decidir si navegar:

```dart
// Importaciones: Flutter, Provider, tema, provider de login, pantallas de home y registro, botón social.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/login_provider.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import '../widgets/social_button.dart';

// StatefulWidget porque el formulario puede cambiar (por ejemplo al mostrar/ocultar contraseña).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clave del formulario: la usamos para llamar a validate() y comprobar todos los campos.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // context.watch<LoginProvider>() hace que esta pantalla se redibuje cuando cambie el estado del login.
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration,  // Fondo en gradiente azul suave.
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: AppTheme.cardDecoration,  // Tarjeta blanca con sombra.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Icono de candado en círculo azul.
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 20),
                    const Text("Inicia sesión", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Accede a tu cuenta", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 25),
                    // Campo usuario: validator y onChanged vienen del provider.
                    TextFormField(
                      decoration: AppTheme.inputDecoration(hintText: "Usuario", prefixIcon: Icons.person_outline),
                      validator: provider.validateUsername,
                      onChanged: provider.setUsername,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: AppTheme.inputDecoration(hintText: "Correo electrónico", prefixIcon: Icons.email_outlined),
                      validator: provider.validateEmail,
                      onChanged: provider.setEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: provider.obscurePassword,
                      decoration: AppTheme.inputDecoration(
                        hintText: "Contraseña",
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(provider.obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: provider.togglePassword,
                        ),
                      ),
                      validator: provider.validatePassword,
                      onChanged: provider.setPassword,
                    ),
                    const SizedBox(height: 15),
                    // Botón Ingresar: valida, llama loginNormal; solo navega a Home si loginNormal devuelve true.
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              final ok = await provider.loginNormal(context);
                              if (context.mounted && ok) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: provider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Ingresar"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text("o continuar con"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButton(
                          icon: Icons.g_mobiledata,
                          text: "Google",
                          onTap: () {
                            provider.loginGoogle(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                          },
                        ),
                        SocialButton(
                          icon: Icons.facebook,
                          text: "Facebook",
                          onTap: () {
                            provider.loginFacebook(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta? "),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                            },
                            child: const Text("Regístrate", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

En tu proyecto real el botón Ingresar debe guardar el resultado de `loginNormal` en una variable `ok` y solo hacer `Navigator.pushReplacement` cuando `ok` sea true. Los imports deben incluir `home_screen.dart` y `registration_screen.dart`.

---

## PARTE 15: Pantalla de registro – screens/registration_screen.dart

### Paso 15.1 – Qué hace esta pantalla

Muestra un formulario para crear cuenta: nombre completo, correo, contraseña y confirmar contraseña. Usa los validadores de `core/validators.dart` y **AuthService** para guardar el usuario en el dispositivo. Si el correo ya está registrado muestra un SnackBar en rojo; si no, guarda el usuario, muestra "Cuenta creada correctamente. Ya puedes iniciar sesión." y vuelve atrás (a login). Usa controladores (`_fullNameController`, `_emailController`, `_passwordController`) para leer los valores y un estado `_isLoading` durante el registro.

### Paso 15.2 – Código

El archivo **`lib/screens/registration_screen.dart`** debe contener:

- Un `Form` con `_formKey`.
- `TextEditingController` para nombre, correo y contraseña (para leer valores y comparar confirmar contraseña).
- Estado `_isLoading` para mostrar indicador de carga al pulsar "Registrarse".
- Campos para nombre, correo, contraseña y confirmar contraseña, con `AppTheme.inputDecoration` y los validadores `validateFullName`, `validateEmail`, `validatePassword`, `validateConfirmPassword`.
- Botón "Registrarse" que al validar llama a `AuthService.register(fullName, email, password)`. Si devuelve true: SnackBar de éxito y `Navigator.pop(context)`. Si devuelve false: SnackBar en rojo "Ese correo ya está registrado...".
- Imports: `package:flutter/material.dart`, `../core/app_theme.dart`, `../core/validators.dart`, `../services/auth_service.dart`.
- Enlace "Inicia sesión" y AppBar con botón atrás que hacen `Navigator.pop(context)`.

---

## PARTE 16: Pantalla principal (Home) – screens/home_screen.dart

### Paso 16.1 – Qué hace esta pantalla

Muestra el nombre del usuario (del LoginProvider), una barra de categorías (Todos, Electrónica, Ropa, etc.) y un grid de productos. Al elegir una categoría se filtran los productos. Los datos vienen de `data/mock_products.dart`.

### Paso 16.2 – Código

El archivo **`lib/screens/home_screen.dart`** ya existe en tu proyecto. Debe:

- Importar `app_theme`, `mock_products`, `product`, `login_provider`.
- Tener un estado `_selectedCategoryId` (por defecto `'all'`).
- Tener un getter `_filteredProducts` que filtre `mockProducts` por categoría.
- Mostrar AppBar con título "Mi Tienda", iconos de búsqueda y carrito.
- Mostrar "Hola, [username]" o "Usuario" si no hay nombre.
- ListView horizontal de categorías que al tocar actualizan `_selectedCategoryId`.
- Grid de productos usando `_filteredProducts` y un widget `_ProductCard` para cada uno.

No hace falta reescribir todo; verifica que el archivo exista y que no tenga errores de import. Si falta algo, el contenido completo está en tu proyecto en `lib/screens/home_screen.dart`.

---

## PARTE 17: Orden de creación y comprobación

Para que no se escape nada, sigue este orden al crear/editar archivos:

1. **lib/main.dart** – Punto de entrada.
2. **lib/app.dart** – MyApp y Provider.
3. **lib/core/validators.dart** – Validadores.
4. **lib/core/app_theme.dart** – Tema.
5. **lib/models/product.dart** – Product y Category.
6. **lib/data/mock_products.dart** – Listas de categorías y productos.
7. **lib/services/auth_service.dart** – Registro y login con persistencia local.
8. **lib/providers/login_provider.dart** – Estado del login (usa AuthService).
9. **lib/widgets/social_button.dart** – Botón social.
10. **lib/screens/login_screen.dart** – Pantalla de login.
11. **lib/screens/registration_screen.dart** – Pantalla de registro.
12. **lib/screens/home_screen.dart** – Pantalla principal.

Después de crear cada archivo, guarda y revisa que no aparezcan errores rojos en el IDE. Si aparece un error de "archivo no encontrado", suele ser por un import mal escrito o por no haber creado aún el archivo que se importa.

---

## PARTE 18: Ejecutar la aplicación

### Paso 18.1 – Desde la terminal

1. Abre la terminal y ve a la carpeta del proyecto:
   ```bash
   cd ruta\donde\está\project
   ```
2. Ejecuta:
   ```bash
   flutter run
   ```
3. Si tienes varios dispositivos (Chrome, emulador Android, etc.), Flutter te pedirá que elijas uno. Por ejemplo, para ejecutar en **Chrome**:
   ```bash
   flutter run -d chrome
   ```
4. La app se abrirá: primero verás la pantalla de login. **Primero regístrate** (Regístrate → nombre, correo, contraseña → Registrarse). Luego inicia sesión con ese mismo correo y contraseña y pulsa "Ingresar". Solo entonces irás al Home. Si intentas entrar sin registrarte, verás un mensaje de error.

### Paso 18.2 – Desde VS Code

1. Abre la carpeta `project` en VS Code (Archivo → Abrir carpeta).
2. En la barra inferior elige el dispositivo (Chrome, Android, etc.).
3. Pulsa F5 o ve a "Run and Debug" y ejecuta "Flutter". La app se compilará y abrirá.

### Paso 18.3 – Si hay errores al compilar

- **"No se encuentra el paquete provider"**  
  En la terminal: `flutter pub get`.

- **Errores en rojo en imports**  
  Comprueba que las rutas sean correctas: `'../core/validators.dart'` desde `lib/providers` sube un nivel (`../`) y entra en `core/validators.dart`.

- **"Target of URI doesn't exist"**  
  El archivo que intentas importar no existe o está en otra ruta. Revisa que hayas creado todas las carpetas y archivos de la PARTE 17 (incluido `lib/services/auth_service.dart`).

---

## PARTE 19: Cómo usar la app (flujo completo)

1. **Al abrir la app**  
   Verás la pantalla de **Inicia sesión** con usuario, correo y contraseña.

2. **Registrarte (primero)**  
   - En login, pulsa **Regístrate**.
   - Completa nombre completo (nombre y apellido), correo, contraseña y confirmar contraseña (mínimo 6 caracteres, mayúscula, minúscula y número).
   - Pulsa **Registrarse**. Si el correo no está usado verás "Cuenta creada correctamente. Ya puedes iniciar sesión." y volverás al login. Si el correo ya existe verás un mensaje en rojo.

3. **Iniciar sesión**  
   - Usuario: al menos 3 caracteres, solo letras, números y _.
   - Correo: el **mismo** con el que te registraste (formato válido, ej: nombre@correo.com).
   - Contraseña: la **misma** que usaste al registrarte.
   - Pulsa **Ingresar**. Si las credenciales son correctas irás al **Home** con un mensaje de bienvenida. Si no estás registrado o la contraseña es incorrecta verás un mensaje en rojo y no entrarás.
   - **Google** y **Facebook** solo simulan el login (SnackBar) y pueden llevarte al Home sin verificar usuario real.

4. **En el Home**  
   - Verás "Hola, [tu usuario]" (o "Usuario" si no hay nombre).
   - Puedes tocar las categorías (Todos, Electrónica, Ropa, Hogar, Deportes) para filtrar productos.
   - Los botones de búsqueda y carrito están en la barra superior (por ahora sin acción).

---

## Resumen final

- **main.dart** arranca la app con `runApp(MyApp)`.
- **app.dart** define la primera pantalla (Login) y el Provider del login.
- **core/** tiene validadores y tema compartidos.
- **models/** define Product y Category.
- **data/** tiene las listas de categorías y productos.
- **services/** tiene AuthService: guarda usuarios (SharedPreferences, contraseña hasheada) y valida login.
- **providers/** guarda el estado del login y usa AuthService para verificar credenciales.
- **widgets/** tiene el botón social reutilizable.
- **screens/** tiene login, registro y home.

Solo los usuarios **registrados** pueden iniciar sesión con correo y contraseña correctos. Si sigues cada parte en orden y copias/creas los archivos tal como se indica, podrás **compilar y usar la aplicación** sin problemas. Cuando algo falle, revisa que el archivo exista, que los imports estén bien y que hayas ejecutado `flutter pub get`.
