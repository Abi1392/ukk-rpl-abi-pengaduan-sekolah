import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';
import '../services/firestore_service.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirestoreService _service = FirestoreService();

  late VideoPlayerController _videoController;

  bool _sedangProses = false;
  bool _passwordTersembunyi = true;

  // =====================================
  // INIT STATE
  // =====================================
  @override
  void initState() {
    super.initState();

    // =====================================
    // VIDEO BACKGROUND
    // =====================================
    _videoController = VideoPlayerController.asset(
      'assets/videos/background.mp4',
    )..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }

        _videoController.setLooping(true);
        _videoController.setVolume(0);
        _videoController.play();
      });
  }

  // =====================================
  // DISPOSE
  // =====================================
  @override
  void dispose() {
    _videoController.dispose();

    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // =====================================
  // LOGIN ADMIN
  // =====================================
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangProses = true);

    try {
      final berhasil = await _service.verifikasiAdmin(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      // =====================================
      // LOGIN GAGAL
      // =====================================
      if (!berhasil) {
        if (!mounted) return;

        setState(() => _sedangProses = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah.'),
            backgroundColor: Colors.redAccent,
          ),
        );

        return;
      }

      // =====================================
      // LOGIN BERHASIL
      // =====================================
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal login: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sedangProses = false);
      }
    }
  }

  // =====================================
  // BUILD
  // =====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // =====================================
          // VIDEO BACKGROUND
          // =====================================
          if (_videoController.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            Container(
              color: AppColors.primaryDark,
            ),

          // =====================================
          // OVERLAY
          // =====================================
          Container(
            color: Colors.black.withOpacity(0.35),
          ),

          // =====================================
          // LOGIN ADMIN
          // =====================================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.gold,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // =====================================
                          // LOGO
                          // =====================================
                          Image.asset(
                            'assets/images/logo_sekolah.png',
                            height: 110,
                          ),

                          const SizedBox(height: 12),

                          // =====================================
                          // NAMA SEKOLAH
                          // =====================================
                          const Text(
                            'SMA N 1 SEWON',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // =====================================
                          // SUBTITLE
                          // =====================================
                          const Text(
                            'Admin Panel — Pengaduan Sarana Sekolah',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // =====================================
                          // USERNAME
                          // =====================================
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Username wajib diisi';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // =====================================
                          // PASSWORD
                          // =====================================
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _passwordTersembunyi,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                                    _passwordTersembunyi =
                                        !_passwordTersembunyi;
                                  });
                                },
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password wajib diisi';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 26),

                          // =====================================
                          // TOMBOL LOGIN
                          // =====================================
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: _sedangProses
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.login,
                                    ),
                              label: Text(
                                _sedangProses
                                    ? 'Memproses...'
                                    : 'Masuk Dashboard',
                              ),
                              onPressed: _sedangProses ? null : _login,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =====================================
                          // KEMBALI
                          // =====================================
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Kembali',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
