# MySimple Location - Dokumentasi Lengkap Aplikasi

## 📋 Daftar Isi
1. [Deskripsi Aplikasi](#deskripsi-aplikasi)
2. [Struktur Proyek](#struktur-proyek)
3. [Plugin dan Dependencies](#plugin-dan-dependencies)
4. [Parameter dan Variabel](#parameter-dan-variabel)
5. [Alur Proses Aplikasi](#alur-proses-aplikasi)
6. [Penjelasan File Penting](#penjelasan-file-penting)
7. [Konfigurasi AndroidManifest.xml](#konfigurasi-androidmanifestxml)
8. [Cara Kerja Aplikasi](#cara-kerja-aplikasi)

---

## 📱 Deskripsi Aplikasi

**MySimple Location** adalah aplikasi mobile sederhana untuk pelacakan lokasi dan penyimpanan data lokasi pengguna. Aplikasi ini dibangun menggunakan Flutter/Dart dan dapat berjalan di platform Android.

### Fitur Utama:
- ✅ Mendapatkan koordinat GPS (Latitude & Longitude)
- ✅ Menampilkan lokasi di peta interaktif
- ✅ Menyimpan lokasi ke database lokal (Shared Preferences)
- ✅ Menampilkan riwayat lokasi yang tersimpan
- ✅ Menghapus lokasi tersimpan
- ✅ Manajemen izin akses lokasi

---

## 📁 Struktur Proyek

```
sertikom_aplikasi_lokasi/
├── lib/
│   ├── main.dart                          # Entry point aplikasi
│   ├── HomePage.dart                      # Halaman utama aplikasi
│   ├── RiwayatLokasiPage.dart            # Halaman daftar lokasi tersimpan
│   ├── models/
│   │   └── lokasi_tersimpan.dart          # Model data lokasi
│   ├── services/
│   │   └── penyimpanan_lokasi.dart        # Service untuk penyimpanan data
│   └── widget/
│       └── layanan_snackbar_atas.dart    # Widget snackbar kustom
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml   # Konfigurasi Android
├── pubspec.yaml                           # Dependencies dan konfigurasi
└── README.md                              # Dokumentasi ini
```

---

## 🔌 Plugin dan Dependencies

### 1. **geolocator (^14.0.2)**
**Kegunaan:** Plugin untuk mendapatkan lokasi GPS pengguna
- **Fungsi Utama:**
  - `Geolocator.checkPermission()` - Mengecek status izin lokasi
  - `Geolocator.requestPermission()` - Meminta izin akses lokasi
  - `Geolocator.isLocationServiceEnabled()` - Mengecek apakah GPS aktif
  - `Geolocator.getCurrentPosition()` - Mendapatkan koordinat saat ini
- **Digunakan di:** `HomePage.dart` untuk mendapatkan lokasi pengguna

### 2. **shared_preferences (^2.2.2)**
**Kegunaan:** Plugin untuk penyimpanan data lokal (key-value storage)
- **Fungsi Utama:**
  - `SharedPreferences.getInstance()` - Mendapatkan instance penyimpanan
  - `prefs.setString()` - Menyimpan data string
  - `prefs.getString()` - Membaca data string
  - `prefs.remove()` - Menghapus data
- **Digunakan di:** `penyimpanan_lokasi.dart` untuk menyimpan daftar lokasi

### 3. **flutter_map (^8.2.2)**
**Kegunaan:** Plugin untuk menampilkan peta interaktif
- **Fungsi Utama:**
  - `FlutterMap` - Widget peta utama
  - `MapController` - Kontrol untuk menggerakkan kamera peta
  - `TileLayer` - Layer untuk menampilkan tile peta
  - `MarkerLayer` - Layer untuk menampilkan marker lokasi
- **Digunakan di:** `HomePage.dart` untuk menampilkan peta

### 4. **latlong2 (^0.9.1)**
**Kegunaan:** Library untuk menangani koordinat geografis (Latitude & Longitude)
- **Fungsi Utama:**
  - `LatLng(latitude, longitude)` - Membuat objek koordinat
- **Digunakan di:** Semua file yang berhubungan dengan koordinat

### 5. **uuid (^4.3.3)**
**Kegunaan:** Library untuk menghasilkan ID unik
- **Fungsi Utama:**
  - `Uuid().v4()` - Menghasilkan UUID versi 4 (random)
- **Digunakan di:** `HomePage.dart` untuk membuat ID unik setiap lokasi

### 6. **intl (^0.19.0)**
**Kegunaan:** Library untuk format tanggal dan waktu
- **Fungsi Utama:**
  - `DateFormat('dd MMM yyyy, HH:mm').format()` - Format tanggal Indonesia
- **Digunakan di:** `RiwayatLokasiPage.dart` untuk format tanggal

### 7. **skeletonizer (^2.1.0)**
**Kegunaan:** Library untuk menampilkan efek loading skeleton dengan animasi
- **Fungsi Utama:**
  - `Skeletonizer(enabled: _sedangMemuat)` - Menampilkan efek skeleton saat loading
  - Memberikan animasi skeleton yang konsisten pada map dan text status
- **Digunakan di:** `HomePage.dart` untuk loading state pada peta dan text koordinat

### 8. **google_fonts (^6.3.2)**
**Kegunaan:** Library untuk menggunakan font Google (Poppins)
- **Fungsi Utama:**
  - `GoogleFonts.poppinsTextTheme()` - Menerapkan tema font Poppins
- **Digunakan di:** `main.dart` untuk tema aplikasi

---

## 📊 Parameter dan Variabel

### **File: main.dart**

#### Class: `Myapp`
- **Parameter:**
  - `super.key` - Key untuk widget (Flutter framework)
- **Variabel:**
  - `title: 'MySimple Location'` - Judul aplikasi
  - `home: HalamanBeranda(judul: 'MySimple Location')` - Halaman awal aplikasi

---

### **File: HomePage.dart**

#### Class: `HalamanBeranda`
- **Parameter:**
  - `required this.judul` - Judul yang ditampilkan di AppBar (String)

#### Class: `_StateHalamanBeranda`
- **Variabel State:**
  - `_pengontrolPeta` (MapController) - Kontrol untuk menggerakkan peta
  - `_posisiSaatIni` (LatLng?) - Koordinat lokasi saat ini (nullable)
  - `_status` (String) - Teks status yang ditampilkan ke pengguna
  - `_sedangMemuat` (bool) - Flag untuk status loading

#### Method: `_perbaruiLokasi()`
- **Parameter:** Tidak ada (menggunakan state class)
- **Return:** `Future<void>` - Async function
- **Variabel Lokal:**
  - `izin` (LocationPermission) - Status izin lokasi
  - `layananDiaktifkan` (bool) - Status GPS aktif/tidak
  - `posisi` (Position) - Objek posisi dari Geolocator
  - `posisiBaru` (LatLng) - Koordinat baru yang didapat

#### Method: `_simpanLokasi()`
- **Parameter:** Tidak ada
- **Return:** `Future<void>`
- **Variabel Lokal:**
  - `lokasi` (LokasiTersimpan) - Objek lokasi yang akan disimpan

---

### **File: RiwayatLokasiPage.dart**

#### Class: `riwayatLokasiPage`
- **Parameter:** Tidak ada

#### Class: `_StateriwayatLokasiPage`
- **Variabel State:**
  - `_lokasiTersimpan` (List<LokasiTersimpan>) - Daftar semua lokasi tersimpan
  - `_sedangMemuat` (bool) - Flag status loading

#### Method: `_muatLokasi()`
- **Parameter:** Tidak ada
- **Return:** `Future<void>`
- **Variabel Lokal:**
  - `daftarLokasi` (List<LokasiTersimpan>) - Data dari penyimpanan

#### Method: `_hapusLokasi(LokasiTersimpan lokasi)`
- **Parameter:**
  - `lokasi` (LokasiTersimpan) - Lokasi yang akan dihapus
- **Return:** `Future<void>`

---

### **File: models/lokasi_tersimpan.dart**

#### Class: `LokasiTersimpan`
- **Parameter Constructor:**
  - `required this.id` (String) - ID unik lokasi
  - `required this.latitude` (double) - Koordinat latitude
  - `required this.longitude` (double) - Koordinat longitude
  - `required this.disimpanPada` (DateTime) - Waktu penyimpanan

#### Method: `keJson()`
- **Return:** `Map<String, dynamic>` - Data dalam format JSON
- **Parameter JSON:**
  - `'id'` - ID lokasi
  - `'latitude'` - Latitude
  - `'longitude'` - Longitude
  - `'savedAt'` - Waktu disimpan (ISO 8601 format)

#### Method: `dariJson(Map<String, dynamic> json)`
- **Parameter:**
  - `json` (Map<String, dynamic>) - Data JSON yang akan dikonversi
- **Return:** `LokasiTersimpan` - Objek lokasi

---

### **File: services/penyimpanan_lokasi.dart**

#### Class: `PenyimpananLokasi`
- **Konstanta:**
  - `_kunci` (String) - Key untuk menyimpan data di SharedPreferences: `'lokasi_tersimpan'`

#### Method: `simpanLokasi(LokasiTersimpan lokasi)`
- **Parameter:**
  - `lokasi` (LokasiTersimpan) - Lokasi yang akan disimpan
- **Return:** `Future<void>`
- **Variabel Lokal:**
  - `prefs` (SharedPreferences) - Instance penyimpanan
  - `daftarLokasi` (List<LokasiTersimpan>) - Daftar lokasi yang sudah ada

#### Method: `ambilLokasiTersimpan()`
- **Return:** `Future<List<LokasiTersimpan>>` - Daftar semua lokasi tersimpan

#### Method: `ambilLokasiTersimpanSinkron(SharedPreferences prefs)`
- **Parameter:**
  - `prefs` (SharedPreferences) - Instance penyimpanan
- **Return:** `List<LokasiTersimpan>`
- **Variabel Lokal:**
  - `lokasiJson` (String?) - Data JSON dari penyimpanan
  - `terdekode` (List<dynamic>) - Data yang sudah di-decode

#### Method: `hapusLokasi(String id)`
- **Parameter:**
  - `id` (String) - ID lokasi yang akan dihapus
- **Return:** `Future<void>`

---

## 🔄 Alur Proses Aplikasi

### **1. Proses Awal (Aplikasi Dibuka)**

```
main() 
  ↓
Myapp (MaterialApp)
  ↓
HalamanBeranda (initState)
  ↓
_perbaruiLokasi() [Otomatis dipanggil]
```

**Detail Proses:**
1. Fungsi `main()` dijalankan → Memanggil `runApp(Myapp())`
2. `Myapp` membuat `MaterialApp` dengan tema Poppins dan halaman awal
3. `HalamanBeranda` dibuat dan `initState()` dipanggil
4. `_sedangMemuat` diinisialisasi sebagai `true` → Skeleton animasi langsung muncul
5. `initState()` secara otomatis memanggil `_perbaruiLokasi()`

---

### **2. Proses Mendapatkan Lokasi (_perbaruiLokasi)**

```
User menekan tombol "Dapatkan Lokasi"
  ↓
_perbaruiLokasi() dipanggil
  ↓
setState(_sedangMemuat = true) [Aktifkan Skeletonizer animasi]
  ↓
Skeletonizer memberikan animasi loading pada peta dan text
  ↓
Cek Permission (Geolocator.checkPermission())
  ├─ Jika DENIED → Request Permission
  │   ├─ Jika DITOLAK → Tampilkan "Permission denied" → STOP
  │   └─ Jika DIBERIKAN → Lanjut
  └─ Jika SUDAH ADA → Lanjut
  ↓
Cek GPS Aktif (Geolocator.isLocationServiceEnabled())
  ├─ Jika TIDAK AKTIF → Tampilkan "Location service disabled" → STOP
  └─ Jika AKTIF → Lanjut
  ↓
Ambil Lokasi (Geolocator.getCurrentPosition())
  ↓
setState(_sedangMemuat = false) [Nonaktifkan Skeletonizer]
  ↓
Skeletonizer animasi fade out, konten muncul dengan smooth transition
  ↓
Pindahkan Kamera Peta (_pengontrolPeta.move())
  ↓
Tampilkan di Layar [Koordinat + Peta + Marker dengan animasi]
```

**Parameter yang Digunakan:**
- `desiredAccuracy: LocationAccuracy.high` - Akurasi tinggi untuk GPS
- `initialZoom: 15.0` - Level zoom peta saat lokasi didapat (15 = street level)
- `initialZoom: 2.0` - Level zoom peta saat awal aplikasi (2 = world view)
- `initialCenter: LatLng(0, 0)` - Koordinat default saat awal aplikasi
- `posisiBaru` - Koordinat baru (LatLng) dari GPS
- `_sedangMemuat` - Flag untuk mengaktifkan/nonaktifkan Skeletonizer

---

### **3. Proses Menyimpan Lokasi (_simpanLokasi)**

```
User menekan tombol "Simpan Lokasi"
  ↓
_simpanLokasi() dipanggil
  ↓
Cek _posisiSaatIni != null
  ├─ Jika NULL → Tampilkan Peringatan → STOP
  └─ Jika ADA → Lanjut
  ↓
Buat Objek LokasiTersimpan
  - id: UUID v4 (unik)
  - latitude: _posisiSaatIni.latitude
  - longitude: _posisiSaatIni.longitude
  - disimpanPada: DateTime.now()
  ↓
PenyimpananLokasi.simpanLokasi(lokasi)
  ↓
ambilLokasiTersimpanSinkron() [Ambil data lama]
  ↓
daftarLokasi.add(lokasi) [Tambahkan lokasi baru]
  ↓
_simpanDaftarLokasi() [Simpan ke SharedPreferences]
  ├─ Konversi List → JSON (json.encode)
  └─ Simpan dengan key 'lokasi_tersimpan'
  ↓
Tampilkan Snackbar Sukses
```

**Data yang Disimpan:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "latitude": -6.200000,
  "longitude": 106.816666,
  "savedAt": "2024-01-15T10:30:00.000Z"
}
```

---

### **4. Proses Menampilkan Riwayat Lokasi**

```
User membuka halaman "Riwayat Lokasi"
  ↓
riwayatLokasiPage (initState)
  ↓
_muatLokasi() dipanggil
  ↓
setState(_sedangMemuat = true) [Tampilkan loading]
  ↓
PenyimpananLokasi.ambilLokasiTersimpan()
  ↓
ambilLokasiTersimpanSinkron()
  ├─ Baca dari SharedPreferences (key: 'lokasi_tersimpan')
  ├─ Jika NULL/Empty → Return []
  └─ Jika ADA → Decode JSON → List<LokasiTersimpan>
  ↓
setState(_lokasiTersimpan = daftarLokasi)
  ↓
Tampilkan ListView dengan data lokasi
```

**Format Tampilan:**
- Setiap item menampilkan:
  - Icon dengan RadialGradient (orange ke merah)
  - Nomor lokasi (Lokasi 1, Lokasi 2, dst)
  - Koordinat (Latitude, Longitude) dengan ikon my_location
  - Tanggal & waktu disimpan (format: "15 Jan 2024, 10:30") dengan ikon access_time
  - Tombol hapus dengan dialog konfirmasi
  - Icon arrow (visual only)
- Container dengan shadow dan border radius untuk setiap item

---

### **5. Proses Menghapus Lokasi**

```
User menekan tombol hapus pada item lokasi
  ↓
Tampilkan Dialog Konfirmasi
  ├─ User pilih "Batal" → Tutup dialog → STOP
  └─ User pilih "Hapus" → Lanjut
  ↓
_hapusLokasi(lokasi) dipanggil
  ↓
PenyimpananLokasi.hapusLokasi(lokasi.id)
  ↓
ambilLokasiTersimpanSinkron() [Ambil data]
  ↓
daftarLokasi.removeWhere((lok) => lok.id == id) [Hapus dari list]
  ↓
_simpanDaftarLokasi() [Simpan kembali]
  ↓
_muatLokasi() [Refresh tampilan]
  ↓
Tampilkan Snackbar Sukses
```

---

## 📄 Penjelasan File Penting

### **1. main.dart**
**Fungsi:** Entry point aplikasi Flutter
- `main()` - Fungsi utama yang dijalankan pertama kali
- `Myapp` - Widget root aplikasi (StatelessWidget)
- `MaterialApp` - Widget untuk konfigurasi aplikasi Material Design
  - `title` - Judul aplikasi
  - `theme` - Tema aplikasi (menggunakan Google Fonts Poppins)
  - `home` - Halaman awal aplikasi

### **2. HomePage.dart**
**Fungsi:** Halaman utama aplikasi
- Menampilkan peta interaktif dengan animasi skeleton loading
- Tombol "Riwayat Lokasi" - Navigasi ke halaman riwayat (Container dengan InkWell)
- Tombol "Dapatkan Lokasi" - Memperbarui lokasi GPS (Container dengan gradient RadialGradient)
- Tombol "Simpan Lokasi" - Menyimpan lokasi saat ini (Container dengan border merah)
- Menampilkan koordinat (Latitude & Longitude) dengan animasi skeleton
- Menggunakan Skeletonizer untuk animasi loading yang konsisten
- Tema warna merah (`Color(0xFFEF0000)`) untuk AppBar dan tombol

### **3. RiwayatLokasiPage.dart**
**Fungsi:** Halaman daftar lokasi tersimpan
- Menampilkan semua lokasi yang sudah disimpan dalam ListView
- Setiap item memiliki:
  - Icon dengan RadialGradient (orange ke merah)
  - Informasi lokasi (nomor, koordinat, tanggal)
  - Tombol hapus dengan dialog konfirmasi
  - Icon arrow (tidak berfungsi, hanya visual)
- Tidak ada pull to refresh
- Tidak ada navigasi ke halaman detail
- Loading indicator saat memuat data

### **4. models/lokasi_tersimpan.dart**
**Fungsi:** Model data untuk lokasi tersimpan
- Mendefinisikan struktur data lokasi
- Method `keJson()` - Konversi objek ke JSON (untuk penyimpanan)
- Method `dariJson()` - Konversi JSON ke objek (untuk membaca)

### **5. services/penyimpanan_lokasi.dart**
**Fungsi:** Service untuk operasi CRUD data lokasi
- `simpanLokasi()` - Menyimpan lokasi baru
- `ambilLokasiTersimpan()` - Membaca semua lokasi
- `ambilLokasiTersimpanSinkron()` - Membaca lokasi secara sinkron (untuk internal)
- `hapusLokasi()` - Menghapus lokasi berdasarkan ID
- `hapusSemuaLokasi()` - Menghapus semua lokasi tersimpan
- Menggunakan SharedPreferences sebagai database lokal
- Key penyimpanan: `'lokasi_tersimpan'`

### **6. widget/layanan_snackbar_atas.dart**
**Fungsi:** Widget snackbar kustom dengan animasi dari atas
- `tampilkan()` - Menampilkan snackbar dengan parameter kustom
- `tampilkanSukses()` - Snackbar hijau untuk pesan sukses
- `tampilkanError()` - Snackbar merah untuk pesan error
- `tampilkanInfo()` - Snackbar biru untuk pesan informasi
- `tampilkanPeringatan()` - Snackbar orange untuk pesan peringatan
- Fitur: Animasi slide dari atas, fade in/out, swipe to dismiss
- Parameter: `onpressed`, `onclosed`, `onswap`

---

## ⚙️ Konfigurasi AndroidManifest.xml

File `AndroidManifest.xml` terletak di `android/app/src/main/AndroidManifest.xml`

### **Penjelasan Baris per Baris:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
```
**Penjelasan:** Tag root manifest yang mendefinisikan namespace Android. Semua konfigurasi aplikasi berada di dalam tag ini.

---

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
**Penjelasan:** 
- **Izin Akses Lokasi Presisi Tinggi (GPS)**
- Memungkinkan aplikasi mengakses lokasi dengan akurasi tinggi (GPS)
- Diperlukan untuk mendapatkan koordinat yang akurat
- Tanpa izin ini, aplikasi tidak bisa mendapatkan lokasi pengguna

---

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
**Penjelasan:**
- **Izin Akses Lokasi Presisi Rendah (Network)**
- Memungkinkan aplikasi mengakses lokasi melalui jaringan (WiFi, seluler)
- Akurasi lebih rendah dibanding GPS tapi lebih cepat
- Digunakan sebagai fallback jika GPS tidak tersedia

---

```xml
<uses-permission android:name="android.permission.INTERNET" />
```
**Penjelasan:**
- **Izin Akses Internet**
- Memungkinkan aplikasi mengakses internet untuk menampilkan tile peta
- Diperlukan untuk mengunduh tile peta dari OpenStreetMap server
- Tanpa izin ini, peta tidak akan bisa ditampilkan

---

```xml
<application
    android:label="sertikom_aplikasi_lokasi"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```
**Penjelasan:**
- **Konfigurasi Aplikasi Utama**
- `android:label` - Nama aplikasi yang ditampilkan di launcher
- `android:name` - Nama class aplikasi (diisi otomatis oleh Flutter)
- `android:icon` - Icon aplikasi (menggunakan icon default Flutter)

---

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:taskAffinity=""
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">
```
**Penjelasan:**
- **Konfigurasi Activity Utama (Halaman Aplikasi)**
- `android:name=".MainActivity"` - Nama class activity (entry point Flutter)
- `android:exported="true"` - Activity dapat dipanggil dari aplikasi lain (diperlukan untuk launcher)
- `android:launchMode="singleTop"` - Mode launch: hanya satu instance activity di top stack
- `android:theme="@style/LaunchTheme"` - Tema saat aplikasi pertama kali dibuka
- `android:configChanges="..."` - Konfigurasi perubahan yang ditangani tanpa restart (rotasi layar, keyboard, dll)
- `android:hardwareAccelerated="true"` - Mengaktifkan akselerasi hardware untuk performa lebih baik
- `android:windowSoftInputMode="adjustResize"` - Perilaku saat keyboard muncul (resize layout)

---

```xml
<meta-data
    android:name="io.flutter.embedding.android.NormalTheme"
    android:resource="@style/NormalTheme" />
```
**Penjelasan:**
- **Metadata Tema Normal**
- Mendefinisikan tema normal aplikasi setelah splash screen
- Digunakan oleh Flutter engine untuk styling

---

```xml
<intent-filter>
    <action android:name="android.intent.action.MAIN"/>
    <category android:name="android.intent.category.LAUNCHER"/>
</intent-filter>
```
**Penjelasan:**
- **Intent Filter untuk Launcher**
- `action.MAIN` - Menandakan ini adalah entry point utama aplikasi
- `category.LAUNCHER` - Menandakan aplikasi muncul di launcher/home screen
- Tanpa ini, aplikasi tidak akan muncul di daftar aplikasi

---

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```
**Penjelasan:**
- **Metadata Flutter Embedding**
- Menandakan menggunakan Flutter embedding versi 2
- Diperlukan untuk Flutter engine

---

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT"/>
        <data android:mimeType="text/plain"/>
    </intent>
</queries>
```
**Penjelasan:**
- **Query untuk Intent Processing**
- Mendeklarasikan intent yang dapat diproses aplikasi
- `PROCESS_TEXT` - Memungkinkan aplikasi memproses teks dari aplikasi lain
- Digunakan oleh Flutter engine untuk fitur text processing

---

## 🎯 Cara Kerja Aplikasi

### **Skenario 1: Pengguna Membuka Aplikasi**

1. **Aplikasi Dimulai**
   - `main()` dipanggil → `Myapp` dibuat → `HalamanBeranda` dimuat
   - `_sedangMemuat = true` → Skeletonizer animasi langsung aktif
   - Peta menampilkan skeleton loading dengan animasi
   - Text status menampilkan skeleton loading dengan animasi
   - `initState()` otomatis memanggil `_perbaruiLokasi()`

2. **Proses Mendapatkan Lokasi**
   - Skeletonizer memberikan animasi loading pada peta dan text
   - Aplikasi mengecek izin lokasi
   - Jika belum ada, meminta izin ke pengguna
   - Mengecek apakah GPS aktif
   - Mengambil koordinat GPS
   - `_sedangMemuat = false` → Skeletonizer animasi fade out
   - Konten peta dan text muncul dengan smooth transition

3. **Tampilan Awal**
   - Peta menampilkan lokasi pengguna dengan marker merah (`Color(0xFFEF0000)`)
   - Teks koordinat ditampilkan di bawah peta
   - Tiga tombol tersedia:
     - **Riwayat Lokasi**: Container putih dengan InkWell
     - **Dapatkan Lokasi**: Container dengan RadialGradient (orange ke merah)
     - **Simpan Lokasi**: Container putih dengan border merah

---

### **Skenario 2: Pengguna Menyimpan Lokasi**

1. **User Menekan "Simpan Lokasi"**
   - Aplikasi mengecek apakah ada lokasi saat ini
   - Jika ada, membuat objek `LokasiTersimpan` dengan:
     - ID unik (UUID)
     - Koordinat saat ini
     - Waktu penyimpanan

2. **Proses Penyimpanan**
   - Membaca data lama dari SharedPreferences
   - Menambahkan lokasi baru ke daftar
   - Mengkonversi daftar ke format JSON
   - Menyimpan kembali ke SharedPreferences

3. **Konfirmasi**
   - Snackbar hijau muncul: "Lokasi berhasil disimpan!"

---

### **Skenario 3: Pengguna Melihat Riwayat**

1. **Navigasi ke Halaman Riwayat**
   - User menekan tombol "Riwayat Lokasi" atau icon bookmark di AppBar
   - `riwayatLokasiPage` dimuat

2. **Memuat Data**
   - `_muatLokasi()` dipanggil
   - Membaca data dari SharedPreferences
   - Mengkonversi JSON ke List<LokasiTersimpan>
   - Menampilkan di ListView

3. **Interaksi**
   - User dapat:
     - Melihat informasi lokasi (nomor, koordinat, tanggal)
     - Tap tombol hapus untuk menghapus lokasi

---

### **Skenario 4: Pengguna Menghapus Lokasi**

1. **Konfirmasi**
   - Dialog muncul: "Apakah Anda yakin ingin menghapus lokasi ini?"
   - User memilih "Hapus" atau "Batal"

2. **Proses Penghapusan**
   - Membaca semua lokasi dari penyimpanan
   - Menghapus lokasi dengan ID yang sesuai
   - Menyimpan kembali daftar yang sudah diupdate

3. **Refresh Tampilan**
   - ListView diperbarui otomatis
   - Snackbar konfirmasi muncul

---

## 🔐 Keamanan dan Permission

### **Permission yang Diperlukan:**

1. **ACCESS_FINE_LOCATION**
   - **Kapan diminta:** Saat pertama kali aplikasi mencoba mendapatkan lokasi
   - **Cara kerja:** 
     - Aplikasi mengecek status permission
     - Jika belum ada, menampilkan dialog sistem Android
     - User dapat memilih "Allow" atau "Deny"
   - **Jika ditolak:** Aplikasi menampilkan "Permission denied" dan tidak bisa mendapatkan lokasi

2. **ACCESS_COARSE_LOCATION**
   - **Kapan digunakan:** Sebagai alternatif jika GPS tidak tersedia
   - **Akurasi:** Lebih rendah (sekitar 100 meter)

### **Validasi Permission:**
- Aplikasi selalu mengecek permission sebelum mengakses lokasi
- Jika permission ditolak, aplikasi tidak akan crash tetapi menampilkan pesan error
- User dapat memberikan permission melalui Settings jika sebelumnya ditolak

---

## 💾 Penyimpanan Data

### **Format Data:**
Data disimpan dalam format JSON string di SharedPreferences:

```json
[
  {
    "id": "uuid-1",
    "latitude": -6.200000,
    "longitude": 106.816666,
    "savedAt": "2024-01-15T10:30:00.000Z"
  },
  {
    "id": "uuid-2",
    "latitude": -6.201000,
    "longitude": 106.817666,
    "savedAt": "2024-01-15T11:00:00.000Z"
  }
]
```

### **Key Penyimpanan:**
- Key: `'lokasi_tersimpan'`
- Tipe: String (JSON)
- Lokasi: SharedPreferences (local storage Android)

### **Operasi CRUD:**
- **Create:** `simpanLokasi()` - Menambah lokasi baru
- **Read:** `ambilLokasiTersimpan()` - Membaca semua lokasi
- **Update:** Tidak ada (data tidak diubah setelah disimpan)
- **Delete:** `hapusLokasi()` - Menghapus lokasi berdasarkan ID

---

## 🎨 UI/UX Features

### **Loading States:**
- **Skeletonizer animasi** pada peta dan text status saat memuat lokasi
- Animasi skeleton yang konsisten saat aplikasi dibuka dan saat refresh
- CircularProgressIndicator saat memuat riwayat lokasi
- Status text yang informatif dengan animasi skeleton

### **Tema Warna:**
- **Warna Utama**: Merah (`Color(0xFFEF0000)`)
  - AppBar title dan icon
  - Marker lokasi di peta
  - Border tombol "Simpan Lokasi"
- **Gradient**: RadialGradient (orange ke merah) pada:
  - Tombol "Dapatkan Lokasi"
  - Icon lokasi di halaman riwayat
- **Background**: Putih (`Color(0xFFFCFCFC)`)

### **Feedback Visual:**
- **Top Snackbar** dengan animasi slide dari atas untuk notifikasi
- Ripple effect pada tombol dengan borderRadius
- Smooth skeleton animations
- Fade transition pada konten

### **Tombol dan Container:**
- Semua tombol menggunakan Container dengan Material dan InkWell
- Tombol "Dapatkan Lokasi": Gradient RadialGradient dengan warna putih
- Tombol "Simpan Lokasi": Putih dengan border merah
- Tombol "Riwayat Lokasi": Container putih dengan InkWell

### **Responsive Design:**
- Layout menyesuaikan ukuran layar
- SafeArea untuk menghindari notch/status bar
- Padding dan margin yang konsisten
- Border radius 12px untuk konsistensi

---

## 🚀 Cara Menjalankan Aplikasi

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Jalankan di Emulator/Device:**
   ```bash
   flutter run
   ```

3. **Build APK:**
   ```bash
   flutter build apk
   ```

---

## 📝 Catatan Penting

1. **Permission Lokasi:**
   - Aplikasi memerlukan izin lokasi untuk berfungsi
   - Pastikan GPS aktif di device untuk akurasi terbaik
   - Permission diminta secara runtime saat pertama kali aplikasi mencoba mendapatkan lokasi

2. **Permission Internet:**
   - Aplikasi memerlukan izin internet untuk menampilkan tile peta
   - Tile peta diunduh dari OpenStreetMap server
   - Tanpa internet, peta tidak akan muncul (tile tidak terunduh)
   - Koordinat GPS tetap bisa didapat tanpa internet

3. **Penyimpanan Data:**
   - Data disimpan lokal di device menggunakan SharedPreferences
   - Data akan hilang jika aplikasi di-uninstall
   - Format penyimpanan: JSON string dengan key `'lokasi_tersimpan'`

4. **Animasi Skeleton:**
   - Skeletonizer memberikan animasi loading yang konsisten
   - Animasi muncul saat aplikasi dibuka dan saat refresh lokasi
   - Menggunakan `_sedangMemuat` flag untuk mengontrol animasi

---

## 🔧 Troubleshooting

### **Masalah: Permission selalu ditolak**
**Solusi:** 
- Buka Settings → Apps → MySimple Location → Permissions
- Aktifkan Location permission secara manual

### **Masalah: Peta tidak muncul**
**Solusi:**
- Pastikan koneksi internet aktif
- Cek apakah tile server OpenStreetMap dapat diakses
- Pastikan permission INTERNET sudah diberikan
- Cek URL tile server: `https://tile.openstreetmap.fr/hot/`

### **Masalah: Lokasi tidak akurat**
**Solusi:**
- Pastikan GPS aktif
- Gunakan di area terbuka (bukan di dalam gedung)
- Tunggu beberapa detik untuk GPS lock

---

## 📚 Referensi

- [Flutter Documentation](https://flutter.dev/docs)
- [Geolocator Package](https://pub.dev/packages/geolocator)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Flutter Map](https://pub.dev/packages/flutter_map)

---

## 📌 Informasi Teknis Tambahan

### **Tema dan Styling:**
- **Font**: Poppins (Google Fonts)
- **Warna Primary**: `Color(0xFFEF0000)` (Merah)
- **Background**: `Color(0xFFFCFCFC)` (Putih)
- **Gradient**: RadialGradient dengan warna orange ke merah

### **Animasi:**
- **Skeletonizer**: Animasi loading skeleton pada peta dan text
- **Top Snackbar**: Animasi slide dari atas dengan fade transition
- **Smooth Transitions**: Fade in/out pada konten

### **Struktur Data:**
- Model: `LokasiTersimpan` dengan 4 field (id, latitude, longitude, disimpanPada)
- Penyimpanan: JSON string di SharedPreferences
- Format tanggal: ISO 8601 untuk penyimpanan, format Indonesia untuk tampilan

### **Fitur yang Tidak Digunakan:**
- ❌ Pull to refresh di halaman riwayat (sudah dihapus)
- ❌ Halaman detail lokasi (sudah dihapus)
- ❌ Geocoding untuk reverse geocoding (plugin terpasang tapi tidak digunakan)

---

**Dibuat untuk Uji Kompetensi Junior Mobile Programmer**
**Aplikasi MySimple Location - Pelacak Lokasi dan Penyimpanan Data**
