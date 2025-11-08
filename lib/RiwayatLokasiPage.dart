import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/lokasi_tersimpan.dart';
import 'services/penyimpanan_lokasi.dart';
import 'widget/top_snackbar.dart';

class riwayatLokasiPage extends StatefulWidget {
  const riwayatLokasiPage({super.key});

  @override
  State<riwayatLokasiPage> createState() => _StateriwayatLokasiPage();
}

class _StateriwayatLokasiPage extends State<riwayatLokasiPage> {
  List<LokasiTersimpan> _lokasiTersimpan = [];
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _muatLokasi();
  }

  Future<void> _muatLokasi() async {
    setState(() => _sedangMemuat = true);
    final daftarLokasi = await PenyimpananLokasi.ambilLokasiTersimpan();
    setState(() {
      _lokasiTersimpan = daftarLokasi;
      _sedangMemuat = false;
    });
  }

  Future<void> _hapusLokasi(LokasiTersimpan lokasi) async {
    await PenyimpananLokasi.hapusLokasi(lokasi.id);
    _muatLokasi();
    TopSnackbar.tampilkanSukses(context, 'Lokasi berhasil dihapus');
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
          'Riwayat Lokasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFFFCFCFC),
          child: _sedangMemuat
              ? Center(child: CircularProgressIndicator())
              : _lokasiTersimpan.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada lokasi tersimpan',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _lokasiTersimpan.length,
                  itemBuilder: (context, indeks) {
                    final lokasi = _lokasiTersimpan[indeks];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: Offset(0,1),
                            spreadRadius: 0.9,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon dengan gradient background
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  radius: 4.0,
                                  stops: [0.0, 1.0],
                                  colors: [Colors.deepOrange.shade600,Color(0xFFEF0000),],
                                  center: Alignment.center,
                                ), 
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xFFFFFFFF),
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi ${indeks + 1}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.my_location,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${lokasi.latitude.toStringAsFixed(6)}, ${lokasi.longitude.toStringAsFixed(6)}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy, HH:mm',
                                        ).format(lokasi.disimpanPada),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            // Delete button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Hapus Lokasi'),
                                      content: Text(
                                        'Apakah Anda yakin ingin menghapus lokasi ini?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _hapusLokasi(lokasi);
                                          },
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red.shade400,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
