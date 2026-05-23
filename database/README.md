# Base de datos – ecommerceflutter

Aquí se define el **esquema** de la base de datos para que la información se guarde según los modelos de la app cuando exista un **backend** (API) que lo use.

## Autenticación en la app

La app Flutter actual **no** se conecta a MySQL. El **registro** y el **login** usan **autenticación local**: los usuarios se guardan en el dispositivo con **SharedPreferences** (servicio `lib/services/auth_service.dart`). Las contraseñas se almacenan hasheadas (SHA-256). Este esquema MySQL está preparado para cuando implementes un servidor (API REST, etc.) que gestione usuarios, categorías y productos en esta base.

## Dónde crear la base de datos

1. **MySQL Workbench**  
   - Abre MySQL Workbench y conecta con tu servidor (root / admin / localhost:3306).  
   - Crea la base de datos si no existe: `CREATE DATABASE ecommerceflutter;`  
   - Selecciona la base `ecommerceflutter`.  
   - Abre el archivo `schema.sql` y ejecuta todo el script (Execute o ⚡).  
   Así se crean las tablas y los datos iniciales.

2. **Resultado**  
   - Quedarán creadas las tablas: `users`, `categories`, `products`.  
   - La información que un futuro backend guarde desde la app (o desde un panel de administración) se persistirá en esas tablas.

## Cómo se relaciona con los modelos de la app

| Modelo en Flutter (Dart) | Tabla en MySQL   | Descripción                          |
|--------------------------|------------------|--------------------------------------|
| User (login/registro)    | `users`          | Usuario, email, contraseña, nombre   |
| Category                 | `categories`     | id, nombre, icono (guardado como texto) |
| Product                  | `products`       | id, nombre, precio, categoría, icono |

- Los **modelos** en `lib/models/` son las clases Dart (por ejemplo `Product`, `Category`).  
- Las **tablas** en MySQL son donde un backend guardaría esa misma información de forma persistente.  
- Cuando tengas un backend (API), él leerá/escribirá en MySQL y la app enviará/recibirá datos que se mapean a esos modelos.

## Archivos en esta carpeta

- **`schema.sql`** – Script para crear tablas y datos iniciales. Ejecútalo en MySQL Workbench sobre la base `ecommerceflutter`.

Para la guía paso a paso de configuración en MySQL Workbench, ver **`README_baseedatos.md`** en la raíz del proyecto.
