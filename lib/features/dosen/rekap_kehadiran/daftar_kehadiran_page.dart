import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../shared/data/dummy_data.dart';
import '../../../shared/models/models.dart';

class DaftarKehadiranPage extends StatelessWidget {
  const DaftarKehadiranPage({super.key});

  void _info(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Widget _counter(String label, int n, Color c) => Expanded(
        child: Column(children: [
          Text('$n',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: c)),
          Text(label, style: const TextStyle(color: AppColors.muted)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kehadiran'),
        actions: [
          IconButton(
            tooltip: 'Perbarui data',
            icon: const Icon(Icons.refresh),
            onPressed: () => _info(context, 'Data diperbarui'),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(DummyData.courses.first.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                Text(tanggalPanjang(DateTime.now()),
                    style: const TextStyle(color: AppColors.muted)),
              ]),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(children: [
                _counter('Hadir', state.count(AttendStatus.hadir), AppColors.success),
                _counter('Izin', state.count(AttendStatus.izin), AppColors.warning),
                _counter('Tidak', state.count(AttendStatus.tidak), AppColors.danger),
              ]),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  itemCount: state.students.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (_, i) {
                    final s = state.students[i];
                    return ListTile(
                      title: Text(s.name),
                      trailing: StatusChip(label: s.status.label, color: s.status.color),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _info(context, 'Ekspor tersedia setelah backend terhubung'),
              child: const Text('Export rekap'),
            ),
          ]),
        ),
      ),
    );
  }
}
