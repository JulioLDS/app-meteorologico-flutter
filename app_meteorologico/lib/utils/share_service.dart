import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/weather_model.dart';

class ShareService {
  static Future<void> shareWhatsApp(WeatherData weather) async {
    final message = _buildShareMessage(weather);
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/?text=$encodedMessage';
    
    await _launchUrl(url);
  }

  static Future<void> shareTwitter(WeatherData weather) async {
    final message = _buildShareMessage(weather);
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://twitter.com/intent/tweet?text=$encodedMessage';
    
    await _launchUrl(url);
  }

  static Future<void> shareNative(WeatherData weather) async {
    final message = _buildShareMessage(weather);
    await Share.share(message);
  }

  static String _buildShareMessage(WeatherData weather) {
    final temp = weather.temperature?.toStringAsFixed(1) ?? '--';
    final humidity = weather.humidity ?? '--';
    final city = weather.cityName ?? 'Local desconhecido';
    final condition = weather.description ?? '';
    
    return '''🌤️ *Clima em $city*

🌡️ Temperatura: $temp°C
💧 Umidade: $humidity%
☁️ Condição: $condition

Dados atualizados em ${DateTime.now().toString().substring(0, 16)}

📱 App Meteorológico Flutter''';
  }

  static Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir: $urlString';
    }
  }
}