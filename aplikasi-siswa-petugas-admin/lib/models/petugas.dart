// ============================================================
// MODEL: Petugas
// ------------------------------------------------------------
// Data akun petugas (staf yang bertugas menindaklanjuti/menangani
// aspirasi siswa di lapangan) untuk proses login.
// ============================================================
class Petugas {
  final String username;
  final String password;
  final String nama;

  Petugas({
    required this.username,
    required this.password,
    this.nama = '',
  });

  factory Petugas.fromMap(Map<String, dynamic> data) {
    return Petugas(
      username: data['username']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
      nama: data['nama']?.toString() ?? '',
    );
  }
}
