import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/data/dummy_data.dart';
import '../../../shared/models/models.dart';
import 'hasil_absensi_page.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});
  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final _controller = MobileScannerController();
  bool _handled = false;
  bool _cooldown = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw != null) _process(raw);
  }

/// Format QR: `ABSENSI|<id_matkul>|<timestamp>`
  void _process(String raw) {
    final parts = raw.split('|');
    if (parts.length < 3 || parts[0] != 'ABSENSI') {
      if (_cooldown) return;
      _cooldown = true;
      Future.delayed(const Duration(seconds: 2), () => _cooldown = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code tidak dikenali. Pindai QR dari dosen.')),
      );
      return;
    }
    _handled = true;
    final course = DummyData.courseById(parts[1]);
    final record = AttendanceRecord(
      courseName: course.name,
      date: DateTime.now(),
      status: AttendStatus.hadir,
    );
    // TODO: kirim token ke server untuk divalidasi.
    AppState.instance.addAttendance(record);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HasilAbsensiPage(record: record)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(fit: StackFit.expand, children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                      errorBuilder: (context, error,) => const ColoredBox(
                        color: AppColors.ink,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Kamera tidak tersedia.\nGunakan tombol simulasi di bawah.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.accent, width: 3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Arahkan kamera ke QR Code\nyang ditampilkan dosen',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _process(
                    'ABSENSI|PM01|${DateTime.now().millisecondsSinceEpoch}'),
                child: const Text('Simulasi scan (tanpa kamera)'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
