class Kategori {
  final String idKategori;
  final String ketKategori;
  Kategori({required this.idKategori, required this.ketKategori});
}

class KategoriData {
  static final List<Kategori> daftarKategori = [
    Kategori(idKategori: '1', ketKategori: 'Kerusakan Elektronik'),
    Kategori(idKategori: '2', ketKategori: 'Kerusakan Bangunan/Fasilitas'),
    Kategori(idKategori: '3', ketKategori: 'Kebersihan Lingkungan'),
    Kategori(idKategori: '4', ketKategori: 'Sarana Olahraga'),
    Kategori(idKategori: '5', ketKategori: 'Lainnya'),
  ];

  static String cariKetKategori(String idKategori) {
    final hasil = daftarKategori.where((k) => k.idKategori == idKategori);
    return hasil.isNotEmpty ? hasil.first.ketKategori : '-';
  }
}
