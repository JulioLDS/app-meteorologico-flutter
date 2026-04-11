import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icons.dart';
import '../utils/share_service.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final gradient = WeatherIcons.getBackgroundGradient(weather.description);
    final icon = WeatherIcons.getIcon(weather.description);
    final animation = WeatherIcons.getWeatherAnimation(weather.description);

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
            colors: gradient,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animation != null) ...[
              animation,
              const SizedBox(height: 8),
            ] else
              Icon(
                icon,
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
                _buildShareButton(
                  icon: Icons.share,
                  color: Colors.green,
                  label: 'WhatsApp',
                  onPressed: () => _shareWeather(context, 'whatsapp'),
                ),
                const SizedBox(width: 12),
                _buildShareButton(
                  icon: Icons.chat_bubble,
                  color: Colors.blue,
                  label: 'Twitter',
                  onPressed: () => _shareWeather(context, 'twitter'),
                ),
                const SizedBox(width: 12),
                _buildShareButton(
                  icon: Icons.more_horiz,
                  color: Colors.grey,
                  label: 'Mais',
                  onPressed: () => _shareWeather(context, 'native'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _buildShareButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
    );
  }

  void _shareWeather(BuildContext context, String platform) async {
    try {
      switch (platform) {
        case 'whatsapp':
          await ShareService.shareWhatsApp(weather);
          break;
        case 'twitter':
          await ShareService.shareTwitter(weather);
          break;
        case 'native':
          await ShareService.shareNative(weather);
          break;
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Compartilhado com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao compartilhar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}