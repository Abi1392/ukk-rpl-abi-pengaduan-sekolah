import 'package:cloud_firestore/cloud_firestore.dart';

class Aspirasi {
  final String? id;
  final String nis;
  final String nama;
  final String kelas;
  final String idKategori;
  final String kategori;
  final String lokasi;
  final String keterangan;
  final String status;
  final String feedback;
  final String fotoBase64;
  final String fotoSelesaiBase64;
  final DateTime? tanggal;

  Aspirasi({
    this.id,
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.idKategori,
    required this.kategori,
    required this.lokasi,
    required this.keterangan,
    this.status = 'Menunggu',
    this.feedback = '',
    this.fotoBase64 = '',
    this.fotoSelesaiBase64 = '',
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'id_kategori': idKategori,
      'kategori': kategori,
      'lokasi': lokasi,
      'ket': keterangan,
      'status': status,
      'feedback': feedback,
      'foto_base64': fotoBase64,
      'foto_selesai_base64': fotoSelesaiBase64,
      'tanggal': tanggal != null
          ? Timestamp.fromDate(tanggal!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory Aspirasi.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Aspirasi(
      id: doc.id,
      nis: data['nis']?.toString() ?? '',
      nama: data['nama']?.toString() ?? '',
      kelas: data['kelas']?.toString() ?? '',
      idKategori: data['id_kategori']?.toString() ?? '',
      kategori: data['kategori']?.toString() ?? '-',
      lokasi: data['lokasi']?.toString() ?? '',
      keterangan: data['ket']?.toString() ?? '',
      status: data['status']?.toString() ?? 'Menunggu',
      feedback: data['feedback']?.toString() ?? '',
      fotoBase64: data['foto_base64']?.toString() ?? '',
      fotoSelesaiBase64: data['foto_selesai_base64']?.toString() ?? '',
      tanggal: data['tanggal'] != null
          ? (data['tanggal'] as Timestamp).toDate()
          : null,
    );
  }
}
