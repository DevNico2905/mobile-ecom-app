# Diagnóstico del proyecto

## 1. Qué es el proyecto

- **Frontend:** App Flutter (web/móvil) en la raíz del repo: login, registro, pantalla principal con catálogo.
- **Backend:** API en Node.js (Express) en `backend/`: autenticación (registro/login) y listado de productos desde MySQL.
- **Base de datos:** MySQL, base `ecommerceflutter`, tablas `users`, `products`, `categories`.

El flujo: el usuario inicia sesión o se registra en la app Flutter; las peticiones van a `http://localhost:3000/api` (AuthService). El backend usa las variables de `backend/.env` para conectarse a MySQL.

---

## 2. Estructura relevante

```
project/
├── backend/
│   ├── .env          ← Credenciales MySQL (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT)
│   ├── index.js      ← Único archivo del API (rutas, pool MySQL, lógica auth/productos)
│   └── package.json
├── lib/
│   ├── main.dart     → runApp(MyApp())
│   ├── app.dart      → MaterialApp, Provider, pantalla inicial LoginScreen
│   ├── screens/      → login_screen, registration_screen, home_screen
│   ├── services/     → auth_service.dart (Dio, baseUrl localhost:3000/api)
│   ├── providers/    → login_provider (estado de login)
│   ├── models/       → product.dart
│   ├── data/         → mock_products.dart (datos locales del catálogo)
│   ├── core/         → app_theme, validators
│   └── widgets/      → social_button
├── pubspec.yaml
└── ...
```

---

## 3. Cómo se conectan frontend y backend

| Origen | Destino | Uso |
|--------|--------|-----|
| `lib/services/auth_service.dart` | `http://localhost:3000/api` | Login y registro (Dio). |
| `lib/screens/home_screen.dart` | `lib/data/mock_products.dart` | Catálogo: **no** usa el backend; usa lista local. |
| Backend `GET /api/products` | MySQL `products` | Existe en el API pero el Flutter actual no lo llama. |

La URL del API está fija en `AuthService._baseUrl`. Para emulador Android suele usarse `10.0.2.2` en lugar de `localhost`.

---

## 4. Problema que apareció

- En registro, la app mostraba “Ese correo ya está registrado” aunque la tabla `ecommerceflutter.users` estaba vacía en MySQL Workbench.
- Causa probable: el backend no estaba usando esa base porque **no cargaba bien el `.env`** (dotenv inyectaba 0 variables en tu entorno Windows), así que la conexión MySQL podía estar usando otra base por defecto donde sí había usuarios.

---

## 5. Cambios que se hicieron en el backend (y su impacto)

Se modificó **solo** `backend/index.js`:

| Cambio | Intención | Riesgo / comentario |
|--------|-----------|----------------------|
| Sustituir `dotenv` por lectura manual del `.env` (fs + parseo línea a línea) | Que las variables se carguen aunque dotenv falle (p. ej. por BOM/encoding en Windows). | Código más largo y se deja de usar la dependencia `dotenv` en la práctica. |
| Quitar BOM al leer el archivo | Evitar que la primera variable no se reconozca. | Correcto si el archivo tenía BOM. |
| Valores por defecto (DB_NAME, DB_HOST, etc.) si el `.env` no carga | Que el servidor arranque y se conecte a `ecommerceflutter` aunque falle la carga del `.env`. | **Contras:** credenciales (incluida contraseña) quedan en el código; si alguien cambia la BD en Workbench y no toca el código, el backend seguiría usando los valores por defecto. |
| Nueva ruta `GET /api/debug-db` | Ver qué base usa el backend y cuántos usuarios hay. | Útil para depurar; no afecta el comportamiento normal de la app. |
| Validación de `DB_NAME` y `process.exit(1)` | Avisar si no hay configuración. | Se sustituyó por los valores por defecto; ya no se hace salida forzada. |

Resumen: se añadió lógica y credenciales por defecto para que el servidor arranque sí o sí; eso puede considerarse “ensuciar” el diseño original (un solo `.env`, sin fallbacks en código).

---

## 6. Estado actual recomendado (backend)

- **Volver a usar `dotenv`** con ruta explícita: `path.join(__dirname, '.env')`, para no depender del directorio desde el que se ejecuta `node index.js`.
- **No dejar credenciales por defecto en el código.** Si el `.env` no se carga, que el proceso falle con un mensaje claro.
- **Mantener** `GET /api/debug-db` opcional para depuración (no cambia la lógica de negocio).
- Si en tu máquina dotenv sigue inyectando 0 variables, **guardar `backend/.env` como UTF-8 sin BOM** (en Cursor/VS Code: barra inferior → codificación → “Save with Encoding” → “UTF-8”, no “UTF-8 with BOM”).

Así el proyecto queda como lo tenías a nivel de diseño (configuración solo vía `.env`) y se reduce el riesgo de credenciales fijas y comportamientos confusos.

---

## 7. Cómo ejecutar el proyecto (resumen)

1. **MySQL:** Servicio en marcha, base `ecommerceflutter` creada, tablas `users` (y si aplica `products`, `categories`) existentes.
2. **Backend:**  
   `cd backend` → `npm install` (solo la primera vez) → `node index.js`.  
   Debe mostrar algo como “API escuchando en http://localhost:3000”.
3. **Flutter (Chrome):**  
   En la raíz del proyecto: `flutter pub get` y `flutter run -d chrome`.

---

## 8. Otros detalles (sin cambios realizados)

- **Home:** El catálogo sigue usando `mock_products.dart`; la ruta `GET /api/products` del backend no está conectada en el frontend. Es decisión de diseño, no un error.
- **LoginProvider:** Tras un login correcto, el backend devuelve el `username`, pero el provider no lo persiste; el saludo en Home puede seguir mostrando “Usuario” si no se guarda ese dato. Sería un ajuste en el flujo de login, no en el backend.

Si quieres, el siguiente paso puede ser dejar el `index.js` del backend exactamente en el estado descrito en el punto 6 (dotenv + path, sin defaults, mensaje de error claro y opcionalmente `/api/debug-db`).
