import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class HistoryChart extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final bool isDarkMode;

  const HistoryChart({
    super.key,
    required this.history,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final sorted = List<Map<String, dynamic>>.from(history)
      ..sort((a, b) {
        final da = DateTime.tryParse(a['recorded_at'] ?? '') ?? DateTime.now();
        final db = DateTime.tryParse(b['recorded_at'] ?? '') ?? DateTime.now();
        return da.compareTo(db);
      });

    final spots = <FlSpot>[];
    final labels = <String>[];

    for (int i = 0; i < sorted.length; i++) {
      final temp = (sorted[i]['temperature'] as num?)?.toDouble();
      if (temp != null) {
        spots.add(FlSpot(i.toDouble(), temp));
        final date = DateTime.tryParse(sorted[i]['recorded_at'] ?? '');
        if (date != null) {
          labels.add(DateFormat('dd/MM').format(date));
        }
      }
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final temps = spots.map((e) => e.y).toList();
    final minY = temps.reduce((a, b) => a < b ? a : b).toDouble() - 2;
    final maxY = temps.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkGlass : AppColors.lightGlass,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evolução da Temperatura',
                style: TextStyle(
                  color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}°',
                            style: TextStyle(
                              color: isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (spots.length > 6) ? 2 : 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < labels.length) {
                              return Text(
                                labels[index],
                                style: TextStyle(
                                  color: isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                  fontSize: 10,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (spots.length - 1).toDouble(),
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.accentSecondary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 5,
                            color: isDarkMode ? AppColors.darkBgPrimary : AppColors.lightBgPrimary,
                            strokeWidth: 2,
                            strokeColor: AppColors.accentSecondary,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.accentSecondary.withOpacity(0.15),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) =>
                            isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(1)}°C',
                              TextStyle(
                                color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}