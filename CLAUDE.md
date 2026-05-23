# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Flutter e-commerce app (login, registration, product catalog) backed by a small
Node.js/Express + MySQL API. The repo root is the Flutter project; the API lives in
`backend/`. Project code, comments, and docs are in Spanish — match that when editing.

## Commands

Flutter (run from repo root):

```bash
flutter pub get                       # install Dart deps (after changing pubspec.yaml)
flutter run -d chrome                 # run the app (Chrome is the primary target)
flutter analyze                       # lint / static analysis (flutter_lints)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
```

Backend (run from `backend/`):

```bash
npm install      # first time only
node index.js    # starts the API on http://localhost:3000
```

There is no `npm test` for the backend (the script is a placeholder that exits 1).

## Running the full stack

The app does not work standalone for auth — it calls the backend, which needs MySQL.

1. **MySQL**: have the `ecommerceflutter` database created and run `database/schema.sql`
   (creates `users`, `categories`, `products` and seeds catalog rows). See
   `README_baseedatos.md` / `database/README.md`.
2. **Backend**: `cd backend && node index.js`. Reads MySQL credentials from `backend/.env`
   (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_PORT`). It refuses to start if
   `DB_NAME` is unset. Sanity-check the connection at `GET /api/debug-db` (reports which DB
   is in use and the user count) and `GET /api/health`.
3. **Flutter**: `flutter run -d chrome`.

## Architecture

**Frontend (`lib/`)** is layered by responsibility:

- `main.dart` → `runApp` only; `app.dart` wires `ChangeNotifierProvider<LoginProvider>`
  + `MaterialApp`, with `LoginScreen` as the initial route.
- `services/auth_service.dart` — the single point of contact with the backend. Static
  `AuthService` using **Dio** against `_baseUrl = http://localhost:3000/api`
  (`POST /auth/register`, `POST /auth/login`). It returns plain `bool`s and swallows errors
  (treats any failure/non-2xx as "false") so the UI never hangs.
- `providers/login_provider.dart` — login form state (`ChangeNotifier`); `loginNormal()`
  delegates to `AuthService.login` and drives SnackBars. Screens navigate to Home only when
  it returns `true`. Google/Facebook buttons are simulated (SnackBar only).
- `screens/` — `login_screen`, `registration_screen`, `home_screen`.
- `core/` — `validators.dart` (shared form validation) and `app_theme.dart` (colors,
  gradients, `InputDecoration`).
- `data/mock_products.dart` + `models/product.dart` — **the catalog is local mock data.**
  `home_screen` reads from `mock_products`; it does **not** call `GET /api/products`. That
  backend route exists but is currently unused by the app.

**Backend (`backend/index.js`)** is a single-file Express API: manual `.env` loading, a
`mysql2/promise` connection pool, and routes for health/debug, auth, and products. Auth uses
**bcrypt** hashing (`bcryptjs`). Login validates credentials only — there are no JWTs or
sessions; the login response returns the user fields but the frontend does not persist them
(so the Home greeting shows whatever `username` was typed into the login form).

### Two important gotchas

- **`backend/.env` is UTF-16 LE encoded** (not UTF-8). `index.js` deliberately parses
  `.env` by hand (detecting UTF-16/BOM) instead of using `dotenv`, because `dotenv` failed to
  load this file on Windows. Note: `dotenv` is still in `package.json` but is not used. If you
  edit `.env`, preserve its encoding or update the parser accordingly. Standard UTF-8 tools
  (`cat`, `sed`) will error on this file.
- **The top-level docs are stale.** `README.md` and `arquitectura.md` describe an
  earlier design (local-only auth via SharedPreferences + SHA-256 `crypto`). The current code
  uses the Node/MySQL backend with bcrypt instead. `DIAGNOSTICO.md` and `pasoapaso.md` are the
  up-to-date references. `shared_preferences`/`crypto` remain in `pubspec.yaml` but are no
  longer used for auth.
