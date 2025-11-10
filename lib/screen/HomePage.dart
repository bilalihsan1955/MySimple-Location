import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/lokasi_tersimpan.dart';
import '../services/penyimpanan_lokasi.dart';
import '../widget/top_snackbar.dart';
import '../screen/RiwayatLokasiPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.judul});

  final String judul;

  @override
  State<Homepage> createState() => _StateHomepage();
}

class _StateHomepage extends State<Homepage> {
  final MapController _pengontrolPeta = MapController();
  LatLng? _posisiSaatIni;
  String _status = 'Mendapatkan lokasi...';
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    // Ambil lokasi otomatis saat halaman pertama kali dibuka
    _perbaruiLokasi();
  }

  Future<void> _perbaruiLokasi() async {
    setState(() {
      _sedangMemuat = true;
      _status = 'Mendapatkan lokasi...';
    });

    try {
      // Cek permission
      LocationPermission izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
        if (izin != LocationPermission.whileInUse &&
            izin != LocationPermission.always) {
          setState(() => _status = 'Permission denied');
          TopSnackbar.tampilkanPeringatan(
            context,
            'Izin lokasi ditolak. Berikan izin untuk melanjutkan.',
            durasi: const Duration(seconds: 4),
          );
          return;
        }
      }

      // Cek service
      bool layananDiaktifkan = await Geolocator.isLocationServiceEnabled();
      if (!layananDiaktifkan) {
        setState(() => _status = 'Location service disabled');
        TopSnackbar.tampilkanPeringatan(
          context,
          'Layanan lokasi nonaktif. Aktifkan GPS untuk melanjutkan.',
          durasi: const Duration(seconds: 4),
        );
        return;
      }

      // Ambil lokasi
      Position posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final posisiBaru = LatLng(posisi.latitude, posisi.longitude);

      setState(() {
        _posisiSaatIni = posisiBaru;
        _sedangMemuat = false;
        _status =
            'Lat: ${posisi.latitude.toStringAsFixed(6)}, Lng: ${posisi.longitude.toStringAsFixed(6)}';
      });

      // Refresh map
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 50), () {
          if (mounted) {
            _pengontrolPeta.move(posisiBaru, 15.0);
          }
        });
      });
    } catch (e) {
      setState(() {
        _sedangMemuat = false;
        _status = 'Error: $e';
      });
      TopSnackbar.tampilkanError(
        context,
        'Gagal mendapatkan lokasi: $e',
        durasi: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _simpanLokasi() async {
    if (_posisiSaatIni == null) {
      TopSnackbar.tampilkanPeringatan(
        context,
        'Tidak ada lokasi untuk disimpan',
      );
      return;
    }

    try {
      final lokasi = LokasiTersimpan(
        id: const Uuid().v4(),
        latitude: _posisiSaatIni!.latitude,
        longitude: _posisiSaatIni!.longitude,
        disimpanPada: DateTime.now(),
      );

      await PenyimpananLokasi.simpanLokasi(lokasi);

      TopSnackbar.tampilkanSukses(context, 'Lokasi berhasil disimpan!');
    } catch (e) {
      TopSnackbar.tampilkanError(context, 'Error menyimpan lokasi: $e');
    }
  }

  @override
  void dispose() {
    _pengontrolPeta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFCFCFC),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCFCFC),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.judul,
          style: TextStyle(
            color: Color(0xFFEF0000),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFFEF0000)),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: Color(0xFFEF0000)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => riwayatLokasiPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFFFCFCFC),
          child: Column(
            children: [
              // OSM Map Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Skeletonizer(
                      enabled: _sedangMemuat,
                      child: _posisiSaatIni != null
                          ? FlutterMap(
                              mapController: _pengontrolPeta,
                              options: MapOptions(
                                initialCenter: _posisiSaatIni!,
                                initialZoom: 15.0,
                              ),
                              children: [
                                // Tile Layer OpenStreetMap 
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                  subdomains: ['a', 'b', 'c'],
                                ),
                                // Marker
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _posisiSaatIni!,
                                      child: Icon(
                                        Icons.location_pin,
                                        color: Color(0xFFEF0000),
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : FlutterMap(
                              mapController: _pengontrolPeta,
                              options: MapOptions(
                                initialCenter: LatLng(0, 0),
                                initialZoom: 2.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                  subdomains: ['a', 'b', 'c'],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              // Status text
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Skeletonizer(
                  enabled: _sedangMemuat,
                  child: Text(_status, textAlign: TextAlign.center),
                ),
              ),

              // Column untuk 3 tombol
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Tombol Lokasi Disimpan
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFCFCFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => riwayatLokasiPage(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Riwayat Lokasi',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Informasi lengkap riwayat lokasi',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Dapatkan Lokasi
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: RadialGradient(
                          radius: 4.0,
                          stops: [0.08, 1.0],
                          colors: [
                            Colors.deepOrange.shade400,
                            Color(0xFFEF0000),
                          ],
                          center: Alignment.center,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _perbaruiLokasi,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Dapatkan Lokasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Simpan Lokasi
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFEF0000), width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _simpanLokasi,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: Color(0xFFEF0000),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Simpan Lokasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF0000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
