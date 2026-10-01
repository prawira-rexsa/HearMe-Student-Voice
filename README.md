# HearMe: Student Voice

Platform aspirasi dan pengaduan mahasiswa berbasis Flutter + Firebase.  
Mahasiswa submit laporan → admin kurasi (Approve/Reject) → laporan disetujui tampil publik.

---

## Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | Flutter 3.x / Dart |
| Autentikasi | Cloud Firestore (login manual via NPM) |
| Database user | Cloud Firestore |
| Database complaint | [MockAPI](https://mockapi.io) REST API |
| State/session | SharedPreferences |

## Features

- Submit laporan/aspirasi oleh mahasiswa (judul + deskripsi)
- Admin dapat Approve / Reject setiap laporan
- Laporan yang disetujui tampil di halaman publik
- Laporan yang ditolak disembunyikan dari publik
- Autentikasi berbasis role: `user` dan `admin`
- Sesi login persisten via SharedPreferences
- Splash screen otomatis redirect sesuai role

## Architecture

```
┌─────────────┐     login/register      ┌──────────────────┐
│   Flutter   │ ──────────────────────▶ │  Cloud Firestore  │
│     App     │                         │  (users collection)│
│             │     CRUD complaint      ┌──────────────────┐
│             │ ──────────────────────▶ │    MockAPI        │
└─────────────┘                         │  (complaints)     │
                                        └──────────────────┘
```

---

## Prerequisites

- Flutter SDK `^3.11.1`
- Firebase project (Firestore enabled)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- Akun [MockAPI](https://mockapi.io) (gratis)

---

## Setup

### 1. Clone & Install

```bash
git clone https://github.com/prawira-rexsa/HearMe-Student-Voice.git
cd HearMe-Student-Voice
flutter pub get
```

### 2. Setup Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login Firebase
firebase login

# Generate firebase_options.dart (ikuti prompt, pilih project kamu)
flutterfire configure
```

> File `firebase_options.dart` dan `google-services.json` **tidak ada di repo** (gitignored).  
> Lihat `lib/firebase_options.dart.example` dan `android/app/google-services.json.example` sebagai referensi.

Pastikan Firestore sudah diaktifkan di Firebase Console, lalu buat collection `users` dengan rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{npm} {
      allow read, write: if true; // sesuaikan rules untuk production
    }
  }
}
```

Untuk membuat akun admin, tambahkan dokumen manual di Firestore:

```
Collection: users
Document ID: npm_admin (NPM yang dipakai login)
Fields:
  npm: "npm_admin"
  password: "passwordkamu"
  role: "admin"
  createdAt: (timestamp)
```

### 3. Setup MockAPI

1. Buka [mockapi.io](https://mockapi.io) → buat project baru
2. Buat resource baru dengan nama `complaint`
3. Tambahkan fields berikut:

| Field | Type |
|---|---|
| `id` | String (auto) |
| `title` | String |
| `description` | String |
| `status` | Boolean |
| `npm` | String |

4. Salin endpoint URL-nya, lalu update di [`lib/services/api_service.dart`](lib/services/api_service.dart):

```dart
static const String baseUrl =
    'https://YOUR_MOCKAPI_ID.mockapi.io/api/v1/complaint';
```

### 4. Jalankan App

```bash
flutter run
```

---

## Data Schema

### Firestore — `users/{npm}`

```json
{
  "npm": "12345678",
  "password": "plaintext_password",
  "role": "user",
  "createdAt": "<timestamp>"
}
```

> `role` bisa bernilai `"user"` atau `"admin"`.

### MockAPI — `complaint`

```json
{
  "id": "1",
  "title": "Judul laporan",
  "description": "Isi laporan lengkap",
  "status": false,
  "npm": "12345678"
}
```

> `status: false` = pending/ditolak, `status: true` = disetujui (tampil publik).

---

## Project Structure

```
HearMe-Student-Voice/
├── firebase.json.example              # template config Firebase CLI
├── lib/
│   ├── firebase_options.dart          # ⚠️ gitignored — generate via flutterfire
│   ├── firebase_options.dart.example  # referensi struktur
│   ├── main.dart
│   ├── models/
│   │   └── complaint.dart             # model data complaint
│   ├── screens/
│   │   ├── splash_page.dart           # auto-redirect sesuai session
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── home_page.dart             # halaman mahasiswa
│   │   └── admin_page.dart            # halaman admin (approve/reject)
│   └── services/
│       ├── auth_service.dart          # login, register, session (Firestore)
│       └── api_service.dart           # CRUD complaint (MockAPI)
└── android/
    └── app/
        ├── google-services.json       # ⚠️ gitignored — dari Firebase Console
        └── google-services.json.example
```

---

## License

MIT
