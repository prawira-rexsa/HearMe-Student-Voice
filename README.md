# HearMe: Student Voice

Platform aspirasi dan pengaduan mahasiswa berbasis Flutter + Firebase. Mahasiswa submit laporan, admin kurasi (Approve/Reject), laporan yang disetujui tampil di halaman publik.

---

## Tech Stack

- Flutter 3.x
- Firebase Auth (custom — login via NPM & password di Firestore)
- Cloud Firestore
- MockAPI (untuk data complaint)
- Dart

## Features

- Submit laporan/aspirasi oleh mahasiswa
- Admin dapat Approve / Reject setiap laporan
- Laporan yang disetujui tampil di halaman publik
- Autentikasi berbasis role: `user` dan `admin`
- Sesi login persisten via SharedPreferences
- Splash screen otomatis redirect sesuai role

## Prerequisites

- Flutter SDK `^3.11.1`
- Firebase project (Firestore enabled)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

## Getting Started

```bash
git clone https://github.com/prawira-rexsa/HearMe-Student-Voice.git
cd HearMe-Student-Voice
flutter pub get
```

Setup Firebase:

```bash
# Login ke Firebase
firebase login

# Init FlutterFire dan generate firebase_options.dart
flutterfire configure
```

> File `firebase_options.dart` tidak di-include di repo karena berisi API keys.
> Lihat `lib/firebase_options.dart.example` sebagai referensi struktur file-nya.

Jalankan app:

```bash
flutter run
```

## Firestore Structure

```
users/
└── {npm}/
    ├── npm: string
    ├── password: string
    ├── role: "user" | "admin"
    └── createdAt: timestamp
```

> Data complaint disimpan di MockAPI, bukan Firestore.

## Structure

```
lib/
├── firebase_options.dart       # ⚠️ tidak di-commit (gitignored)
├── firebase_options.dart.example
├── main.dart
├── models/
│   └── complaint.dart
├── screens/
│   ├── splash_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   └── admin_page.dart
└── services/
    ├── auth_service.dart
    └── api_service.dart
```

## License

MIT
