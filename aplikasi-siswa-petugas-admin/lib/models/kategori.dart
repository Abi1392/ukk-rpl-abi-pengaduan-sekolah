// ============================================================
// MODEL: Kategori
// ------------------------------------------------------------
// Kategori aspirasi (jenis pengaduan). Berbeda dari model lain,
// daftar kategori di sini bersifat STATIS (hardcode di dalam kode,
// bukan diambil dari Firestore) -> lebih sederhana & cepat, tapi
// artinya untuk menambah kategori baru harus edit kode & build ulang.
// ============================================================
class Kategori {
  final String idKategori;
  final String ketKategori; // Nama/keterangan kategori yang tampil di UI
  Kategori({required this.idKategori, required this.ketKategori});
}

// Kumpulan data & fungsi bantu terkait kategori (dipakai seperti util/static class).
class KategoriData {
  /// Daftar tetap kategori aspirasi yang bisa dipilih siswa saat membuat laporan.
  static final List<Kategori> daftarKategori = [
    Kategori(idKategori: '1', ketKategori: 'Kerusakan Elektronik'),
    Kategori(idKategori: '2', ketKategori: 'Kerusakan Bangunan/Fasilitas'),
    Kategori(idKategori: '3', ketKategori: 'Kebersihan Lingkungan'),
    Kategori(idKategori: '4', ketKategori: 'Sarana Olahraga'),
    Kategori(idKategori: '5', ketKategori: 'Lainnya'),
  ];

  /// Mencari nama kategori berdasarkan ID-nya. Dipakai saat aspirasi
  /// yang tersimpan hanya membawa idKategori, lalu perlu ditampilkan
  /// namanya di layar (misal daftar histori). Jika tidak ketemu, kembalikan '-'.
  static String cariKetKategori(String idKategori) {
    final hasil = daftarKategori.where((k) => k.idKategori == idKategori);
    return hasil.isNotEmpty ? hasil.first.ketKategori : '-';
  }
}
