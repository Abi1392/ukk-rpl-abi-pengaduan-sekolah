import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'menu_screen.dart';

/// ============================================================
/// LOGIN SISWA
/// ============================================================
/// Login hanya berhasil jika:
/// 1. NIS terdaftar
/// 2. Password sesuai
///
/// Setelah berhasil langsung masuk ke BERANDA SISWA.
/// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nisController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirestoreService _service = FirestoreService();

  bool _sedangProses = false;
  bool _passwordTersembunyi = true;

  @override
  void dispose() {
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // PROSES LOGIN
  // ============================================================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sedangProses = true;
    });

    final nis = _nisController.text.trim();
    final password = _passwordController.text;

    try {
      // ========================================================
      // CARI SISWA
      // ========================================================

      final siswa = await _service.cariSiswaByNis(nis);

      // ========================================================
      // NIS TIDAK DITEMUKAN
      // ========================================================

      if (siswa == null) {
        if (!mounted) return;

        setState(() {
          _sedangProses = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'NIS belum terdaftar. Silakan daftar terlebih dahulu.',
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }

      // ========================================================
      // PASSWORD SALAH
      // ========================================================

      if (siswa.password != password) {
        if (!mounted) return;

        setState(() {
          _sedangProses = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password salah.',
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }

      // ========================================================
      // LOGIN BERHASIL
      // ========================================================

      if (!mounted) return;

      // Langsung masuk ke Beranda Siswa.
      //
      // pushReplacement digunakan supaya halaman Login
      // tidak bisa kembali dengan tombol Back.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MenuScreen(
            siswa: siswa,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal login: $e',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangProses = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Siswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ==================================================
                    // ICON
                    // ==================================================

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Colors.indigo,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Masuk menggunakan NIS dan password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // NIS
                    // ==================================================

                    TextFormField(
                      controller: _nisController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'NIS',
                        hintText: 'Masukkan NIS',
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'NIS wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // PASSWORD
                    // ==================================================

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordTersembunyi,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordTersembunyi
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordTersembunyi = !_passwordTersembunyi;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // TOMBOL LOGIN
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        icon: _sedangProses
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.login,
                              ),
                        label: Text(
                          _sedangProses ? 'Memproses...' : 'Masuk ke Beranda',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _sedangProses ? null : _login,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Setelah login kamu akan langsung masuk '
                      'ke Beranda Pengaduan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
