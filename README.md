# HearMe: Student Voice

Platform aspirasi dan pengaduan mahasiswa. Setiap laporan dikurasi admin sebelum tampil di halaman publik.

---

## Tech Stack

- Flutter
- Firebase (Auth, Firestore)
- Dart

## Features

- Mahasiswa bisa submit laporan/aspirasi
- Admin dapat Approve / Reject laporan
- Laporan yang disetujui tampil di halaman publik
- Autentikasi berbasis role (mahasiswa & admin)

## Getting Started

```bash
git clone https://github.com/prawira-rexsa/HearMe-Student-Voice.git
cd HearMe-Student-Voice
flutter pub get
flutter run
```

> Pastikan sudah setup Firebase project dan letakkan `google-services.json` di folder `android/app/`.

## Structure

```
lib/
├── models/
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
