import 'package:flutter/material.dart';

import '../main.dart';
import '../models/siswa.dart';
import 'admin_login_screen.dart';
import 'form_aspirasi_screen.dart';
import 'help_screen.dart';
import 'histori_aspirasi_screen.dart';
import 'landing_screen.dart';
import 'login_screen.dart';

/// Beranda utama aplikasi.
///
/// [siswa] null = belum login.
/// [siswa] berisi data siswa = sudah login.
/// Beranda tetap halaman yang sama, hanya isi/fiturnya yang berubah.
class MenuScreen extends StatefulWidget {
  final Siswa? siswa;

  const MenuScreen({
    super.key,
    this.siswa,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _halamanAktif = 0;

  bool get _sudahLogin => widget.siswa != null;

  void _gantiHalaman(int index) {
    if (index == 1 || index == 2) {
      if (!_sudahLogin) {
        _bukaLoginSiswa();
        return;
      }
    }

    setState(() {
      _halamanAktif = index;
    });
  }

  void _bukaLoginSiswa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _bukaProfil() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 15, 24, 25),
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
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
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
                Text(
                  _sudahLogin ? widget.siswa!.nama : 'Profil & Akun',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _sudahLogin
                      ? 'NIS ${widget.siswa!.nis} • Kelas ${widget.siswa!.kelas}'
                      : 'Silakan masuk untuk menggunakan fitur pengaduan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                if (!_sudahLogin) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_outline),
                      label: const Text(
                        'Login Siswa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _bukaLoginSiswa();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
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
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _ProfilRow(
                          icon: Icons.badge_outlined,
                          label: 'NIS',
                          value: widget.siswa!.nis,
                        ),
                        const SizedBox(height: 10),
                        _ProfilRow(
                          icon: Icons.person_outline,
                          label: 'Nama',
                          value: widget.siswa!.nama,
                        ),
                        const SizedBox(height: 10),
                        _ProfilRow(
                          icon: Icons.school_outlined,
                          label: 'Kelas',
                          value: widget.siswa!.kelas,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LandingScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _bukaBantuan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpScreen(),
      ),
    );
  }

  void _bukaPengaduan() {
    if (!_sudahLogin) {
      _bukaLoginSiswa();
      return;
    }

    setState(() {
      _halamanAktif = 1;
    });
  }

  void _bukaRiwayat() {
    if (!_sudahLogin) {
      _bukaLoginSiswa();
      return;
    }

    setState(() {
      _halamanAktif = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: _bukaProfil,
          ),
        ],
      ),
      body: IndexedStack(
        index: _halamanAktif,
        children: [
          _BerandaTab(
            siswa: widget.siswa,
            onPengaduan: _bukaPengaduan,
            onRiwayat: _bukaRiwayat,
            onBantuan: _bukaBantuan,
          ),
          if (_sudahLogin)
            FormAspirasiScreen(
              nis: widget.siswa!.nis,
              kelas: widget.siswa!.kelas,
              nama: widget.siswa!.nama,
            )
          else
            const _LoginRequiredTab(),
          if (_sudahLogin)
            HistoriAspirasiScreen(
              nis: widget.siswa!.nis,
            )
          else
            const _LoginRequiredTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _halamanAktif,
        onDestinationSelected: _gantiHalaman,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Pengaduan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}

class _BerandaTab extends StatelessWidget {
  final Siswa? siswa;
  final VoidCallback onPengaduan;
  final VoidCallback onRiwayat;
  final VoidCallback onBantuan;

  const _BerandaTab({
    required this.siswa,
    required this.onPengaduan,
    required this.onRiwayat,
    required this.onBantuan,
  });

  @override
  Widget build(BuildContext context) {
    final sudahLogin = siswa != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/logo_sekolah.png',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sudahLogin ? 'Selamat Datang 👋' : 'Selamat Datang 👋',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sudahLogin ? siswa!.nama : 'di Aplikasi Pengaduan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sudahLogin
                            ? 'NIS ${siswa!.nis} • Kelas ${siswa!.kelas}'
                            : 'Sarana Sekolah SMA N 1 Sewon',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Pengaduan Sarana Sekolah',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            sudahLogin
                ? 'Laporkan sarana sekolah yang rusak atau memerlukan perhatian.'
                : 'Laporkan kerusakan sarana sekolah dengan mudah dan cepat.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _BerandaCard(
            icon: Icons.edit_note,
            iconColor: AppColors.primary,
            title: 'Buat Pengaduan',
            subtitle: sudahLogin
                ? 'Laporkan kerusakan atau masalah sarana sekolah.'
                : 'Login siswa diperlukan untuk membuat pengaduan.',
            onTap: onPengaduan,
            primary: true,
          ),
          const SizedBox(height: 14),
          _BerandaCard(
            icon: Icons.history,
            iconColor: AppColors.gold,
            title: 'Riwayat Pengaduan',
            subtitle: sudahLogin
                ? 'Lihat status dan umpan balik pengaduan kamu.'
                : 'Login siswa diperlukan untuk melihat riwayat.',
            onTap: onRiwayat,
          ),
          const SizedBox(height: 14),
          _BerandaCard(
            icon: Icons.help_outline,
            iconColor: Colors.blue,
            title: 'Bantuan',
            subtitle: 'Panduan menggunakan aplikasi pengaduan sarana sekolah.',
            onTap: onBantuan,
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sudahLogin
                        ? 'Kamu sudah login. Gunakan menu Pengaduan untuk mengirim laporan.'
                        : 'Kamu belum login. Untuk membuat pengaduan dan melihat riwayat, buka Profil lalu Login Siswa.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
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
    );
  }
}

class _LoginRequiredTab extends StatelessWidget {
  const _LoginRequiredTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 60,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login diperlukan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan Login Siswa melalui Profil untuk menggunakan fitur ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _BerandaCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;

  const _BerandaCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: primary ? 2 : 1,
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
                  color: primary
                      ? Colors.white.withOpacity(0.18)
                      : iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: primary ? Colors.white : iconColor,
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
                      style: TextStyle(
                        color: primary ? Colors.white : Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: primary ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primary ? Colors.white : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfilRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
