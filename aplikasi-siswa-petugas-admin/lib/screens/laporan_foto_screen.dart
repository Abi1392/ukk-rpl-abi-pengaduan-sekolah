import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/aspirasi.dart';
import '../services/firestore_service.dart';

class LaporanFotoScreen extends StatefulWidget {
  const LaporanFotoScreen({super.key});

  @override
  State<LaporanFotoScreen> createState() => _LaporanFotoScreenState();
}

class _LaporanFotoScreenState extends State<LaporanFotoScreen> {
  final FirestoreService _service = FirestoreService();
  DateTime? _filterTanggal;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Aspirasi> _filterSelesaiBerFotoSelesai(List<Aspirasi> semua) {
    return semua.where((a) {
      final sudahSelesai = a.status == 'Selesai';
      final adaFotoSelesai = a.fotoSelesaiBase64.isNotEmpty;
      final cocokTanggal = _filterTanggal == null ||
          (a.tanggal != null &&
              a.tanggal!.year == _filterTanggal!.year &&
              a.tanggal!.month == _filterTanggal!.month &&
              a.tanggal!.day == _filterTanggal!.day);
      final kataKunci = _searchController.text.trim().toLowerCase();
      final cocokPencarian = kataKunci.isEmpty ||
          a.nis.toLowerCase().contains(kataKunci) ||
          a.nama.toLowerCase().contains(kataKunci) ||
          a.lokasi.toLowerCase().contains(kataKunci);
      return sudahSelesai && adaFotoSelesai && cocokTanggal && cocokPencarian;
    }).toList();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _filterTanggal ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (hasil != null) setState(() => _filterTanggal = hasil);
  }

  void _bukaDetailFoto(Aspirasi item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 460,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2E7D32).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Selesai',
                              style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.fotoBase64.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sebelum',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                      base64Decode(item.fotoBase64),
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                              ],
                            ),
                          ),
                        if (item.fotoBase64.isNotEmpty)
                          const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sesudah (Selesai)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                    base64Decode(item.fotoSelesaiBase64),
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('${item.nama} (NIS: ${item.nis})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Kelas: ${item.kelas}',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Kategori: ${item.kategori}',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Lokasi: ${item.lokasi}',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Keterangan: ${item.keterangan}',
                        style: const TextStyle(fontSize: 13)),
                    if (item.tanggal != null) ...[
                      const SizedBox(height: 4),
                      Text(
                          'Tanggal Lapor: ${DateFormat('dd MMM yyyy, HH:mm').format(item.tanggal!)}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                    if (item.feedback.isNotEmpty) ...[
                      const Divider(height: 20),
                      const Text('Umpan Balik Admin:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(item.feedback, style: const TextStyle(fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo_sekolah.png', height: 36),
            const SizedBox(width: 12),
            const Text('Laporan Foto Selesai'),
          ],
        ),
      ),
      body: StreamBuilder<List<Aspirasi>>(
        stream: _service.streamSemuaAspirasi(),
        builder: (context, snapshot) {
          final semua = snapshot.data ?? [];
          final daftar = _filterSelesaiBerFotoSelesai(semua);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                                '${daftar.length} laporan dengan bukti perbaikan',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Cari NIS / Nama / Lokasi',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(_filterTanggal == null
                            ? 'Filter Tanggal'
                            : DateFormat('dd MMM yyyy')
                                .format(_filterTanggal!)),
                        onPressed: _pilihTanggal,
                      ),
                      if (_filterTanggal != null)
                        IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => _filterTanggal = null)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : daftar.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.photo_library_outlined,
                                      size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  Text(
                                      'Belum ada laporan dengan foto bukti perbaikan',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: daftar.length,
                              itemBuilder: (context, index) {
                                final item = daftar[index];
                                return Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  elevation: 1,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () => _bukaDetailFoto(item),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(14)),
                                            child: Image.memory(
                                              base64Decode(
                                                  item.fotoSelesaiBase64),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.nama,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(height: 2),
                                              Text(item.lokasi,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade600),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2E7D32)
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text('Selesai',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF2E7D32),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
