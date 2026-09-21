import 'dart:async';
import 'package:flutter/material.dart';

import '../main.dart';
import 'landing_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // ==========================================
    // LOADING → LANDING UTAMA
    // ==========================================
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LandingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_sekolah.png',
                  height: 130,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 25),
                const Text(
                  'SMA N 1 SEWON',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aplikasi Pengaduan Sarana Sekolah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 45),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.white24,
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Memuat aplikasi...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
