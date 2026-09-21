import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aspirasi.dart';
import '../models/siswa.dart';
import '../models/admin.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _aspirasiRef =
      FirebaseFirestore.instance.collection('aspirasi');
  final CollectionReference<Map<String, dynamic>> _siswaRef =
      FirebaseFirestore.instance.collection('siswa');
  final CollectionReference<Map<String, dynamic>> _adminRef =
      FirebaseFirestore.instance.collection('admin');

  Future<void> tambahAspirasi(Aspirasi aspirasi) async {
    await _aspirasiRef.add(aspirasi.toMap());
  }

  Stream<List<Aspirasi>> streamHistoriByNis(String nis) {
    return _aspirasiRef
        .where('nis', isEqualTo: nis)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Aspirasi.fromDoc(d)).toList());
  }

  Future<Siswa?> cariSiswaByNis(String nis) async {
    final doc = await _siswaRef.doc(nis).get();
    if (!doc.exists) return null;
    return Siswa.fromMap(doc.data()!);
  }

  Future<void> daftarSiswaBaru(Siswa siswa) async {
    await _siswaRef.doc(siswa.nis).set(siswa.toMap());
  }

  // ---------- DITAMBAHKAN UNTUK ADMIN ----------

  Stream<List<Aspirasi>> streamSemuaAspirasi() {
    return _aspirasiRef
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Aspirasi.fromDoc(d)).toList());
  }

  Future<void> updateStatusFeedback({
    required String idAspirasi,
    required String status,
    required String feedback,
    String? fotoSelesaiBase64,
  }) async {
    final data = <String, dynamic>{
      'status': status,
      'feedback': feedback,
    };
    if (fotoSelesaiBase64 != null) {
      data['foto_selesai_base64'] = fotoSelesaiBase64;
    }
    await _aspirasiRef.doc(idAspirasi).update(data);
  }

  Future<bool> verifikasiAdmin(String username, String password) async {
    final snap =
        await _adminRef.where('username', isEqualTo: username).limit(1).get();
    if (snap.docs.isEmpty) return false;
    final admin = Admin.fromMap(snap.docs.first.data());
    return admin.password == password;
  }
}
