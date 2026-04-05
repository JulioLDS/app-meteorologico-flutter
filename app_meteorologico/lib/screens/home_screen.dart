import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🌤️ Clima Brasil'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => provider.fetchWeather(city: provider.currentCity),
              ),
            ],
          ),
          body: Column(
            children: [
              SearchBarWidget(
                onSearch: (city) {
                  provider.clearError();
                  provider.fetchWeather(city: city);
                },
                onClear: provider.clearError,
              ),

              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildErrorBanner(provider.error!),
                ),

              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.weather != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WeatherCard(weather: provider.weather!),
                        if (provider.weather!.forecast?.isNotEmpty == true) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Previsão dos próximos dias',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ForecastList(forecasts: provider.weather!.forecast!),
                        ],
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_outlined, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Digite uma cidade para ver o clima',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}