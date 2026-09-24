// ============================================================
// MODEL: Siswa
// ------------------------------------------------------------
// Merepresentasikan data akun siswa (untuk login & identitas
// saat mengirim aspirasi). Password disimpan apa adanya di sini
// -> sebaiknya untuk presentasi disebutkan bahwa idealnya password
// di-hash, bukan disimpan plain text.
// ============================================================
class Siswa {
  final String nis; // Nomor Induk Siswa, dipakai sebagai username/ID login
  final String kelas;
  final String nama;
  final String password;

  Siswa({
    required this.nis,
    required this.kelas,
    required this.nama,
    required this.password,
  });

  /// Konversi ke Map untuk disimpan ke Firestore saat registrasi.
  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'kelas': kelas,
      'nama': nama,
      'password': password,
    };
  }

  /// Membaca data siswa dari Map (hasil dari Firestore) menjadi objek Siswa.
  factory Siswa.fromMap(Map<String, dynamic> data) {
    return Siswa(
      nis: data['nis']?.toString() ?? '',
      kelas: data['kelas']?.toString() ?? '',
      nama: data['nama']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
    );
  }
}
