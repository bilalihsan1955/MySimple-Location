import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lokasi_tersimpan.dart';

class PenyimpananLokasi {
  static const String _kunci = 'lokasi_tersimpan';

  // Simpan lokasi
  static Future<void> simpanLokasi(LokasiTersimpan lokasi) async {
    final prefs = await SharedPreferences.getInstance();
    final daftarLokasi = ambilLokasiTersimpanSinkron(prefs);
    daftarLokasi.add(lokasi);
    await _simpanDaftarLokasi(prefs, daftarLokasi);
  }

  // Ambil semua lokasi tersimpan
  static Future<List<LokasiTersimpan>> ambilLokasiTersimpan() async {
    final prefs = await SharedPreferences.getInstance();
    return ambilLokasiTersimpanSinkron(prefs);
  }

  // Ambil lokasi tersimpan
  static List<LokasiTersimpan> ambilLokasiTersimpanSinkron(
    SharedPreferences prefs,
  ) {
    final lokasiJson = prefs.getString(_kunci);
    if (lokasiJson == null || lokasiJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> terdekode = json.decode(lokasiJson);
      return terdekode.map((json) => LokasiTersimpan.dariJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Simpan list lokasi
  static Future<void> _simpanDaftarLokasi(
    SharedPreferences prefs,
    List<LokasiTersimpan> daftarLokasi,
  ) async {
    final lokasiJson = json.encode(
      daftarLokasi.map((lok) => lok.keJson()).toList(),
    );
    await prefs.setString(_kunci, lokasiJson);
  }

  // Hapus lokasi
  static Future<void> hapusLokasi(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final daftarLokasi = ambilLokasiTersimpanSinkron(prefs);
    daftarLokasi.removeWhere((lok) => lok.id == id);
    await _simpanDaftarLokasi(prefs, daftarLokasi);
  }

  // Hapus semua lokasi
  static Future<void> hapusSemuaLokasi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kunci);
  }
}
