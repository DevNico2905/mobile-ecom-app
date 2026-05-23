# App E-commerce Flutter

Aplicación de comercio electrónico en Flutter con **login y registro real**. Solo puedes iniciar sesión si antes te has registrado; las credenciales se validan contra los usuarios guardados en el dispositivo (SharedPreferences, contraseñas hasheadas con SHA-256).

## Contenido

- **Pantalla de login**: usuario, correo, contraseña. Botón Ingresar y enlace a Registro. Solo entra al Home si las credenciales coinciden con un usuario registrado.
- **Pantalla de registro**: nombre completo, correo, contraseña y confirmar contraseña. Guarda el usuario localmente; si el correo ya existe, muestra error.
- **Pantalla principal (Home)**: categorías (Todos, Electrónica, Ropa, Hogar, Deportes) y grid de productos de ejemplo.

## Cómo ejecutar

```bash
cd ruta/al/project
flutter pub get
flutter run -d chrome
```

1. **Regístrate** desde el enlace "Regístrate" (nombre, correo, contraseña).
2. **Inicia sesión** con ese mismo correo y contraseña.
3. Verás el Home con el catálogo.

Para más detalle: **[ejecutar.md](ejecutar.md)**.

## Documentación

| Archivo | Descripción |
|---------|-------------|
| [ejecutar.md](ejecutar.md) | Cómo ejecutar la app en vivo (requisitos, pasos, qué verás). |
| [README_TUTORIAL.md](README_TUTORIAL.md) | Tutorial paso a paso para crear la app desde cero (principiantes). |
| [arquitectura.md](arquitectura.md) | Estructura del proyecto, capas, flujo y responsabilidades. |
| [README_baseedatos.md](README_baseedatos.md) | Configurar MySQL Workbench y crear la base `ecommerceflutter`. |
| [database/README.md](database/README.md) | Esquema de BD y relación con los modelos (para futuro backend). |

## Tecnologías

- **Flutter** (Dart)
- **Provider** – estado global (login)
- **SharedPreferences** – persistencia local de usuarios registrados
- **crypto** – hash de contraseñas (SHA-256)

La base de datos MySQL (`database/schema.sql`) está preparada para un futuro backend; la app no se conecta a ella todavía.

## Getting Started

Para desarrollar con Flutter:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Documentación Flutter](https://docs.flutter.dev/)
