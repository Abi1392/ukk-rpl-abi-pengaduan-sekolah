import 'package:flutter/material.dart';

import '../main.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================
      // APP BAR
      // ==========================================
      appBar: AppBar(
        title: const Text(
          'Bantuan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pusat Bantuan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Panduan menggunakan aplikasi '
                    'Pengaduan Sarana Sekolah.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Pertanyaan Umum',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ==========================================
            // PERTANYAAN 1
            // ==========================================
            _HelpItem(
              question: 'Bagaimana cara membuat pengaduan?',
              answer: 'Login terlebih dahulu sebagai siswa. '
                  'Setelah berhasil login, pilih menu pengaduan '
                  'dan isi data sarana yang ingin dilaporkan.',
            ),

            // ==========================================
            // PERTANYAAN 2
            // ==========================================
            _HelpItem(
              question: 'Bagaimana cara melihat pengaduan?',
              answer: 'Setelah login, buka menu Riwayat Pengaduan '
                  'untuk melihat pengaduan yang pernah dibuat '
                  'beserta statusnya.',
            ),

            // ==========================================
            // PERTANYAAN 3
            // ==========================================
            _HelpItem(
              question: 'Bagaimana cara login sebagai siswa?',
              answer: 'Buka menu Profil pada bagian kanan atas '
                  'Dashboard, kemudian pilih Login Siswa.',
            ),

            // ==========================================
            // PERTANYAAN 4
            // ==========================================
            _HelpItem(
              question: 'Bagaimana cara login sebagai admin?',
              answer: 'Buka menu Profil pada bagian kanan atas '
                  'Dashboard, kemudian pilih Login Admin. '
                  'Masukkan username dan password admin.',
            ),

            // ==========================================
            // PERTANYAAN 5
            // ==========================================
            _HelpItem(
              question: 'Apa fungsi aplikasi ini?',
              answer: 'Aplikasi ini digunakan untuk membantu siswa '
                  'melaporkan kerusakan atau masalah sarana '
                  'dan prasarana sekolah kepada pihak sekolah.',
            ),

            const SizedBox(height: 25),

            // ==========================================
            // INFORMASI
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Jika mengalami masalah saat menggunakan '
                      'aplikasi, silakan hubungi pihak sekolah.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// ITEM BANTUAN
// ======================================================

class _HelpItem extends StatelessWidget {
  final String question;
  final String answer;

  const _HelpItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 3,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          18,
          0,
          18,
          18,
        ),
        leading: const Icon(
          Icons.help_outline,
          color: AppColors.primary,
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
