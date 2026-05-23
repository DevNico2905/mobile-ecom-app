const path = require('path');
const fs = require('fs');

/**
 * Este archivo levanta un servidor HTTP (API) con Express y se conecta a MySQL.
 *
 * Secciones principales:
 * - Carga manual de variables de entorno desde `backend/.env` (sin usar dotenv)
 * - Creación del pool de conexiones a MySQL (mysql2/promise)
 * - Rutas:
 *   - `GET /api/health`: prueba rápida de conexión
 *   - `GET /api/debug-db`: confirma qué DB se está usando y cuenta usuarios
 *   - `POST /api/auth/register`: registro (con hash bcrypt)
 *   - `POST /api/auth/login`: login (compara bcrypt)
 *   - `GET /api/products`: lista productos desde la tabla `products`
 */

// Cargar `.env` desde la carpeta del backend.
// Nota: aquí se hace “a mano” para soportar UTF-8 y UTF-16 LE (muy común en Windows cuando el .env se guarda como Unicode).
const envPath = path.join(__dirname, '.env');
if (fs.existsSync(envPath)) {
  const buf = fs.readFileSync(envPath);

  // Detección simple de UTF-16 LE:
  // - BOM 0xFF 0xFE al inicio, o
  // - patrón típico de bytes con ceros alternados (por caracteres de 2 bytes).
  const isUtf16Le =
    (buf[0] === 0xff && buf[1] === 0xfe) ||
    (buf.length >= 4 && buf[1] === 0 && buf[3] === 0 && buf[2] !== 0);

  // Convertimos el buffer a string usando el encoding detectado.
  let content = isUtf16Le ? buf.toString('utf16le') : buf.toString('utf8');

  // Si el contenido trae BOM como caracter Unicode (U+FEFF), lo quitamos para no ensuciar la primera clave.
  if (content.length > 0 && content.charCodeAt(0) === 0xfeff) content = content.slice(1);
  content.split(/\r?\n/).forEach((line) => {
    const trimmed = line.trim();

    // Formato esperado por línea:
    // - Ignora líneas vacías
    // - Ignora comentarios que empiezan con '#'
    // - Requiere al menos un '=' para separar KEY=VALUE
    if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
      const eq = trimmed.indexOf('=');
      const key = trimmed.slice(0, eq).trim().replace(/^\uFEFF/, '');
      const value = trimmed.slice(eq + 1).trim();

      // Guardamos la variable en el entorno del proceso de Node.
      // Ej: process.env.DB_NAME, process.env.DB_USER, etc.
      process.env[key] = value;
    }
  });
}

// Validación mínima: si falta DB_NAME, el backend no puede conectarse bien.
// Se aborta para evitar que el servidor quede “arriba” pero fallando todo por configuración.
if (!process.env.DB_NAME) {
  console.error('ERROR: DB_NAME no está definido. Revisa que backend/.env contenga: DB_NAME=ecommerceflutter');
  process.exit(1);
}

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

const app = express();

// Permite que tu app (por ejemplo Flutter o un frontend web) pueda consumir la API desde otro origen.
app.use(cors());

// Permite recibir JSON en el body (req.body) en POST/PUT/PATCH.
app.use(express.json());

// Pool de conexiones:
// - Reutiliza conexiones en vez de abrir/cerrar por request
// - `mysql2/promise` permite usar async/await
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306,
});

// Debug: útil para confirmar que tu `.env` apunta a la base correcta y que la tabla `users` existe.
// IMPORTANTE: esto expone info de la DB; úsalo solo en desarrollo.
app.get('/api/debug-db', async (req, res) => {
  try {
    const conn = await pool.getConnection();
    const dbName = process.env.DB_NAME;
    let count = null;
    try {
      const [rows] = await conn.execute(
        'SELECT COUNT(*) as total FROM users',
      );
      count = rows[0].total;
    } catch (e) {
      count = 'error: ' + e.message;
    }
    conn.release();
    res.json({
      database: dbName,
      usersCount: count,
      message:
        dbName === 'ecommerceflutter'
          ? 'OK, backend usa ecommerceflutter'
          : 'CUIDADO: backend NO está usando ecommerceflutter',
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Health check: responde ok si el backend puede hablar con MySQL (ping).
app.get('/api/health', async (req, res) => {
  try {
    const conn = await pool.getConnection();
    await conn.ping();
    conn.release();
    res.json({ status: 'ok' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'error', message: err.message });
  }
});

// Registro de usuario.
// Flujo:
// - valida campos mínimos
// - verifica que email o username no existan
// - hashea contraseña con bcrypt (10 rounds)
// - inserta en tabla `users`
app.post('/api/auth/register', async (req, res) => {
  try {
    const { username, email, password, fullName } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ message: 'Faltan datos obligatorios' });
    }

    const conn = await pool.getConnection();
    try {
      const [rows] = await conn.execute(
        'SELECT id FROM users WHERE email = ? OR username = ? LIMIT 1',
        [email, username],
      );
      if (rows.length > 0) {
        return res
          .status(409)
          .json({ message: 'Ese correo o usuario ya está registrado' });
      }

      // bcrypt.hash crea una versión “irreversible” de la contraseña.
      // En la DB se guarda el hash, no la contraseña en texto plano.
      const hash = await bcrypt.hash(password, 10);

      await conn.execute(
        'INSERT INTO users (username, email, password, full_name) VALUES (?, ?, ?, ?)',
        [username, email, hash, fullName || null],
      );

      return res
        .status(201)
        .json({ message: 'Usuario registrado correctamente' });
    } finally {
      // `finally` asegura que la conexión siempre se devuelve al pool aunque haya error/return antes.
      conn.release();
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Error en el servidor' });
  }
});

// Login de usuario.
// Flujo:
// - busca el usuario por email
// - compara la contraseña del request contra el hash guardado (bcrypt.compare)
// - si coincide, devuelve datos básicos del usuario
//
// Nota: aquí NO se emiten tokens (JWT/sesión). Es un login “simple” que solo valida credenciales.
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Faltan email o contraseña' });
    }

    const conn = await pool.getConnection();
    try {
      const [rows] = await conn.execute(
        'SELECT id, username, email, password, full_name FROM users WHERE email = ? LIMIT 1',
        [email],
      );
      if (rows.length === 0) {
        return res.status(401).json({ message: 'Credenciales incorrectas' });
      }

      const user = rows[0];
      const ok = await bcrypt.compare(password, user.password);
      if (!ok) {
        return res.status(401).json({ message: 'Credenciales incorrectas' });
      }

      // Respuesta “segura”: NO devolvemos el hash de la contraseña.
      return res.json({
        id: user.id,
        username: user.username,
        email: user.email,
        fullName: user.full_name,
      });
    } finally {
      conn.release();
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Error en el servidor' });
  }
});

// Listado de productos desde MySQL.
// Espera una tabla `products` con estas columnas:
// - id, name, price, category_id, icon_name
app.get('/api/products', async (req, res) => {
  try {
    const conn = await pool.getConnection();
    try {
      const [rows] = await conn.execute(
        'SELECT id, name, price, category_id, icon_name FROM products',
      );
      return res.json(rows);
    } finally {
      conn.release();
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Error en el servidor' });
  }
});

// Arranque del servidor.
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`API escuchando en http://localhost:${port}`);
});

