# UKK RPL — Aplikasi Pengaduan Sekolah

## Identitas Project
- **Nama Peserta:** [isi nama lengkap]
- **Kelas:** [isi kelas]
- **Judul Project:** Aplikasi Pengaduan Sekolah — SMA SEWON
- **Studi Kasus:** Sistem pengaduan/aspirasi siswa di lingkungan sekolah

## Gambaran Umum
Project terdiri dari **satu aplikasi Flutter** (folder `aplikasi`) yang melayani tiga peran — siswa, petugas, dan admin — dengan backend Firebase yang sama:

1. **Siswa** — mendaftar, login, mengirim dan memantau aspirasi.
2. **Petugas** — menangani aspirasi yang masuk dan mengunggah bukti penyelesaian.
3. **Admin** — memantau statistik, mengubah status, memberi tanggapan, dan mencetak laporan.

Aplikasi menggunakan Cloud Firestore sebagai database. Terdapat Cloud Function untuk mengirim notifikasi (folder `aplikasi/functions`).

## Teknologi
- Frontend: Flutter / Dart
- Backend/Platform: Firebase
- Database: Cloud Firestore
- Notifikasi: Cloud Functions / Firebase Cloud Messaging dan notifikasi lokal
- Paket utama: `fl_chart` (grafik), `pdf` dan `printing` (cetak laporan), `image_picker` (foto bukti), `video_player` (video latar halaman awal), `shared_preferences` (sesi login)

## Fitur yang teridentifikasi pada source
### Siswa
- Halaman awal (landing) dan halaman bantuan
- Registrasi dan login siswa menggunakan NIS
- Pengiriman aspirasi/pengaduan: kategori, lokasi, keterangan, dan foto bukti
- Riwayat aspirasi dan pemantauan status pengaduan
- Notifikasi perubahan status
- Rating (1–5) setelah aspirasi berstatus `Selesai`

### Petugas
- Login petugas
- Dashboard tugas dan penanganan aspirasi
- Unggah foto bukti setelah pengaduan selesai ditangani

### Admin
- Login admin
- Dashboard dan statistik status aspirasi (pie chart)
- Melihat detail aspirasi
- Mengubah status dan memberi tanggapan (feedback)
- Cetak laporan dalam format PDF

## Struktur Repository
```text
ukk-rpl-pengaduan-sekolah/
├── README.md
├── aplikasi/
│   ├── lib/          # source Dart (models, screens, services)
│   ├── functions/    # Cloud Function notifikasi
│   ├── assets/       # gambar dan video
│   ├── android/ ios/ web/
│   └── pubspec.yaml
├── database/
│   ├── firestore-structure.md
│   └── firebase-setup.md
└── docs/
    └── screenshots/
```

## Database
Project menggunakan Cloud Firestore. Dokumentasi collection dan field yang teridentifikasi dari source tersedia di `database/firestore-structure.md`.

Collection utama: `aspirasi`, `siswa`, `petugas`, `admin`, dan `notifications`.

## Cara Menjalankan
### Aplikasi
1. Buka folder `aplikasi`.
2. Isi konfigurasi Firebase di `lib/firebase_options.dart` (lihat `database/firebase-setup.md`).
3. Jalankan `flutter pub get`.
4. Jalankan `flutter run` untuk Android, atau `flutter run -d chrome` untuk web.

### Cloud Functions
1. Buka `aplikasi/functions`.
2. Instal dependency Node.js dengan `npm install`.
3. Deploy melalui Firebase CLI pada project Firebase yang benar jika deployment diperlukan.

> **Catatan:** Konfigurasi API key pada repository ini sengaja direduksi menjadi placeholder. Lihat `database/firebase-setup.md`.

## Akun Pengujian
Isi dengan akun DEMO yang benar-benar aktif sebelum repository diserahkan kepada asesor. Jangan menuliskan password rahasia/pribadi.

| Peran | Username | Password |
|---|---|---|
| Siswa | `[12345678910]` | `[user123]` |
| Petugas | `[petugas1]` | `[petugas123]` |
| Admin | `[admin]` | `[admin123]` |

## Dokumentasi
- `docs/01-analisis-kebutuhan.pdf`
- `docs/02-perancangan.pdf`
- `docs/03-dokumentasi-program.pdf`
- `docs/04-pengujian.pdf`
- `docs/05-debugging.pdf`
- `docs/06-evaluasi.pdf`
- `docs/screenshots/` untuk screenshot evidence.

Tambahkan screenshot, hasil uji nyata, dan data yang belum tersedia sebelum submit final.

## Known Issues / Hal yang Harus Diverifikasi
- Pastikan konfigurasi Firebase lokal benar setelah API key diganti placeholder.
- Verifikasi aturan (rules) Firestore terbaru sebelum submit.
- Password siswa, petugas, dan admin saat ini disimpan dan dibandingkan sebagai teks biasa di Firestore; sebaiknya diganti Firebase Authentication atau di-hash.
- Foto bukti disimpan sebagai base64 di dokumen Firestore (batas ukuran dokumen 1 MB).
- Belum ada `firebase.json` untuk deploy Cloud Functions.
- Uji ulang fitur cetak laporan PDF pada dashboard admin.
- Ganti akun pengujian placeholder dengan akun demo yang memang tersedia.

## Keamanan Repository
Jangan commit `.env`, password, secret key, token, service account, private key, atau credential rahasia. Gunakan `.gitignore` dan konfigurasi lokal.
