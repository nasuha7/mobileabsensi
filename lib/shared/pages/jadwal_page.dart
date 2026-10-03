import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';
import '../data/dummy_data.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Kuliah')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: DummyData.courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final c = DummyData.courses[i];
          return AppCard(
            child: Row(children: [
              SizedBox(
                width: 64,
                child: Text(c.day,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${c.time}  •  ${c.room}',
                      style: const TextStyle(color: AppColors.muted)),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}
