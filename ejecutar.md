# Cómo ejecutar la app en vivo

Guía paso a paso para ver la aplicación funcionando en tu computador (login, registro y pantalla principal de tienda). La app usa **autenticación real**: solo puedes iniciar sesión si antes te has registrado.

---

## Requisitos previos

- **Flutter** instalado y en el PATH (si no lo tienes, sigue la PARTE 1 del `README_TUTORIAL.md`).
- Haber creado el proyecto y los archivos según el tutorial (o tener ya el código en la carpeta `project`).
- En la terminal, `flutter doctor` debe mostrar que Flutter está correcto (y al menos Chrome o Android para poder ejecutar).

---

## Paso 1: Abrir la carpeta del proyecto

1. Abre **PowerShell** o **CMD** (o la terminal integrada de VS Code).
2. Navega hasta la carpeta del proyecto. Por ejemplo, si está en tus Documentos:

   ```bash
   cd C:\Users\johan\Documents\UNIBAGUE\project
   ```

   Ajusta la ruta si tu proyecto está en otra ubicación.

---

## Paso 2: Instalar dependencias

Antes de ejecutar, asegúrate de tener las dependencias descargadas:

```bash
flutter pub get
```

Debe aparecer algo como **"Got dependencies"**. Si sale un error, revisa que el archivo `pubspec.yaml` tenga las dependencias correctas (provider, shared_preferences, crypto, etc. — ver PARTE 3 del tutorial).

---

## Paso 3: Ejecutar la aplicación

### Opción A – Desde la terminal

1. En la misma carpeta del proyecto, ejecuta:

   ```bash
   flutter run
   ```

2. Si tienes **varios dispositivos** (Chrome, emulador Android, etc.), Flutter te preguntará en cuál quieres ejecutar. Escribe el número que corresponda y Enter.

3. **Para abrir directamente en Chrome** (navegador):

   ```bash
   flutter run -d chrome
   ```

4. **Para abrir en un emulador Android**: primero inicia el emulador desde Android Studio o con `flutter emulators --launch <nombre_emulador>`, y luego ejecuta `flutter run` (o `flutter run -d <id_dispositivo>`).

La primera vez puede tardar más (compilación). Cuando termine, se abrirá la app: verás la **pantalla de inicio de sesión**.

---

### Opción B – Desde VS Code

1. Abre **VS Code**.
2. Menú **Archivo → Abrir carpeta** y selecciona la carpeta `project` (donde está `pubspec.yaml`).
3. En la **barra inferior** de VS Code verás el selector de dispositivo (Chrome, Android, etc.). Haz clic y elige dónde quieres ejecutar (por ejemplo **Chrome**).
4. Pulsa **F5** o ve a **Run and Debug** (icono de “play” con insecto) y ejecuta **Flutter**.

La app se compilará y se abrirá en el dispositivo elegido.

---

## Paso 4: Qué verás cuando esté en vivo

1. **Pantalla de login**  
   Campos: usuario, correo y contraseña, botón **Ingresar** y enlace **Regístrate**. Botones de **Google** y **Facebook** (simulados).

2. **Registro primero (obligatorio)**  
   - Pulsa **Regístrate**.
   - Completa nombre completo, correo y contraseña (y confirmar contraseña).
   - Pulsa **Registrarse**. Si el correo no está usado, verás "Cuenta creada correctamente. Ya puedes iniciar sesión." y volverás al login.
   - Si el correo ya está registrado, verás un mensaje en rojo pidiendo usar otro o iniciar sesión.

3. **Probar el login**  
   - Usa el **mismo correo y contraseña** con los que te registraste.
   - Usuario: al menos 3 caracteres (letras, números, `_`).
   - Correo: formato válido (ej: `nombre@correo.com`).
   - Contraseña: mínimo 6 caracteres, una mayúscula, una minúscula y un número.  
   - Pulsa **Ingresar**. Si las credenciales son correctas, pasarás al **Home** con un mensaje de bienvenida.
   - Si no estás registrado o la contraseña es incorrecta, verás un mensaje en rojo: *"Credenciales incorrectas o no estás registrado. Regístrate primero."* y **no** entrarás al Home.

4. **En el Home**  
   Verás categorías (Todos, Electrónica, Ropa, Hogar, Deportes) y productos de ejemplo. Puedes tocar una categoría para filtrar.

---

## Si algo falla

| Problema | Qué hacer |
|----------|-----------|
| **"No se encuentra el paquete provider"** (o shared_preferences, crypto) | En la carpeta del proyecto: `flutter pub get`. |
| Errores en imports (archivo no encontrado) | Revisa que existan todas las carpetas y archivos de `lib/` (incluida `lib/services/auth_service.dart`) y que las rutas en los `import` sean correctas. |
| **"No devices found"** | Instala Chrome o un emulador Android. Para Chrome: `flutter run -d chrome`. Para ver dispositivos: `flutter devices`. |
| La app no compila (errores en rojo) | Ejecuta `flutter pub get`. Revisa que no falte ningún archivo de `lib/` (core, models, data, providers, services, screens, widgets) y que no haya errores de sintaxis. |

---

## Resumen rápido

```bash
cd C:\Users\johan\Documents\UNIBAGUE\project
flutter pub get
flutter run -d chrome
```

1. **Regístrate** con nombre, correo y contraseña.
2. **Inicia sesión** con ese mismo correo y contraseña.
3. Con eso la app te dejará entrar al Home y ver la tienda.
