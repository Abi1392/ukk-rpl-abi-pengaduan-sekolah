import 'package:flutter/material.dart';
import '../models/siswa.dart';
import '../services/firestore_service.dart';
import 'menu_screen.dart';

/// Halaman Registrasi: HANYA berhasil jika NIS belum pernah terdaftar.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _kelasController = TextEditingController();
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  final FirestoreService _service = FirestoreService();

  bool _sedangProses = false;
  bool _passwordTersembunyi = true;

  @override
  void dispose() {
    _nisController.dispose();
    _kelasController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _konfirmasiPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak cocok.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _sedangProses = true);
    final nis = _nisController.text.trim();

    try {
      final siswaLama = await _service.cariSiswaByNis(nis);

      if (siswaLama != null) {
        if (!mounted) return;
        setState(() => _sedangProses = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('NIS ini sudah terdaftar. Silakan gunakan menu Login.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final siswaBaru = Siswa(
        nis: nis,
        kelas: _kelasController.text.trim(),
        nama: _namaController.text.trim(),
        password: _passwordController.text,
      );
      await _service.daftarSiswaBaru(siswaBaru);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen(siswa: siswaBaru)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar: $e')),
      );
    } finally {
      if (mounted) setState(() => _sedangProses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Siswa Baru')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Icon(Icons.person_add, size: 72, color: Colors.indigo),
              const SizedBox(height: 12),
              const Text(
                'Daftar sebagai siswa baru',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'NIS wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Kelas wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _passwordTersembunyi,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordTersembunyi
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(
                        () => _passwordTersembunyi = !_passwordTersembunyi),
                  ),
                ),
                validator: (v) => (v == null || v.length < 4)
                    ? 'Password minimal 4 karakter'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _konfirmasiPasswordController,
                obscureText: _passwordTersembunyi,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Konfirmasi password wajib diisi'
                    : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                icon: _sedangProses
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: Text(_sedangProses ? 'Memproses...' : 'Daftar'),
                onPressed: _sedangProses ? null : _daftar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
