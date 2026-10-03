import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../shared/data/dummy_data.dart';
import '../../../shared/pages/jadwal_page.dart';
import '../../auth/presentation/login_page.dart';
import '../riwayat_absensi/riwayat_page.dart';
import '../scan_qr/scan_qr_page.dart';

class MahasiswaDashboardPage extends StatelessWidget {
  const MahasiswaDashboardPage({super.key});

  void _go(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final today = DummyData.courses.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Mahasiswa'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (r) => false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Halo, ${DummyData.studentName}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          const Text('NIM ${DummyData.studentNim}',
              style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(72),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.ink,
            ),
            icon: const Icon(Icons.qr_code_scanner, size: 28),
            label: const Text('Scan QR Code'),
            onPressed: () => _go(context, const ScanQrPage()),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _go(context, const JadwalPage()),
                child: const Text('Jadwal Kuliah'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _go(context, const RiwayatPage()),
                child: const Text('Riwayat Absensi'),
              ),
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Mata kuliah hari ini',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(today.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 4),
              Text('${today.time}  •  ${today.room}',
                  style: const TextStyle(color: AppColors.muted)),
            ]),
          ),
        ],
      ),
    );
  }
}
