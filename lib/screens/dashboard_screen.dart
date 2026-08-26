import 'package:flutter/material.dart';

import '../main.dart';
import 'login_screen.dart';
import 'admin_login_screen.dart';
import 'help_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ==========================================
  // MENU LOGIN DARI PROFIL
  // ==========================================
  void _bukaProfil(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            24,
            15,
            24,
            25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==========================================
                // HANDLE
                // ==========================================
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                // ==========================================
                // ICON PROFIL
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 35,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Profil & Akun',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Silakan masuk untuk menggunakan fitur aplikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 24),

                // ==========================================
                // LOGIN SISWA
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.person_outline,
                    ),
                    label: const Text(
                      'Login Siswa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ==========================================
                // LOGIN ADMIN
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.admin_panel_settings_outlined,
                    ),
                    label: const Text(
                      'Login Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // FITUR YANG MEMBUTUHKAN LOGIN
  // ==========================================
  void _belumLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Silakan login melalui menu Profil terlebih dahulu.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================
      // APP BAR
      // ==========================================
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // ==========================================
          // PROFIL
          // ==========================================
          IconButton(
            tooltip: 'Profil',
            onPressed: () => _bukaProfil(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
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
            // HEADER DASHBOARD
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Aplikasi Pengaduan Sarana Sekolah',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================
            // JUDUL FITUR
            // ==========================================
            const Text(
              'Fitur Aplikasi',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // BUAT PENGADUAN
            // ==========================================
            _DashboardCard(
              icon: Icons.edit_note,
              title: 'Buat Pengaduan',
              subtitle: 'Laporkan kerusakan atau masalah sarana sekolah.',
              iconColor: AppColors.primary,
              onTap: () => _belumLogin(context),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // RIWAYAT
            // ==========================================
            _DashboardCard(
              icon: Icons.history,
              title: 'Riwayat Pengaduan',
              subtitle: 'Lihat status dan riwayat pengaduan kamu.',
              iconColor: AppColors.gold,
              onTap: () => _belumLogin(context),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // BANTUAN
            // ==========================================
            _DashboardCard(
              icon: Icons.help_outline,
              title: 'Bantuan',
              subtitle:
                  'Panduan menggunakan aplikasi pengaduan sarana sekolah.',
              iconColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ==========================================
            // KETERANGAN LOGIN
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
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Gunakan menu Profil di kanan atas '
                      'untuk Login Siswa atau Login Admin.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CARD DASHBOARD
// ======================================================

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 29,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
