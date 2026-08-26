import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';
import 'menu_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // ==========================================
    // VIDEO BACKGROUND
    // ==========================================
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

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // ==========================================
  // MASUK APLIKASI
  // ==========================================
  void _masukAplikasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ==========================================
          // VIDEO BACKGROUND
          // ==========================================
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

          // ==========================================
          // OVERLAY
          // ==========================================
          Container(
            color: Colors.black.withOpacity(0.38),
          ),

          // ==========================================
          // LANDING
          // ==========================================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==========================================
                    // LOGO
                    // ==========================================
                    Image.asset(
                      'assets/images/logo_sekolah.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // NAMA SEKOLAH
                    // ==========================================
                    const Text(
                      'SMA N 1 SEWON',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==========================================
                    // NAMA APLIKASI
                    // ==========================================
                    const Text(
                      'Aplikasi Pengaduan Sarana Sekolah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),

                    // ==========================================
                    // KARTU LANDING
                    // ==========================================
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        30,
                        35,
                        30,
                        35,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(28),
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
                      child: Column(
                        children: [
                          const Text(
                            'Selamat Datang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Sampaikan pengaduan sarana sekolah\n'
                            'dengan mudah dan cepat.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ==========================================
                          // MASUK APLIKASI
                          // ==========================================
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 25,
                              ),
                              label: const Text(
                                'Masuk Aplikasi',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _masukAplikasi,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      '© SMA N 1 Sewon',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
