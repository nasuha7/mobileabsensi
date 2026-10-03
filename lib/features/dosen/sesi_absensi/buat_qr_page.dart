import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../shared/data/dummy_data.dart';
import '../../../shared/models/models.dart';
import '../rekap_kehadiran/daftar_kehadiran_page.dart';

class BuatQrPage extends StatefulWidget {
  final Course course;
  const BuatQrPage({super.key, required this.course});
  @override
  State<BuatQrPage> createState() => _BuatQrPageState();
}

class _BuatQrPageState extends State<BuatQrPage> {
  static const _durasi = 300; // detik (5 menit)
  Timer? _timer;
  int _sisa = _durasi;
  bool _aktif = false;
  late String _token = _buatToken();

  // TODO: token sebaiknya dibuat & divalidasi server.
  String _buatToken() =>
      'ABSENSI|${widget.course.id}|${DateTime.now().millisecondsSinceEpoch}';

  void _mulai() {
    setState(() {
      _aktif = true;
      _sisa = _durasi;
      _token = _buatToken();
    });
    AppState.instance.setSession(true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _sisa--;
        if (_sisa <= 0) {
          _sisa = _durasi;
          _token = _buatToken(); // QR diperbarui otomatis
        }
      });
    });
  }

  void _akhiri() {
    _timer?.cancel();
    setState(() => _aktif = false);
    AppState.instance.setSession(false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat QR Absensi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Mata kuliah', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 2),
              Text(widget.course.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ]),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(alignment: Alignment.center, children: [
                Opacity(
                  opacity: _aktif ? 1 : 0.12,
                  child: QrImageView(data: _token, size: 220),
                ),
                if (!_aktif)
                  const Text('QR aktif setelah\nsesi dimulai',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.muted)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _aktif ? 'Kode aktif selama: ${menitDetik(_sisa)}' : 'Sesi belum dimulai',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          if (!_aktif)
            FilledButton(onPressed: _mulai, child: const Text('Mulai sesi absensi'))
          else ...[
            OutlinedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DaftarKehadiranPage())),
              child: const Text('Pantau kehadiran'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: _akhiri,
              child: const Text('Akhiri sesi'),
            ),
          ],
          const SizedBox(height: 12),
          const Center(
            child: Text('Tampilkan QR ini kepada mahasiswa untuk dipindai.',
                style: TextStyle(color: AppColors.muted, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
