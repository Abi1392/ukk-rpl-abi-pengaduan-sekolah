import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/aspirasi.dart';
import '../services/firestore_service.dart';

class HistoriAspirasiScreen extends StatelessWidget {
  final String nis;
  const HistoriAspirasiScreen({super.key, required this.nis});

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Proses':
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Histori Aspirasi Saya')),
      body: StreamBuilder<List<Aspirasi>>(
        stream: service.streamHistoriByNis(nis),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final daftar = snapshot.data ?? [];
          if (daftar.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Belum ada aspirasi yang dikirim.',
                    textAlign: TextAlign.center),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: daftar.length,
            itemBuilder: (context, index) {
              final item = daftar[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.kategori,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _warnaStatus(item.status)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: _warnaStatus(item.status)),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                color: _warnaStatus(item.status),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Lokasi: ${item.lokasi}'),
                      const SizedBox(height: 4),
                      Text('Keterangan: ${item.keterangan}'),
                      if (item.fotoBase64.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(item.fotoBase64),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      if (item.tanggal != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(item.tanggal!)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                      if (item.feedback.isNotEmpty) ...[
                        const Divider(height: 20),
                        const Text('Umpan Balik Admin:',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(item.feedback),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
