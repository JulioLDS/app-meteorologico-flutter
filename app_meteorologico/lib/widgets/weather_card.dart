import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/weather_model.dart';
import '../utils/weather_icons.dart';
import '../utils/share_service.dart';
import '../theme/app_colors.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  final bool isDarkMode;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getDynamicGradient();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header: Cidade + Data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      weather.cityName ?? 'Local',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'HOJE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Temperatura + Condição + Animação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weather.temperature?.toStringAsFixed(0) ?? '--'}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.w200,
                            height: 1,
                            letterSpacing: -3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.description?.toUpperCase() ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    WeatherIcons.getWeatherAnimation(weather.description, size: 90),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Stats Grid
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(Icons.water_drop_outlined, '${weather.humidity ?? '--'}%', 'Umidade'),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                      _buildStatColumn(Icons.air_outlined, weather.windSpeed != null ? '${weather.windSpeed!.toStringAsFixed(1)}' : '--', 'm/s'),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                      _buildStatColumn(Icons.visibility_outlined, '--', 'Visibilidade'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ✅ BOTÕES DE SHARE APENAS COM ÍCONES (SEM LABEL)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShareButtonAsset(
                      assetPath: 'assets/icons/share.png',
                      onTap: () => _share('native'),
                    ),
                    const SizedBox(width: 16),
                    _buildShareButtonAsset(
                      assetPath: 'assets/icons/whatsapp.png',
                      onTap: () => _share('whatsapp'),
                    ),
                    const SizedBox(width: 16),
                    _buildShareButtonAsset(
                      assetPath: 'assets/icons/twitter.png',
                      onTap: () => _share('twitter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== MÉTODOS AUXILIARES ==========
  
  List<Color> _getDynamicGradient() {
    final desc = weather.description?.toLowerCase() ?? '';
    if (desc.contains('sol') || desc.contains('clear') || desc.contains('sunny')) {
      return AppColors.gradientSunny;
    } else if (desc.contains('chuva') || desc.contains('rain')) {
      return AppColors.gradientRainy;
    } else if (desc.contains('nuvem') || desc.contains('cloud')) {
      return AppColors.gradientCloudy;
    }
    return AppColors.gradientNight;
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
      ],
    );
  }

  // ✅ Botão de share com ícone grande, centralizado e sem texto
  Widget _buildShareButtonAsset({
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.share_rounded, color: Colors.white70, size: 32);
            },
          ),
        ),
      ),
    );
  }

  void _share(String platform) async {
    try {
      switch (platform) {
        case 'whatsapp': await ShareService.shareWhatsApp(weather); break;
        case 'twitter': await ShareService.shareTwitter(weather); break;
        case 'native': await ShareService.shareNative(weather); break;
      }
    } catch (e) {
      print('Erro ao compartilhar: $e');
    }
  }
}