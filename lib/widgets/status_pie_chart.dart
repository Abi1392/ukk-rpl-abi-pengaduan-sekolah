import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatusPieChart extends StatelessWidget {
  final int menunggu;
  final int proses;
  final int selesai;

  const StatusPieChart({
    super.key,
    required this.menunggu,
    required this.proses,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    final total = menunggu + proses + selesai;

    if (total == 0) {
      return const SizedBox(
        height: 180,
        child: Center(
            child: Text('Belum ada data untuk ditampilkan',
                style: TextStyle(color: Colors.grey))),
      );
    }

    return Row(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                if (menunggu > 0)
                  PieChartSectionData(
                    value: menunggu.toDouble(),
                    color: const Color(0xFFC62828),
                    title: '$menunggu',
                    radius: 55,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                if (proses > 0)
                  PieChartSectionData(
                    value: proses.toDouble(),
                    color: const Color(0xFFEF6C00),
                    title: '$proses',
                    radius: 55,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                if (selesai > 0)
                  PieChartSectionData(
                    value: selesai.toDouble(),
                    color: const Color(0xFF2E7D32),
                    title: '$selesai',
                    radius: 55,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendItem('Menunggu', menunggu, const Color(0xFFC62828), total),
              const SizedBox(height: 10),
              _legendItem('Proses', proses, const Color(0xFFEF6C00), total),
              const SizedBox(height: 10),
              _legendItem('Selesai', selesai, const Color(0xFF2E7D32), total),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem(String label, int value, Color color, int total) {
    final persen = total == 0 ? 0 : (value / total * 100).round();
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label: $value ($persen%)', style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
