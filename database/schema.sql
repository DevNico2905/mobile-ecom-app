-- ============================================================
-- Esquema de base de datos para ecommerceflutter
-- Ejecuta este script en MySQL Workbench para crear las tablas
-- que guardan la información según los modelos de la app.
-- ============================================================

-- Usar la base de datos (ya debe existir: CREATE DATABASE ecommerceflutter;)
USE ecommerceflutter;

-- ------------------------------------------------------------
-- Tabla: users (modelo User - login/registro)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- Tabla: categories (modelo Category)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  icon_name VARCHAR(50) DEFAULT 'apps'
);

-- ------------------------------------------------------------
-- Tabla: products (modelo Product)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category_id VARCHAR(50) NOT NULL,
  icon_name VARCHAR(50) DEFAULT 'shopping_bag',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Datos iniciales: categorías
-- ------------------------------------------------------------
INSERT IGNORE INTO categories (id, name, icon_name) VALUES
('all', 'Todos', 'apps'),
('electronics', 'Electrónica', 'devices'),
('clothing', 'Ropa', 'checkroom'),
('home', 'Hogar', 'home'),
('sports', 'Deportes', 'sports_soccer');

-- ------------------------------------------------------------
-- Datos iniciales: productos de ejemplo
-- ------------------------------------------------------------
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
