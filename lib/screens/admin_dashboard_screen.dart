import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/aspirasi.dart';
import '../models/kategori.dart';
import '../services/firestore_service.dart';
import '../widgets/status_pie_chart.dart';
import 'admin_login_screen.dart';
import 'laporan_foto_screen.dart';
import 'help_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirestoreService _service = FirestoreService();

  String _filterStatus = 'Semua';
  String _filterKategori = 'Semua';
  DateTime? _filterTanggal;

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTER DATA
  // ============================================================

  List<Aspirasi> _terapkanFilter(List<Aspirasi> daftar) {
    return daftar.where((a) {
      final cocokStatus = _filterStatus == 'Semua' || a.status == _filterStatus;

      final cocokKategori =
          _filterKategori == 'Semua' || a.kategori == _filterKategori;

      final cocokTanggal = _filterTanggal == null ||
          (a.tanggal != null &&
              a.tanggal!.year == _filterTanggal!.year &&
              a.tanggal!.month == _filterTanggal!.month &&
              a.tanggal!.day == _filterTanggal!.day);

      final kataKunci = _searchController.text.trim().toLowerCase();

      final cocokPencarian = kataKunci.isEmpty ||
          a.nis.toLowerCase().contains(kataKunci) ||
          a.nama.toLowerCase().contains(kataKunci);

      return cocokStatus && cocokKategori && cocokTanggal && cocokPencarian;
    }).toList();
  }

  // ============================================================
  // PILIH TANGGAL
  // ============================================================

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _filterTanggal ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (hasil != null) {
      setState(() {
        _filterTanggal = hasil;
      });
    }
  }

  // ============================================================
  // HALAMAN BANTUAN
  // ============================================================

  void _bukaBantuan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpScreen(),
      ),
    );
  }

  // ============================================================
  // DIALOG UBAH STATUS
  // ============================================================

  void _bukaDialogUbahStatus(Aspirasi item) {
    String statusTerpilih = item.status;

    final feedbackController = TextEditingController(text: item.feedback);

    Uint8List? fotoSelesaiBytes;
    String? fotoSelesaiBase64Baru;

    final ImagePicker picker = ImagePicker();

    if (item.fotoSelesaiBase64.isNotEmpty) {
      fotoSelesaiBytes = base64Decode(item.fotoSelesaiBase64);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pilihFotoSelesai() async {
              final XFile? file = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 40,
                maxWidth: 800,
              );

              if (file == null) return;

              final bytes = await file.readAsBytes();

              setDialogState(() {
                fotoSelesaiBytes = bytes;
                fotoSelesaiBase64Baru = base64Encode(bytes);
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: 440,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // JUDUL
                        // ==================================================

                        const Row(
                          children: [
                            Icon(
                              Icons.assignment,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Detail Aspirasi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _baris(
                          'Siswa',
                          '${item.nama} (${item.nis})',
                        ),

                        _baris(
                          'Kelas',
                          item.kelas,
                        ),

                        _baris(
                          'Kategori',
                          item.kategori,
                        ),

                        _baris(
                          'Lokasi',
                          item.lokasi,
                        ),

                        _baris(
                          'Keterangan',
                          item.keterangan,
                        ),

                        // ==================================================
                        // FOTO SEBELUM
                        // ==================================================

                        if (item.fotoBase64.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Foto Laporan (Sebelum):',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(item.fotoBase64),
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        // ==================================================
                        // STATUS
                        // ==================================================

                        DropdownButtonFormField<String>(
                          value: statusTerpilih,
                          decoration: const InputDecoration(
                            labelText: 'Status Penyelesaian',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Menunggu',
                              child: Text('Menunggu'),
                            ),
                            DropdownMenuItem(
                              value: 'Proses',
                              child: Text('Proses'),
                            ),
                            DropdownMenuItem(
                              value: 'Selesai',
                              child: Text('Selesai'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setDialogState(() {
                              statusTerpilih = value;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        // ==================================================
                        // FEEDBACK
                        // ==================================================

                        TextField(
                          controller: feedbackController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Umpan Balik untuk Siswa',
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ==================================================
                        // FOTO SELESAI
                        // ==================================================

                        const Text(
                          'Foto Bukti Perbaikan (Sesudah):',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (fotoSelesaiBytes == null)
                          OutlinedButton.icon(
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 18,
                            ),
                            label: const Text(
                              'Upload Foto Selesai',
                            ),
                            onPressed: pilihFotoSelesai,
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  fotoSelesaiBytes!,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Ganti Foto',
                                ),
                                onPressed: pilihFotoSelesai,
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // TOMBOL
                        // ==================================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Batal'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                await _service.updateStatusFeedback(
                                  idAspirasi: item.id!,
                                  status: statusTerpilih,
                                  feedback: feedbackController.text.trim(),
                                  fotoSelesaiBase64: fotoSelesaiBase64Baru,
                                );

                                SystemSound.play(
                                  SystemSoundType.click,
                                );

                                if (context.mounted) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Status berhasil diperbarui!',
                                      ),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Simpan'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // BARIS DETAIL
  // ============================================================

  Widget _baris(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WARNA STATUS
  // ============================================================

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFF2E7D32);

      case 'Proses':
        return const Color(0xFFEF6C00);

      default:
        return const Color(0xFFC62828);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_sekolah.png',
              height: 36,
            ),
            const SizedBox(width: 12),
            const Text(
              'Dashboard Admin',
            ),
          ],
        ),
        actions: [
          // ========================================================
          // BANTUAN
          // ========================================================

          IconButton(
            icon: const Icon(
              Icons.help_outline,
            ),
            tooltip: 'Bantuan',
            onPressed: _bukaBantuan,
          ),

          // ========================================================
          // LOGOUT
          // ========================================================

          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminLoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // ==========================================================
      // DRAWER
      // ==========================================================

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ======================================================
            // HEADER DRAWER
            // ======================================================

            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/logo_sekolah.png',
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'SMA N 1 Sewon',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Panel Admin',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // DASHBOARD
            // ======================================================

            ListTile(
              leading: const Icon(
                Icons.dashboard,
                color: AppColors.primary,
              ),
              title: const Text(
                'Dashboard',
              ),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ======================================================
            // LAPORAN FOTO
            // ======================================================

            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text(
                'Laporan Foto',
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LaporanFotoScreen(),
                  ),
                );
              },
            ),

            // ======================================================
            // BANTUAN
            // ======================================================

            ListTile(
              leading: const Icon(
                Icons.help_outline,
                color: AppColors.primary,
              ),
              title: const Text(
                'Bantuan',
              ),
              onTap: () {
                Navigator.pop(context);

                _bukaBantuan();
              },
            ),

            const Divider(),

            // ======================================================
            // LOGOUT
            // ======================================================

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminLoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: StreamBuilder<List<Aspirasi>>(
        stream: _service.streamSemuaAspirasi(),
        builder: (context, snapshot) {
          final semua = snapshot.data ?? [];

          final daftar = _terapkanFilter(semua);

          final total = semua.length;

          final menunggu = semua
              .where(
                (a) => a.status == 'Menunggu',
              )
              .length;

          final proses = semua
              .where(
                (a) => a.status == 'Proses',
              )
              .length;

          final selesai = semua
              .where(
                (a) => a.status == 'Selesai',
              )
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // STATISTIK
                // ==================================================

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      label: 'Total Aspirasi',
                      value: '$total',
                      color: AppColors.primary,
                      icon: Icons.inbox,
                    ),
                    _StatCard(
                      label: 'Menunggu',
                      value: '$menunggu',
                      color: const Color(0xFFC62828),
                      icon: Icons.hourglass_empty,
                    ),
                    _StatCard(
                      label: 'Proses',
                      value: '$proses',
                      color: const Color(0xFFEF6C00),
                      icon: Icons.autorenew,
                    ),
                    _StatCard(
                      label: 'Selesai',
                      value: '$selesai',
                      color: const Color(0xFF2E7D32),
                      icon: Icons.check_circle,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // GRAFIK
                // ==================================================

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distribusi Status Aspirasi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StatusPieChart(
                        menunggu: menunggu,
                        proses: proses,
                        selesai: selesai,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // FILTER
                // ==================================================

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // ============================================
                      // SEARCH
                      // ============================================

                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Cari NIS / Nama',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),

                      // ============================================
                      // FILTER STATUS
                      // ============================================

                      SizedBox(
                        width: 170,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _filterStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            isDense: true,
                          ),
                          items: [
                            'Semua',
                            'Menunggu',
                            'Proses',
                            'Selesai',
                          ]
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;

                            setState(() {
                              _filterStatus = v;
                            });
                          },
                        ),
                      ),

                      // ============================================
                      // FILTER KATEGORI
                      // ============================================

                      SizedBox(
                        width: 230,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _filterKategori,
                          decoration: const InputDecoration(
                            labelText: 'Kategori',
                            isDense: true,
                          ),
                          items: [
                            'Semua',
                            ...KategoriData.daftarKategori.map(
                              (k) => k.ketKategori,
                            ),
                          ]
                              .map(
                                (k) => DropdownMenuItem(
                                  value: k,
                                  child: Text(
                                    k,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;

                            setState(() {
                              _filterKategori = v;
                            });
                          },
                        ),
                      ),

                      // ============================================
                      // FILTER TANGGAL
                      // ============================================

                      OutlinedButton.icon(
                        icon: const Icon(
                          Icons.calendar_today,
                          size: 16,
                        ),
                        label: Text(
                          _filterTanggal == null
                              ? 'Filter Tanggal'
                              : DateFormat(
                                  'dd MMM yyyy',
                                ).format(
                                  _filterTanggal!,
                                ),
                        ),
                        onPressed: _pilihTanggal,
                      ),

                      // ============================================
                      // HAPUS FILTER TANGGAL
                      // ============================================

                      if (_filterTanggal != null)
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            setState(() {
                              _filterTanggal = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // TABEL DATA
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : daftar.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(
                                child: Text(
                                  'Tidak ada data aspirasi.',
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Foto',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tanggal',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'NIS',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Nama',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Kelas',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Kategori',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Lokasi',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Keterangan',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Aksi',
                                    ),
                                  ),
                                ],
                                rows: daftar.map(
                                  (item) {
                                    return DataRow(
                                      cells: [
                                        // ==================================
                                        // FOTO
                                        // ==================================

                                        DataCell(
                                          item.fotoBase64.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    6,
                                                  ),
                                                  child: Image.memory(
                                                    base64Decode(
                                                      item.fotoBase64,
                                                    ),
                                                    width: 44,
                                                    height: 44,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                        ),

                                        // ==================================
                                        // TANGGAL
                                        // ==================================

                                        DataCell(
                                          Text(
                                            item.tanggal != null
                                                ? DateFormat(
                                                    'dd/MM/yy HH:mm',
                                                  ).format(
                                                    item.tanggal!,
                                                  )
                                                : '-',
                                          ),
                                        ),

                                        // ==================================
                                        // NIS
                                        // ==================================

                                        DataCell(
                                          Text(item.nis),
                                        ),

                                        // ==================================
                                        // NAMA
                                        // ==================================

                                        DataCell(
                                          Text(item.nama),
                                        ),

                                        // ==================================
                                        // KELAS
                                        // ==================================

                                        DataCell(
                                          Text(item.kelas),
                                        ),

                                        // ==================================
                                        // KATEGORI
                                        // ==================================

                                        DataCell(
                                          Text(
                                            item.kategori,
                                          ),
                                        ),

                                        // ==================================
                                        // LOKASI
                                        // ==================================

                                        DataCell(
                                          Text(
                                            item.lokasi,
                                          ),
                                        ),

                                        // ==================================
                                        // KETERANGAN
                                        // ==================================

                                        DataCell(
                                          SizedBox(
                                            width: 180,
                                            child: Text(
                                              item.keterangan,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        // ==================================
                                        // STATUS
                                        // ==================================

                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _warnaStatus(
                                                item.status,
                                              ).withValues(
                                                alpha: 0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child: Text(
                                              item.status,
                                              style: TextStyle(
                                                color: _warnaStatus(
                                                  item.status,
                                                ),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // ==================================
                                        // AKSI
                                        // ==================================

                                        DataCell(
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: AppColors.primary,
                                            ),
                                            onPressed: () {
                                              _bukaDialogUbahStatus(
                                                item,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// STAT CARD
// ============================================================

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
