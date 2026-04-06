import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HistoryChart extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    // Ordenar por data (do mais antigo para o mais recente)
    final sortedHistory = List<Map<String, dynamic>>.from(history);
    sortedHistory.sort((a, b) {
      final dateA = DateTime.tryParse(a['recorded_at'] ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b['recorded_at'] ?? '') ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    final spots = <FlSpot>[];
    final dates = <String>[];

    for (int i = 0; i < sortedHistory.length; i++) {
      final temp = (sortedHistory[i]['temperature'] as num?)?.toDouble();
      final dateStr = sortedHistory[i]['recorded_at'] ?? '';
      
      if (temp != null) {
        spots.add(FlSpot(i.toDouble(), temp));
        
        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          dates.add(DateFormat('dd/MM HH:mm').format(date));
        } else {
          dates.add('');
        }
      }
    }

    double? minY;
    double? maxY;
    
    if (spots.isNotEmpty) {
      final temps = spots.map((e) => e.y).toList();
      minY = temps.reduce((a, b) => a < b ? a : b).toDouble() - 2;
      maxY = temps.reduce((a, b) => a > b ? a : b).toDouble() + 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Histórico de Temperatura',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < dates.length) {
                          if (index == 0 || index == dates.length - 1 || index % 2 == 0) {
                            return Text(
                              dates[index],
                              style: const TextStyle(fontSize: 8),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: sortedHistory.length > 1 ? (sortedHistory.length - 1).toDouble() : 1,
                minY: minY,  
                maxY: maxY,  
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.orange.shade600,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}