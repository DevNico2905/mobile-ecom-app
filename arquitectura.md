# Arquitectura del proyecto – E-commerce Flutter

Este documento describe la arquitectura completa del proyecto: organización de carpetas, responsabilidad de cada capa y flujo de la aplicación. La app usa **autenticación real**: los usuarios deben registrarse antes de poder iniciar sesión; las credenciales se validan contra los datos guardados localmente.

---

## 1. Visión general

El proyecto es una aplicación **e-commerce** en Flutter que sigue una arquitectura por **capas y carpetas por feature**: el código está separado por responsabilidad (entrada de la app, configuración, lógica de negocio, servicios, pantallas, widgets reutilizables, modelos y datos).

- **Entrada:** `main.dart` solo arranca la app.
- **Configuración:** `app.dart` define `MaterialApp`, Provider y pantalla inicial.
- **Núcleo:** `core/` concentra validaciones y tema.
- **Modelos:** `models/` define las entidades (Product, Category).
- **Datos:** `data/` contiene datos estáticos o mock (productos, categorías).
- **Servicios:** `services/` contiene la lógica de autenticación (registro e inicio de sesión con persistencia local).
- **Estado:** `providers/` maneja el estado global (por ejemplo, login) y delega la verificación en el servicio de autenticación.
- **Pantallas:** `screens/` agrupa cada pantalla (login, registro, home).
- **Widgets:** `widgets/` contiene componentes reutilizables.
- **Base de datos:** `database/` y documentación en la raíz definen el esquema MySQL para un futuro backend; la app usa **SharedPreferences** para guardar usuarios registrados de forma local.

---

## 2. Estructura de carpetas

```
project/
├── lib/                          # Código fuente de la app Flutter
│   ├── main.dart                 # Punto de entrada (solo runApp)
│   ├── app.dart                  # MyApp, MaterialApp, Provider, rutas
│   │
│   ├── core/                     # Núcleo compartido
│   │   ├── validators.dart       # Validaciones (email, usuario, contraseña, nombre)
│   │   └── app_theme.dart        # Tema, colores, estilos de inputs y tarjetas
│   │
│   ├── models/                   # Modelos de datos
│   │   └── product.dart          # Product, Category
│   │
│   ├── data/                     # Datos estáticos / mock
│   │   └── mock_products.dart    # Listas de categorías y productos de ejemplo
│   │
│   ├── services/                 # Servicios (lógica de negocio reutilizable)
│   │   └── auth_service.dart     # Registro e login con SharedPreferences y hash de contraseña
│   │
│   ├── providers/                # Estado global (Provider)
│   │   └── login_provider.dart   # Estado y lógica del login (usa AuthService)
│   │
│   ├── screens/                  # Pantallas de la app
│   │   ├── login_screen.dart     # Inicio de sesión
│   │   ├── registration_screen.dart  # Registro de usuarios
│   │   └── home_screen.dart      # Inicio (catálogo e-commerce)
│   │
│   └── widgets/                  # Widgets reutilizables
│       └── social_button.dart    # Botón para login social (Google, Facebook)
│
├── database/                     # Esquema y documentación de BD
│   ├── schema.sql                # Script SQL (tablas users, categories, products)
│   └── README.md                 # Cómo usar el esquema en MySQL
│
├── README.md                     # Descripción general del proyecto
├── README_baseedatos.md          # Guía para configurar MySQL Workbench
├── arquitectura.md               # Este archivo
├── ejecutar.md                  # Cómo ejecutar la app en vivo
└── pubspec.yaml                  # Dependencias Flutter
```

---

## 3. Descripción por capa

### 3.1 Entrada de la aplicación

| Archivo    | Rol |
|-----------|-----|
| **main.dart** | Punto de entrada. Solo ejecuta `runApp(const MyApp())`. No contiene lógica ni UI. |

---

### 3.2 Configuración de la app

| Archivo | Rol |
|---------|-----|
| **app.dart** | Define el widget raíz `MyApp`: envuelve la app en `ChangeNotifierProvider<LoginProvider>` y configura `MaterialApp` (título, pantalla inicial `LoginScreen`, sin banner de debug). Aquí se “inyecta” el estado global de login. |

---

### 3.3 Núcleo (`core/`)

Contiene código compartido por varias pantallas.

| Archivo | Rol |
|---------|-----|
| **validators.dart** | Funciones de validación reutilizables: formato de correo (`isValidEmail`), usuario, correo, contraseña, nombre completo y confirmación de contraseña. Usadas en login y registro. |
| **app_theme.dart** | Constantes de diseño: color primario, gradiente de fondo, decoración de tarjetas, estilo de `InputDecoration` para formularios. Mantiene la apariencia consistente. |

---

### 3.4 Modelos (`models/`)

Definen las **entidades** del dominio (estructura de datos), sin lógica de UI.

| Archivo | Contenido |
|---------|-----------|
| **product.dart** | **Product:** id, name, price, categoryId, icon; getter `formattedPrice`. **Category:** id, name, icon. Son la representación en memoria de productos y categorías; en backend/BD se mapean a tablas. |

---

### 3.5 Datos (`data/`)

Datos estáticos o mock usados por la UI hasta que exista un backend real.

| Archivo | Rol |
|---------|-----|
| **mock_products.dart** | Listas constantes: categorías (Todos, Electrónica, Ropa, Hogar, Deportes) y productos de ejemplo. El Home los usa para mostrar el catálogo. En el futuro pueden reemplazarse por llamadas a una API. |

---

### 3.6 Servicios (`services/`)

Lógica de negocio reutilizable, independiente de la UI. No dependen de Flutter (salvo paquetes como SharedPreferences).

| Archivo | Rol |
|---------|-----|
| **auth_service.dart** | Servicio de autenticación local. Guarda usuarios registrados en **SharedPreferences** (nombre, correo, contraseña hasheada con SHA-256). `register()` añade un usuario si el correo no existe; `login()` verifica correo y contraseña y devuelve true/false. Usado por `LoginProvider` y por la pantalla de registro. |

---

### 3.7 Proveedores de estado (`providers/`)

Gestionan **estado global** y orquestan la UI con los servicios, usando Provider (patrón ChangeNotifier).

| Archivo | Rol |
|---------|-----|
| **login_provider.dart** | Estado del login: username, email, password, isLoading, obscurePassword. Métodos: setters, toggle de contraseña, validadores (que delegan en `core/validators`). **loginNormal(context)** llama a `AuthService.login(email, password)`; si es correcto muestra SnackBar de bienvenida y devuelve `true`; si no, muestra SnackBar de error y devuelve `false`. La pantalla de login solo navega al Home cuando el resultado es `true`. Login Google/Facebook siguen siendo simulados (SnackBar). |

---

### 3.8 Pantallas (`screens/`)

Cada archivo corresponde a **una pantalla** de la app.

| Archivo | Rol |
|---------|-----|
| **login_screen.dart** | Pantalla de inicio de sesión: formulario (usuario, correo, contraseña), botón Ingresar, botones sociales, enlace “Regístrate”. Usa `LoginProvider`. Tras `loginNormal(context)` solo hace `Navigator.pushReplacement` a **HomeScreen** si el método devuelve `true` (credenciales válidas). Si devuelve `false`, el usuario se queda en login y ve el mensaje de error. |
| **registration_screen.dart** | Formulario de registro: nombre completo, correo, contraseña, confirmar contraseña. Usa controladores para leer los valores y llama a `AuthService.register()`. Si el correo ya existe muestra SnackBar en rojo; si no, guarda el usuario, muestra “Cuenta creada correctamente. Ya puedes iniciar sesión.” y hace `Navigator.pop` al login. Incluye estado de carga (_isLoading) durante el registro. |
| **home_screen.dart** | Pantalla principal del e-commerce: AppBar (título, búsqueda, carrito), saludo con nombre de usuario, filtro por categorías, grid de productos. Usa datos de `data/mock_products.dart` y `LoginProvider` para el nombre. |

---

### 3.9 Widgets reutilizables (`widgets/`)

Componentes reutilizables en varias pantallas.

| Archivo | Rol |
|---------|-----|
| **social_button.dart** | Widget `SocialButton`: icono + texto + callback. Usado en el login para “Google” y “Facebook”. Incluye cursor de mano (`MouseRegion`) para mejor UX en web/escritorio. |

---

### 3.10 Base de datos y documentación

| Elemento | Rol |
|----------|-----|
| **database/schema.sql** | Script SQL para MySQL: tablas `users`, `categories`, `products` y datos iniciales. Refleja el mismo dominio que los modelos (users ↔ login/registro, categories/products ↔ catálogo). Pensado para un futuro backend. |
| **database/README.md** | Instrucciones para ejecutar el esquema y relación modelo Dart ↔ tabla MySQL. |
| **README_baseedatos.md** | Guía paso a paso para crear y configurar la base `ecommerceflutter` en MySQL Workbench. |

La app **no** se conecta directamente a MySQL. La autenticación actual usa **SharedPreferences** en el dispositivo. El esquema MySQL está preparado para cuando exista un **backend** (API REST, etc.) que use esa base y la app consuma esa API.

---

## 4. Flujo de la aplicación

1. **Arranque:** `main()` → `MyApp` (Provider + MaterialApp) → pantalla inicial **LoginScreen**.
2. **Registro:** Desde el login, “Regístrate” abre **RegistrationScreen**. El usuario completa nombre, correo y contraseña. Al pulsar “Registrarse”, se llama a `AuthService.register()`. Si el correo ya existe se muestra error; si no, se guarda el usuario (contraseña hasheada) y se vuelve al login.
3. **Login:** El usuario ingresa correo y contraseña (y usuario, para mostrar en Home). `LoginProvider.loginNormal()` llama a `AuthService.login(email, password)`. Si las credenciales son correctas (usuario registrado y contraseña correcta), devuelve `true` y la pantalla hace `Navigator.pushReplacement` a **HomeScreen**. Si no, devuelve `false`, se muestra mensaje de error y el usuario permanece en login.
4. **Home:** Muestra el catálogo (categorías + productos desde `mock_products`), con el nombre del usuario si está logueado.

En resumen: **Registro** (guardar usuario local) → **Login** (validar con AuthService) → **Home** solo si login es exitoso.

---

## 5. Dependencias principales (pubspec.yaml)

- **flutter** – SDK y UI.
- **provider** – Estado global (LoginProvider).
- **shared_preferences** – Persistencia local de usuarios registrados (AuthService).
- **crypto** – Hash SHA-256 de contraseñas (AuthService).
- **dio** / **http** – Preparado para futuras llamadas a API (no usado aún para auth ni BD).
- **flutter_bloc**, **equatable**, **flutter_hooks** – Disponibles para ampliar estado o lógica si se desea.

---

## 6. Resumen

| Capa        | Ubicación      | Responsabilidad |
|-------------|----------------|------------------|
| Entrada     | `main.dart`    | Iniciar la app. |
| Configuración | `app.dart`   | Provider, MaterialApp, pantalla inicial. |
| Núcleo      | `core/`        | Validadores y tema. |
| Modelos     | `models/`      | Entidades (Product, Category). |
| Datos       | `data/`        | Mock de categorías y productos. |
| Servicios   | `services/`    | Autenticación (registro y login con persistencia local). |
| Estado      | `providers/`   | Estado y orquestación del login (usa AuthService). |
| Pantallas   | `screens/`     | Login, registro, home. |
| Widgets     | `widgets/`     | Componentes reutilizables (ej. SocialButton). |
| Persistencia | `database/` + docs | Esquema MySQL y guías para Workbench (futuro backend). |

Esta arquitectura mantiene el proyecto ordenado, garantiza que solo los usuarios registrados puedan iniciar sesión, y facilita añadir nuevas pantallas o conectar un backend más adelante.
