import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getWeatherIcon(weather.description),
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            
            Text(
              weather.cityName ?? 'Local desconhecido',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              '${weather.temperature?.toStringAsFixed(1) ?? '--'} °C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w300,
              ),
            ),
            
            Text(
              weather.description ?? '',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDetailItem(Icons.water_drop, '${weather.humidity ?? '--'}%'),
                const SizedBox(width: 32),
                _buildDetailItem(Icons.air, weather.windSpeed ?? '--'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String? description) {
    if (description == null) return Icons.cloud;
    final desc = description.toLowerCase();
    if (desc.contains('sol') || desc.contains('claro')) return Icons.wb_sunny;
    if (desc.contains('chuva') || desc.contains('nublado')) return Icons.cloud;
    if (desc.contains('tempestade')) return Icons.thunderstorm;
    return Icons.cloud;
  }

  Widget _buildDetailItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}