# Configurar la base de datos en MySQL Workbench

Sigue estos pasos para crear y configurar la base de datos **ecommerceflutter** en MySQL Workbench. Este esquema está pensado para un **backend futuro** (API REST, etc.). La app Flutter actual usa **autenticación local** (SharedPreferences) para registro e inicio de sesión; los usuarios se guardan en el dispositivo, no en MySQL.

---

## 1. Conectar al servidor

1. Abre **MySQL Workbench**.
2. En la pantalla principal, haz clic en tu conexión (por ejemplo **Local instance MySQL80**).
3. Usa estas credenciales:
   - **Usuario:** `root`
   - **Contraseña:** `admin`
   - **Host:** `localhost`
   - **Puerto:** `3306`

---

## 2. Crear la base de datos (si aún no existe)

1. En el editor de consultas (panel derecho), escribe:

```sql
CREATE DATABASE IF NOT EXISTS ecommerceflutter;
```

2. Haz clic en el **rayo** (Execute) o presiona `Ctrl + Shift + Enter`.
3. En el panel izquierdo (**Navigator → SCHEMAS**), actualiza con el botón de refresco y verifica que aparezca **ecommerceflutter**.

---

## 3. Seleccionar la base de datos

En una nueva pestaña o en el mismo editor, ejecuta:

```sql
USE ecommerceflutter;
```

Vuelve a ejecutar con el rayo. A partir de aquí todas las órdenes se aplican a `ecommerceflutter`.

---

## 4. Crear la tabla de usuarios

Copia y ejecuta:

```sql
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 5. Crear la tabla de categorías

```sql
CREATE TABLE IF NOT EXISTS categories (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  icon_name VARCHAR(50) DEFAULT 'apps'
);
```

---

## 6. Crear la tabla de productos

```sql
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category_id VARCHAR(50) NOT NULL,
  icon_name VARCHAR(50) DEFAULT 'shopping_bag',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);
```

---

## 7. Insertar categorías iniciales

```sql
INSERT IGNORE INTO categories (id, name, icon_name) VALUES
('all', 'Todos', 'apps'),
('electronics', 'Electrónica', 'devices'),
('clothing', 'Ropa', 'checkroom'),
('home', 'Hogar', 'home'),
('sports', 'Deportes', 'sports_soccer');
```

---

## 8. Insertar productos de ejemplo

```sql
INSERT IGNORE INTO products (name, price, category_id, icon_name) VALUES
('Audífonos inalámbricos', 89.99, 'electronics', 'headphones'),
('Smartwatch', 149.99, 'electronics', 'watch'),
('Camiseta básica', 24.99, 'clothing', 'checkroom'),
('Pantalón jeans', 59.99, 'clothing', 'checkroom'),
('Lámpara LED', 34.99, 'home', 'lightbulb_outline'),
('Set de sábanas', 45.99, 'home', 'bed'),
('Balón de fútbol', 29.99, 'sports', 'sports_soccer'),
('Mochila deportiva', 54.99, 'sports', 'backpack'),
('Teclado mecánico', 119.99, 'electronics', 'keyboard');
```

---

## 9. Comprobar que todo está bien

En **Navigator → SCHEMAS → ecommerceflutter → Tables** deberías ver:

- **users**
- **categories**
- **products**

Para ver los datos:

```sql
SELECT * FROM categories;
SELECT * FROM products;
```

---

## Resumen

| Paso | Acción |
|------|--------|
| 1 | Conectar con root / admin en localhost:3306 |
| 2 | `CREATE DATABASE IF NOT EXISTS ecommerceflutter;` |
| 3 | `USE ecommerceflutter;` |
| 4 | Crear tabla `users` |
| 5 | Crear tabla `categories` |
| 6 | Crear tabla `products` |
| 7 | Insertar categorías |
| 8 | Insertar productos |
| 9 | Revisar tablas y datos |

Si prefieres ejecutar todo de una vez, abre el archivo **`database/schema.sql`** en Workbench y ejecuta el script completo.

**Nota:** La app Flutter actual no lee ni escribe en esta base de datos; el login y registro usan almacenamiento local (SharedPreferences). Este esquema sirve para cuando implementes un backend que la app consuma por API.
