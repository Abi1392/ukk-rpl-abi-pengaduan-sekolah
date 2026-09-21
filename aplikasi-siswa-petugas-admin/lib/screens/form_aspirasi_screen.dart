import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/aspirasi.dart';
import '../models/kategori.dart';
import '../services/firestore_service.dart';

class FormAspirasiScreen extends StatefulWidget {
  final String nis;
  final String kelas;
  final String nama;
  const FormAspirasiScreen({
    super.key,
    required this.nis,
    required this.kelas,
    required this.nama,
  });

  @override
  State<FormAspirasiScreen> createState() => _FormAspirasiScreenState();
}

class _FormAspirasiScreenState extends State<FormAspirasiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lokasiController = TextEditingController();
  final _keteranganController = TextEditingController();
  final FirestoreService _service = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  String _idKategoriTerpilih = KategoriData.daftarKategori.first.idKategori;
  bool _sedangMenyimpan = false;

  Uint8List? _fotoBytes;
  String _fotoBase64 = '';

  @override
  void dispose() {
    _lokasiController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  /// Fungsi: ambil foto dari kamera/galeri, kompres, lalu ubah ke base64
  Future<void> _pilihFoto(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 40, // kompres agar ukuran file kecil
      maxWidth: 800,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      _fotoBytes = bytes;
      _fotoBase64 = base64Encode(bytes);
    });
  }

  void _hapusFoto() {
    setState(() {
      _fotoBytes = null;
      _fotoBase64 = '';
    });
  }

  void _tampilkanPilihanSumberFoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pilihFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pilihFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _simpanAspirasi() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sedangMenyimpan = true);

    final aspirasiBaru = Aspirasi(
      nis: widget.nis,
      nama: widget.nama,
      kelas: widget.kelas,
      idKategori: _idKategoriTerpilih,
      kategori: KategoriData.cariKetKategori(_idKategoriTerpilih),
      lokasi: _lokasiController.text.trim(),
      keterangan: _keteranganController.text.trim(),
      status: 'Menunggu',
      feedback: '',
      fotoBase64: _fotoBase64,
    );

    try {
      await _service.tambahAspirasi(aspirasiBaru);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aspirasi berhasil dikirim!')),
      );
      _lokasiController.clear();
      _keteranganController.clear();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim aspirasi: $e')),
      );
    } finally {
      if (mounted) setState(() => _sedangMenyimpan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Aspirasi Siswa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Nama: ${widget.nama}\nNIS: ${widget.nis}   |   Kelas: ${widget.kelas}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _idKategoriTerpilih,
                decoration: const InputDecoration(
                  labelText: 'Kategori Pengaduan',
                  border: OutlineInputBorder(),
                ),
                items: KategoriData.daftarKategori
                    .map((k) => DropdownMenuItem(
                          value: k.idKategori,
                          child: Text(k.ketKategori),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _idKategoriTerpilih = value!);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lokasiController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Contoh: Ruang Kelas XII RPL 1',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Lokasi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keteranganController,
                maxLength: 50,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Pengaduan',
                  hintText: 'Jelaskan masalah/kerusakan secara singkat',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Keterangan wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // ---------- BAGIAN FOTO ----------
              const Text('Foto Bukti (Opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (_fotoBytes == null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Tambah Foto'),
                  onPressed: _tampilkanPilihanSumberFoto,
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _fotoBytes!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Ganti Foto'),
                          onPressed: _tampilkanPilihanSumberFoto,
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.delete,
                              size: 18, color: Colors.red),
                          label: const Text('Hapus',
                              style: TextStyle(color: Colors.red)),
                          onPressed: _hapusFoto,
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: _sedangMenyimpan
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send),
                label:
                    Text(_sedangMenyimpan ? 'Mengirim...' : 'Kirim Aspirasi'),
                onPressed: _sedangMenyimpan ? null : _simpanAspirasi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
