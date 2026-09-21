class Siswa {
  final String nis;
  final String kelas;
  final String nama;
  final String password;

  Siswa({
    required this.nis,
    required this.kelas,
    required this.nama,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'kelas': kelas,
      'nama': nama,
      'password': password,
    };
  }

  factory Siswa.fromMap(Map<String, dynamic> data) {
    return Siswa(
      nis: data['nis']?.toString() ?? '',
      kelas: data['kelas']?.toString() ?? '',
      nama: data['nama']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
    );
  }
}
