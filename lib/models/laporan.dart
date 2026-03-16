class LaporanInfrastruktur {
  final String id;
  final String userId;
  final String nama;
  final String lokasi;
  final String kategori;
  final String deskripsi;
  final String status;
  final DateTime tanggal;
  final String? foto;
  final String? fotoSelesai;

  LaporanInfrastruktur({
    required this.id,
    required this.userId,
    required this.nama,
    required this.lokasi,
    required this.kategori,
    required this.deskripsi,
    required this.status,
    required this.tanggal,
    this.foto,
    this.fotoSelesai,
  });

  factory LaporanInfrastruktur.fromJson(Map<String, dynamic> json) {
    return LaporanInfrastruktur(
      id: json['id'].toString(),
      userId: json['user_id'],
      nama: json['nama'] ?? '',
      lokasi: json['lokasi'] ?? '',
      kategori: json['kategori'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
      foto: json['foto'],
      fotoSelesai: json['foto_selesai'],
    );
  }
}