import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
// MODEL: Aspirasi
// ------------------------------------------------------------
// Merepresentasikan satu data "aspirasi/pengaduan" yang dikirim
// siswa (misalnya keluhan fasilitas sekolah). Model ini adalah
// jembatan antara data mentah di Firestore (Map) dan objek Dart
// yang mudah dipakai di UI.
//
// - toMap()   -> dipakai saat MENULIS data ke Firestore
// - fromDoc() -> dipakai saat MEMBACA satu dokumen dari Firestore
// ============================================================
class Aspirasi {
  final String? id; // ID dokumen Firestore (null jika belum tersimpan)
  final String nis; // Nomor Induk Siswa pengirim aspirasi
  final String nama; // Nama siswa pengirim
  final String kelas; // Kelas siswa
  final String idKategori; // ID kategori aspirasi (relasi ke koleksi kategori)
  final String
      kategori; // Nama kategori (disalin agar mudah ditampilkan tanpa join)
  final String lokasi; // Lokasi kejadian/fasilitas yang diadukan
  final String keterangan; // Isi/deskripsi aspirasi dari siswa
  final String status; // Status proses: 'Menunggu', 'Diproses', 'Selesai', dst.
  final String feedback; // Tanggapan/balasan dari petugas atau admin
  final String
      fotoBase64; // Foto bukti awal (disimpan sebagai base64, bukan URL)
  final String
      fotoSelesaiBase64; // Foto bukti setelah masalah selesai ditangani
  final DateTime? tanggal; // Waktu aspirasi dibuat

  // RATING SISWA
  // Diisi belakangan oleh siswa setelah aspirasi selesai ditangani,
  // sebagai penilaian terhadap kualitas penanganan (opsional -> nullable).
  final int? rating;

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
    this.rating,
  });

  /// Mengubah objek Aspirasi menjadi Map agar bisa disimpan/diupdate
  /// ke dokumen Firestore. Nama field di sini (kanan) mengikuti nama
  /// kolom yang dipakai di database, yang sebagian berbeda dengan
  /// nama properti Dart (contoh: keterangan -> 'ket').
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
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

    // Simpan rating hanya jika sudah diberikan
    if (rating != null) {
      data['rating'] = rating;
    }

    return data;
  }

  /// Factory constructor untuk mengubah satu DocumentSnapshot dari
  /// Firestore menjadi objek Aspirasi. Dipakai setiap kali membaca
  /// data (baik lewat StreamBuilder/snapshot maupun query biasa).
  /// Setiap field diberi nilai default ('' atau null) agar aplikasi
  /// tidak crash jika ada dokumen lama yang belum punya field tertentu.
  factory Aspirasi.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
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

      // RATING
      rating: data['rating'] is num ? (data['rating'] as num).toInt() : null,
    );
  }
}
