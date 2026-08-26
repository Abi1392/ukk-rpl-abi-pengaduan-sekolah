import 'package:flutter/material.dart';

/// Widget corak/motif berulang dari logo sekolah, dipakai sebagai
/// background dekoratif di halaman-halaman utama (Landing, Login).
class PatternBackground extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;

  const PatternBackground({
    super.key,
    required this.child,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // ---------- CORAK LOGO BERULANG (samar-samar) ----------
          Positioned(
            top: -40,
            left: -30,
            child: Opacity(
              opacity: 0.10,
              child: Transform.rotate(
                angle: -0.3,
                child:
                    Image.asset('assets/images/logo_sekolah.png', width: 160),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -50,
            child: Opacity(
              opacity: 0.08,
              child: Transform.rotate(
                angle: 0.4,
                child:
                    Image.asset('assets/images/logo_sekolah.png', width: 200),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: Opacity(
              opacity: 0.09,
              child: Transform.rotate(
                angle: 0.2,
                child:
                    Image.asset('assets/images/logo_sekolah.png', width: 220),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -20,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: -0.25,
                child:
                    Image.asset('assets/images/logo_sekolah.png', width: 180),
              ),
            ),
          ),
          // ---------- KONTEN UTAMA ----------
          child,
        ],
      ),
    );
  }
}
