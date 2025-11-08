# Materi PPT — MySimple Location (Flutter/Dart)

Catatan: Ini adalah naskah/outline per slide untuk dipindahkan ke PowerPoint atau Google Slides. Setiap slide sudah dilengkapi poin utama dan catatan penyaji (speaker notes).

---

## Slide 1 — Judul
- **Judul**: MySimple Location
- **Subjudul**: Aplikasi Sederhana Pelacak Lokasi & Penyimpanan Data (Flutter/Dart)
- **Penyusun**: [Nama Peserta]
- **Tanggal**: [Tanggal Presentasi]

Catatan penyaji:
- Perkenalkan diri, tujuan aplikasi, dan teknologi utama (Flutter/Dart).

---

## Slide 2 — Unit Kompetensi (mengacu referensi gambar)
Tabel ringkas dan mapping fitur proyek ke unit kompetensi:

- 1) Menunjukkan Platform OS & Bahasa Pemrograman
  - Flutter/Dart, Android
  - File: `lib/main.dart`
- 2) Merancang Database & Data Persistence pada Mobile Data
  - Shared Preferences (local key-value), format JSON
  - File: `lib/services/penyimpanan_lokasi.dart`, `lib/models/lokasi_tersimpan.dart`
- 3) Menyusun Mobile Location Based Service, GPS & Mobile Navigation
  - Geolocator (GPS), Flutter Map (navigasi peta), LatLng (koordinat)
  - File: `lib/HomePage.dart`
- 4) Merancang Mobile Interface
  - UI/UX konsisten, Skeletonizer (loading), Top Snackbar (notifikasi), tema warna
  - File: `lib/HomePage.dart`, `lib/widget/layanan_snackbar_atas.dart`
- 5) Menjelaskan Dasar-dasar Mobile Security
  - Izin lokasi & internet, tidak ada data keluar ke server selain tile peta
  - File: `android/app/src/main/AndroidManifest.xml`
- 6) Menjelaskan Mobile Sensor & Spesifikasi Teknis
  - Sensor lokasi (GPS), akurasi high, handling permission & service status
  - File: `lib/HomePage.dart`
- 7) Menentukan Mobile Seluler Network
  - Kebutuhan internet untuk tile peta (OpenStreetMap), fallback tanpa internet tetap bisa ambil GPS
  - File: `android/app/src/main/AndroidManifest.xml` (INTERNET permission)

Catatan penyaji:
- Tunjukkan bagaimana setiap unit tercermin langsung di kode/fungsi aplikasi.

---

## Slide 3 — Arsitektur & Struktur Proyek
- Flutter app (single-activity) + layanan plugin
- Struktur folder (ringkas):
  - `lib/main.dart` — Entry point, tema font Poppins, set home
  - `lib/HomePage.dart` — Halaman utama (peta, tombol aksi, status)
  - `lib/RiwayatLokasiPage.dart` — Daftar lokasi tersimpan
  - `lib/models/lokasi_tersimpan.dart` — Model data
  - `lib/services/penyimpanan_lokasi.dart` — CRUD SharedPreferences
  - `lib/widget/layanan_snackbar_atas.dart` — Snackbar notifikasi dari atas
  - `android/app/src/main/AndroidManifest.xml` — Izin: lokasi & internet

Catatan penyaji:
- Tampilkan struktur explorer, fokuskan pada file inti di atas.

---

## Slide 4 — Dependensi & Kegunaan
- geolocator — GPS/permission lokasi
- flutter_map — Peta interaktif
- latlong2 — Tipe koordinat `LatLng`
- shared_preferences — Penyimpanan lokal (JSON string)
- uuid — ID unik untuk tiap lokasi
- intl — Format tanggal di riwayat
- skeletonizer — Animasi skeleton loading (peta & teks)
- google_fonts — Tema font Poppins

Catatan penyaji:
- Soroti kenapa memilih paket ini (stabil, dukungan komunitas, sesuai kebutuhan).

---

## Slide 5 — Izin & Keamanan
- Izin yang digunakan:
  - `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` — akses GPS
  - `INTERNET` — mengunduh tile peta dari OSM
- Tidak ada izin berisiko lain (kontak, SMS, storage penuh, dsb.)
- Data disimpan lokal (SharedPreferences), tidak dikirim ke server
- Hanya tile peta yang diunduh dari host publik OpenStreetMap

Catatan penyaji:
- Tekankan keamanan: tanpa exfiltration data; app aman digunakan.

---

## Slide 6 — Fitur Utama (Demo 1/2)
- Dapatkan lokasi (GPS) — tombol “Dapatkan Lokasi”
  - Meminta permission bila perlu, cek layanan GPS aktif
  - Menampilkan koordinat Lat/Lng
- Peta interaktif (Flutter Map)
  - Marker merah di posisi pengguna
  - Kamera berpindah (zoom street-level 15.0) saat lokasi didapat

Catatan penyaji (demo langsung):
- Jalankan aplikasi, tekan tombol “Dapatkan Lokasi”, tunjukkan koordinat & marker.

---

## Slide 7 — Fitur Utama (Demo 2/2)
- Simpan lokasi (lokal)
  - Objek `LokasiTersimpan`: id (UUID), latitude, longitude, disimpanPada
  - Diserialisasi ke JSON dan disimpan di SharedPreferences (key `lokasi_tersimpan`)
- Riwayat lokasi
  - List lokasi tersimpan (koordinat + waktu)
  - Hapus lokasi dengan dialog konfirmasi

Catatan penyaji (demo langsung):
- Simpan satu lokasi, buka riwayat, hapus salah satu item.

---

## Slide 8 — UI/UX & Tema
- Skeletonizer: animasi loading konsisten di peta & teks saat:
  - App baru dibuka, dan saat refresh lokasi
- Top Snackbar: notifikasi sukses/error muncul dari atas
- Tema:
  - Warna utama merah (`#EF0000`) untuk AppBar/icon/marker
  - Tombol:
    - Riwayat Lokasi (container putih + ripple)
    - Dapatkan Lokasi (RadialGradient orange→merah + ikon putih)
    - Simpan Lokasi (putih + border merah)
  - Font Poppins (Google Fonts)

Catatan penyaji:
- Tunjukkan konsistensi spacing, radius 12px, dan hierarchy visual.

---

## Slide 9 — Alur Teknis (Ringkas)
1) App start → `_sedangMemuat = true` → Skeleton tampil
2) `initState()` memanggil `_perbaruiLokasi()`
3) Cek permission & service, ambil lokasi (accuracy high)
4) Update state → kamera map berpindah ke posisi pengguna
5) Simpan lokasi (opsional) → tampil di riwayat

Catatan penyaji:
- Tekankan state `_sedangMemuat` sebagai pemicu animasi Skeletonizer.

---

## Slide 10 — Cuplikan Kode (1/2)
- Ambil lokasi (potongan dari `lib/HomePage.dart`)
  - Cek permission → request jika perlu
  - Cek service → abort bila tidak aktif
  - `Geolocator.getCurrentPosition()` → set `_posisiSaatIni`
- Penyegaran kamera map (MapController.move)

Catatan penyaji:
- Tampilkan potongan kode singkat, bukan seluruh file. Fokus ke logika inti.

---

## Slide 11 — Cuplikan Kode (2/2)
- Simpan lokasi (`lib/services/penyimpanan_lokasi.dart`)
  - Ambil daftar lama → tambah objek baru → encode JSON → simpan ke key
- Model data (`lib/models/lokasi_tersimpan.dart`)
  - `keJson()` dan `dariJson()`

Catatan penyaji:
- Soroti kesederhanaan model & kompatibilitas serialisasi.

---

## Slide 12 — Pengujian & Troubleshooting
- Permission ditolak → tampil pesan “Permission denied”
- Peta tidak muncul → cek internet & URL tile OSM
- Lokasi tidak akurat → pastikan GPS aktif, uji di ruang terbuka

Catatan penyaji:
- Tunjukkan langkah perbaikan paling sering dilakukan saat demo.

---

## Slide 13 — Kesimpulan
- Aplikasi memenuhi seluruh poin uji kompetensi:
  - Platform & bahasa, LBS/GPS, UI/UX, penyimpanan lokal, security, network
- Siap dikembangkan (offline tiles, reverse geocoding, export data)

Catatan penyaji:
- Tutup dengan Q&A, ajak audiens mencoba demo.

---

## Lampiran (Rujukan Cepat File)
- `lib/main.dart`
- `lib/HomePage.dart`
- `lib/RiwayatLokasiPage.dart`
- `lib/models/lokasi_tersimpan.dart`
- `lib/services/penyimpanan_lokasi.dart`
- `lib/widget/layanan_snackbar_atas.dart`
- `android/app/src/main/AndroidManifest.xml`


