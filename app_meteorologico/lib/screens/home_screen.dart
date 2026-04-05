import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/history_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WeatherProvider>().loadSavedCity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(provider.currentCity ?? '🌤️ Clima Brasil'),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.cloud), text: 'Clima'),
                  Tab(icon: Icon(Icons.history), text: 'Histórico'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => provider.fetchWeather(city: provider.currentCity),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                _buildWeatherTab(provider),
                
                _buildHistoryTab(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherTab(WeatherProvider provider) {
    return Column(
      children: [
        SearchBarWidget(
          onSearch: (city) {
            provider.clearError();
            provider.clearHistory(); 
            provider.fetchWeather(city: city);
          },
          onClear: provider.clearError,
        ),

        if (provider.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildErrorBanner(provider.error!),
          ),

        Expanded(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.weather != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          WeatherCard(weather: provider.weather!),
                          
                          if (provider.weather!.forecast?.isNotEmpty == true) ...[
                            const SizedBox(height: 24),
                            TemperatureChart(forecasts: provider.weather!.forecast!),
                            const SizedBox(height: 24),
                          ],
                          
                          if (provider.weather!.forecast?.isNotEmpty == true) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Previsão estendida',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ForecastList(forecasts: provider.weather!.forecast!),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_outlined, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Digite uma cidade para começar',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  // 👇 Construtor da aba de Histórico
  Widget _buildHistoryTab(WeatherProvider provider) {
    if (provider.history.isEmpty && 
        !provider.isLoadingHistory && 
        provider.currentCity != null) {
      Future.microtask(() => provider.loadHistory());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton.icon(
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Atualizar histórico'),
            onPressed: () => provider.loadHistory(),
          ),
        ),
        Expanded(
          child: provider.isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : HistoryList(history: provider.history),
        ),
      ],
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