import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/weather_model.dart';
import '../theme/app_colors.dart';

class ForecastCard extends StatelessWidget {
  final List<Forecast> forecasts;
  final bool isDarkMode;

  const ForecastCard({
    super.key,
    required this.forecasts,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppColors.darkGlass : AppColors.lightGlass),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDarkMode ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Previsão 5 Dias',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...forecasts.map((forecast) => _ForecastItem(
                      forecast: forecast,
                      isDarkMode: isDarkMode,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final Forecast forecast;
  final bool isDarkMode;

  const _ForecastItem({
    required this.forecast,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: (isDarkMode ? AppColors.darkGlass : AppColors.lightGlass),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              forecast.weekday ?? '',
              style: TextStyle(
                color: isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDarkMode ? AppColors.darkGlass : AppColors.lightGlass),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.cloud_outlined,
              color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
              size: 20,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '${forecast.min}°',
                style: TextStyle(
                  color: (isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentSecondary, AppColors.accentWarning],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${forecast.max}°',
                style: TextStyle(
                  color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}