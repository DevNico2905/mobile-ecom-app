-- ============================================================
-- Catálogo tecnológico para ecommerceflutter
-- 5 categorías × 10 productos = 50 productos.
--
-- Ejecuta este script en MySQL Workbench sobre la base `ecommerceflutter`
-- DESPUÉS de haber creado las tablas con `schema.sql`.
--
-- ⚠️  ATENCIÓN: este script REEMPLAZA el catálogo de demostración.
--     Vacía las tablas `products` y `categories` (TRUNCATE) y vuelve a
--     insertarlas desde cero. NO afecta a la tabla `users`.
--
-- La columna `icon_name` guarda el nombre de un icono Material; la app lo
-- traduce a un `IconData` en `lib/core/product_icons.dart`. Si añades un
-- icon_name nuevo, agrégalo también a ese mapa (si no, se usa un icono por
-- defecto).
-- ============================================================

USE ecommerceflutter;

-- ------------------------------------------------------------
-- Reinicio del catálogo (no toca usuarios)
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE products;
TRUNCATE TABLE categories;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- Categorías (5)
-- ------------------------------------------------------------
INSERT INTO categories (id, name, icon_name) VALUES
('smartphones', 'Smartphones',  'smartphone'),
('laptops',     'Laptops',      'laptop'),
('audio',       'Audio',        'headphones'),
('gaming',      'Gaming',       'sports_esports'),
('wearables',   'Wearables',    'watch');

-- ------------------------------------------------------------
-- Productos (10 por categoría)
-- ------------------------------------------------------------

-- Smartphones
INSERT INTO products (name, price, category_id, icon_name) VALUES
('iPhone 15 Pro Max',         1299.00, 'smartphones', 'smartphone'),
('Samsung Galaxy S24 Ultra',  1299.00, 'smartphones', 'smartphone'),
('Google Pixel 8 Pro',         999.00, 'smartphones', 'smartphone'),
('Xiaomi 14 Pro',              899.00, 'smartphones', 'smartphone'),
('OnePlus 12',                 799.00, 'smartphones', 'smartphone'),
('Samsung Galaxy Z Flip 5',    999.00, 'smartphones', 'smartphone'),
('Motorola Edge 50 Pro',       599.00, 'smartphones', 'smartphone'),
('Nothing Phone (2)',          699.00, 'smartphones', 'smartphone'),
('Asus ROG Phone 8 Pro',      1099.00, 'smartphones', 'smartphone'),
('Sony Xperia 1 VI',          1399.00, 'smartphones', 'smartphone');

-- Laptops
INSERT INTO products (name, price, category_id, icon_name) VALUES
('MacBook Pro 16" M3 Max',    2499.00, 'laptops', 'laptop_mac'),
('MacBook Air 15" M3',        1299.00, 'laptops', 'laptop_mac'),
('Dell XPS 15',               1799.00, 'laptops', 'laptop'),
('HP Spectre x360 14',        1499.00, 'laptops', 'laptop'),
('Lenovo ThinkPad X1 Carbon', 1699.00, 'laptops', 'laptop'),
('Asus ZenBook 14 OLED',       999.00, 'laptops', 'laptop'),
('Acer Swift Go 14',           849.00, 'laptops', 'laptop'),
('Microsoft Surface Laptop 6',1299.00, 'laptops', 'laptop'),
('Razer Blade 16',            2999.00, 'laptops', 'laptop'),
('LG Gram 17',                1599.00, 'laptops', 'laptop');

-- Audio
INSERT INTO products (name, price, category_id, icon_name) VALUES
('Apple AirPods Pro 2',        249.00, 'audio', 'headphones'),
('Sony WH-1000XM5',            399.00, 'audio', 'headphones'),
('Bose QuietComfort Ultra',    429.00, 'audio', 'headphones'),
('Sennheiser Momentum 4',      349.00, 'audio', 'headphones'),
('Apple AirPods Max',          549.00, 'audio', 'headphones'),
('Beats Studio Pro',           349.00, 'audio', 'headphones'),
('JBL Charge 5',               179.00, 'audio', 'speaker'),
('Sonos Era 100',              249.00, 'audio', 'speaker'),
('Bose SoundLink Flex',        149.00, 'audio', 'speaker'),
('Marshall Stanmore III',      379.00, 'audio', 'speaker');

-- Gaming
INSERT INTO products (name, price, category_id, icon_name) VALUES
('PlayStation 5 Slim',         499.00, 'gaming', 'sports_esports'),
('Xbox Series X',              499.00, 'gaming', 'sports_esports'),
('Nintendo Switch OLED',       349.00, 'gaming', 'videogame_asset'),
('Steam Deck OLED 1TB',        649.00, 'gaming', 'videogame_asset'),
('Meta Quest 3',               499.00, 'gaming', 'view_in_ar'),
('DualSense Edge',             199.00, 'gaming', 'sports_esports'),
('Razer Kraken V3',             99.00, 'gaming', 'headset_mic'),
('Logitech G Pro X TKL',       199.00, 'gaming', 'keyboard'),
('Razer DeathAdder V3 Pro',    149.00, 'gaming', 'mouse'),
('Elgato Stream Deck MK.2',    149.00, 'gaming', 'videogame_asset');

-- Wearables
INSERT INTO products (name, price, category_id, icon_name) VALUES
('Apple Watch Series 9',       399.00, 'wearables', 'watch'),
('Apple Watch Ultra 2',        799.00, 'wearables', 'watch'),
('Samsung Galaxy Watch 6',     329.00, 'wearables', 'watch'),
('Garmin Fenix 7 Pro',         799.00, 'wearables', 'watch'),
('Google Pixel Watch 2',       349.00, 'wearables', 'watch'),
('Amazfit GTR 4',              199.00, 'wearables', 'watch'),
('Fitbit Charge 6',            159.00, 'wearables', 'monitor_heart'),
('Whoop 4.0',                  239.00, 'wearables', 'monitor_heart'),
('Oura Ring Gen 3',            299.00, 'wearables', 'monitor_heart'),
('Ray-Ban Meta Smart Glasses', 329.00, 'wearables', 'visibility');
