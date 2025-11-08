class LokasiTersimpan {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime disimpanPada;

  LokasiTersimpan({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.disimpanPada,
  });

  Map<String, dynamic> keJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'savedAt': disimpanPada.toIso8601String(),
    };
  }

  factory LokasiTersimpan.dariJson(Map<String, dynamic> json) {
    return LokasiTersimpan(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      disimpanPada: DateTime.parse(json['savedAt']),
    );
  }
}
