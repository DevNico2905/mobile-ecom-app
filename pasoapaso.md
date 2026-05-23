# Paso a paso: app e-commerce en Flutter (desde cero)

Esta guía está pensada para **alguien que no sabe programar**. Si sigues los pasos **en orden** y no te saltas ninguno, al final podrás **abrir la aplicación en tu computador**, registrarte, iniciar sesión y ver la tienda.

**Qué vas a obtener:** una app con pantalla de **login**, **registro** (los datos se guardan en el dispositivo), y un **inicio (Home)** con categorías y productos de ejemplo.

**Importante:** el código completo de cada archivo (para copiar y pegar) está en **`README_TUTORIAL.md`**, en secciones llamadas PARTE 0, PARTE 1, etc. **Este archivo (`pasoapaso.md`) te dice qué hacer y en qué orden**; cuando toque escribir código, abres `README_TUTORIAL.md` en la parte que te indico. Así no repetimos cientos de líneas en dos sitios.

**No necesitas MySQL ni base de datos** para que la app funcione. La carpeta `database/` y los README de MySQL son para un futuro servidor; la app usa guardado local en el teléfono o navegador.

---

## Antes de empezar: tres ideas muy simples

| Concepto | Qué es, en pocas palabras |
|----------|---------------------------|
| **Flutter** | Herramienta de Google para crear apps que pueden verse en navegador, Android, Windows, etc. |
| **Proyecto** | Una carpeta con muchos archivos; la app vive ahí. |
| **Terminal** | Ventana negra o azul donde escribes comandos y pulsas Enter; Flutter se controla así además del editor. |

Si algo no te sale igual que en las capturas mentales: **relee el paso**, comprueba que no te falte guardar un archivo (Ctrl+S) y que estés en la carpeta correcta de la terminal.

---

## Ruta A: Ya tengo la carpeta `project` completa (por USB, ZIP o clase)

Si **ya** tienes todos los archivos (como en este repositorio/carpeta de la universidad):

1. Instala Flutter y un editor (más abajo, **Pasos 1 a 3**), y ejecuta `flutter doctor` hasta que no haya errores graves.
2. Abre la carpeta del proyecto en VS Code o Cursor (donde está `pubspec.yaml`).
3. En la terminal, entra a esa carpeta y ejecuta:
   ```bash
   cd C:\Users\johan\Documents\UNIBAGUE\project
   flutter pub get
   flutter run -d chrome
   ```
   (Cambia la ruta si tu proyecto está en otro sitio.)
4. Sigue **“Último tramo: ejecutar y probar”** al final de este documento.

Si **no** tienes el código y quieres **construirlo tú desde cero**, sigue la **Ruta B** completa.

---

## Ruta B: Crear la aplicación desde cero (paso a paso completo)

### Paso 1 – Instalar Flutter

1. Abre el navegador y entra a la guía oficial: [Instalar Flutter](https://docs.flutter.dev/get-started/install).
2. Elige **Windows** (o tu sistema) y sigue las instrucciones.
3. En Windows sueles **descargar un ZIP**, descomprimirlo en una carpeta **sin espacios** en la ruta, por ejemplo `C:\flutter` (evita `C:\Program Files\...`).
4. **Añade Flutter al PATH** (Variables de entorno → Path → añade la carpeta `bin` de Flutter, por ejemplo `C:\flutter\bin`). Acepta todo.
5. **Cierra y vuelve a abrir** la terminal (PowerShell o CMD).
6. Escribe:
   ```bash
   flutter doctor
   ```
7. Lee lo que sale: si pide **Chrome** o **Android toolchain**, instala lo que indique (para empezar, **Chrome** es suficiente para `flutter run -d chrome`).

**Más detalle:** `README_TUTORIAL.md` → **PARTE 1**.

---

### Paso 2 – Instalar un editor (Visual Studio Code o Cursor)

1. Descarga **VS Code**: [code.visualstudio.com](https://code.visualstudio.com).
2. Instálalo y ábrelo.
3. Ve a **Extensiones**, busca **Flutter** e instala la extensión oficial (te pedirá **Dart**; acepta).

**Cursor** también sirve: es similar a VS Code; si ya lo usas, instala la extensión **Flutter** igual que arriba.

---

### Paso 3 – Comprobar que Flutter responde

En una terminal nueva:

```bash
flutter doctor
flutter devices
```

Deberías ver al menos un dispositivo (por ejemplo **Chrome**). Si `flutter devices` no muestra nada útil, instala Chrome o revisa la salida de `flutter doctor`.

---

### Paso 4 – Crear el proyecto vacío

1. Decide dónde guardar el proyecto, por ejemplo `C:\Users\TuNombre\Documents`.
2. En la terminal:
   ```bash
   cd C:\Users\TuNombre\Documents
   flutter create project
   cd project
   ```
3. Si la carpeta `project` **ya existe** y no quieres borrarla, usa otro nombre: `flutter create mi_tienda` y entra con `cd mi_tienda`.

**Más detalle:** `README_TUTORIAL.md` → **PARTE 2**.

---

### Paso 5 – Dependencias del proyecto (`pubspec.yaml`)

1. Abre en el editor el archivo **`pubspec.yaml`** (está en la raíz del proyecto, al mismo nivel que la carpeta `lib`).
2. Asegúrate de que en `dependencies:` estén al menos los paquetes que usa la app: `provider`, `shared_preferences`, `crypto`, y lo que ya trae Flutter. Puedes copiar el bloque exacto de **`README_TUTORIAL.md` → PARTE 3**.
3. Guarda el archivo.
4. En la terminal (dentro de la carpeta del proyecto):
   ```bash
   flutter pub get
   ```
5. Debe aparecer algo como **Got dependencies**.

---

### Paso 6 – Carpetas dentro de `lib`

Dentro de **`lib`**, crea estas carpetas (clic derecho → nueva carpeta, o desde el explorador de archivos):

- `core`
- `models`
- `data`
- `services`
- `providers`
- `screens`
- `widgets`

**Más detalle:** `README_TUTORIAL.md` → **PARTE 4**.

---

### Paso 7 al 16 – Crear cada archivo con su código

Aquí **no** pegamos el código en este archivo: lo haces desde **`README_TUTORIAL.md`**, **en este orden** (así los `import` no fallan):

| Orden | Archivo | Abre en README_TUTORIAL |
|------|---------|-------------------------|
| 1 | `lib/main.dart` | **PARTE 5** |
| 2 | `lib/app.dart` | **PARTE 6** |
| 3 | `lib/core/validators.dart` | **PARTE 7** |
| 4 | `lib/core/app_theme.dart` | **PARTE 8** |
| 5 | `lib/models/product.dart` | **PARTE 9** |
| 6 | `lib/data/mock_products.dart` | **PARTE 10** |
| 7 | `lib/services/auth_service.dart` | **PARTE 11** |
| 8 | `lib/providers/login_provider.dart` | **PARTE 12** |
| 9 | `lib/widgets/social_button.dart` | **PARTE 13** |
| 10 | `lib/screens/login_screen.dart` | **PARTE 14** |
| 11 | `lib/screens/registration_screen.dart` | **PARTE 15** |
| 12 | `lib/screens/home_screen.dart` | **PARTE 16** |

**Cómo hacerlo bien:**

1. Abre `README_TUTORIAL.md` en la PARTE indicada.
2. Crea el archivo si no existe (misma ruta y nombre).
3. **Borra** el contenido por defecto si es un archivo que Flutter generó y debes reemplazarlo (como `main.dart`).
4. **Copia todo** el bloque de código del tutorial y **pégalo**.
5. Guarda (Ctrl+S).
6. Pasa al siguiente archivo de la tabla.

Si el editor muestra **líneas rojas**, suele ser porque falta un archivo posterior o un `import` mal escrito; repasa que el orden de la tabla sea exacto.

**Lista de comprobación** (es la misma idea que PARTE 17 del tutorial): `README_TUTORIAL.md` → **PARTE 17**.

---

## Último tramo: ejecutar y probar

### Ejecutar la app

1. Terminal en la carpeta del proyecto (donde está `pubspec.yaml`):
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
2. La primera vez puede tardar varios minutos.
3. Si no quieres Chrome, ejecuta `flutter run` y elige el número del dispositivo que te liste.

**Alternativa:** VS Code / Cursor → abre la carpeta del proyecto → barra inferior: elige dispositivo → **F5** (depurar Flutter).

**Más opciones y fallos frecuentes:** `ejecutar.md` y `README_TUTORIAL.md` → **PARTE 18**.

---

### Probar que “te sirve” (flujo real)

1. Al abrir la app verás **Iniciar sesión**.
2. Pulsa **Regístrate** y crea una cuenta (nombre, correo, contraseña según las reglas del formulario).
3. Vuelve al login e inicia sesión con el **mismo correo y contraseña**.
4. Deberías entrar al **Home** y ver categorías y productos.

**Reglas típicas** (resumen): usuario con formato válido, correo bien escrito, contraseña con requisitos que pide la app. Detalle completo: `README_TUTORIAL.md` → **PARTE 19**.

---

## Si algo sale mal (tabla rápida)

| Síntoma | Qué probar |
|---------|-------------|
| `flutter` no se reconoce | PATH mal puesto o terminal vieja; reinicia terminal y revisa variables de entorno. |
| No hay dispositivos | Instala Chrome; ejecuta `flutter devices`. |
| Error de paquetes | En la carpeta del proyecto: `flutter pub get`. |
| Archivo no encontrado en rojo | Revisa que existan los 12 archivos de la tabla y en ese orden. |
| La app no entra al Home sin registrarse | Es correcto: primero **Regístrate**, luego login. |

---

## Después, si quieres entender el “mapa” del proyecto

Cuando ya te funcione, puedes leer **`arquitectura.md`**: explica qué hace cada carpeta (`core`, `services`, `screens`, etc.) sin tener que memorizarlo antes de construir la app.

---

## Resumen de una línea

**Instala Flutter → crea proyecto → `pubspec` + `flutter pub get` → crea carpetas en `lib` → copia los 12 archivos en orden desde `README_TUTORIAL` PARTES 5–16 → `flutter run -d chrome` → regístrate y entra.**
