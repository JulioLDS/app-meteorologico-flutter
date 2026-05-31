import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final bool isDarkMode;

  const HistoryList({
    super.key,
    required this.history,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length > 10 ? 10 : history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = history[index];
          final date = DateTime.tryParse(item['recorded_at'] ?? '');
          final temp = (item['temperature'] as num?)?.toDouble() ?? 0;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkGlass : AppColors.lightGlass,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.thermostat_outlined,
                  color: AppColors.accentSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${temp.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['city'] ?? 'Local',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  date != null ? DateFormat('dd/MM HH:mm').format(date) : '',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}