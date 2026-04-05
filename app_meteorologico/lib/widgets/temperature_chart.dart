import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weather_model.dart';

class TemperatureChart extends StatelessWidget {
  final List<Forecast> forecasts;

  const TemperatureChart({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    // Se não houver previsão, não mostra nada
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Variação de Temperatura (Próximos 5 dias)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < forecasts.length) {
                          return Text(
                            forecasts[index].weekday?.substring(0, 3) ?? '',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (forecasts.length - 1).toDouble(),
                // Garante que minY e maxY não sejam nulos
                minY: _getMinTemperature(),
                maxY: _getMaxTemperature(),
                lineBarsData: [
                  // ✅ Correção: Passa uma função que lida com nulls
                  _createLineData(forecasts, (f) => f.max?.toDouble(), Colors.red),
                  _createLineData(forecasts, (f) => f.min?.toDouble(), Colors.blue),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Correção: O tipo de retorno agora aceita 'double?' (nulo)
  LineChartBarData _createLineData(
    List<Forecast> forecasts,
    double? Function(Forecast) valueGetter, 
    Color color,
  ) {
    final spots = List<FlSpot>.generate(
      forecasts.length,
      (index) {
        // Se o valor for null, usamos 0.0 para evitar crash
        final val = valueGetter(forecasts[index]) ?? 0.0; 
        return FlSpot(index.toDouble(), val);
      },
    );

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  double _getMinTemperature() {
    // Filtra valores nulos antes de calcular o mínimo
    final values = forecasts.map((e) => e.min).whereType<int>();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a < b ? a : b).toDouble();
  }

  double _getMaxTemperature() {
    // Filtra valores nulos antes de calcular o máximo
    final values = forecasts.map((e) => e.max).whereType<int>();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a > b ? a : b).toDouble();
  }
}