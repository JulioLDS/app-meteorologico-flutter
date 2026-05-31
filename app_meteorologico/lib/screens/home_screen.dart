import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/history_chart.dart';
import '../widgets/history_list.dart';
import '../theme/app_colors.dart';

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
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {

        return Scaffold(
          backgroundColor: AppColors.darkBgPrimary,
          // ✅ SCROLL UNIFICADO PARA TUDO
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔍 BARRA DE PESQUISA COM CLEAR BUTTON
                    SearchBarWidget(
                      onSearch: (city) {
                        provider.clearError();
                        provider.fetchWeather(city: city); 
                      },
                      onClear: () {
                        provider.clearError();
                      },
                    ),

                    // CONTEÚDO PRINCIPAL
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(48),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    else if (provider.error != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      )
                    else if (provider.weather != null) ...[
                      if (isDesktop)
                        // 🖥️ DESKTOP: LADO A LADO COM SCROLL JUNTO
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Esquerda: Clima + Previsão
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  WeatherCard(
                                    weather: provider.weather!,
                                    isDarkMode: true,
                                  ),
                                  const SizedBox(height: 20),
                                  if (provider.weather!.forecast?.isNotEmpty == true)
                                    ForecastCard(
                                      forecasts: provider.weather!.forecast!,
                                      isDarkMode: true,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Direita: Histórico (acompanha scroll)
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.darkGlass,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(color: AppColors.darkGlassBorder),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Histórico',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (provider.history.isNotEmpty) ...[
                                      HistoryChart(
                                        history: provider.history,
                                        isDarkMode: true,
                                      ),
                                      const SizedBox(height: 16),
                                      HistoryList(
                                        history: provider.history,
                                        isDarkMode: true,
                                      ),
                                    ] else
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(32),
                                          child: Text(
                                            'Sem histórico ainda',
                                            style: TextStyle(color: Colors.white54),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // 📱 MOBILE: COLUNA
                        Column(
                          children: [
                            WeatherCard(
                              weather: provider.weather!,
                              isDarkMode: true,
                            ),
                            const SizedBox(height: 20),
                            if (provider.weather!.forecast?.isNotEmpty == true)
                              ForecastCard(
                                forecasts: provider.weather!.forecast!,
                                isDarkMode: true,
                              ),
                            const SizedBox(height: 24),
                            const Text(
                              'Histórico',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (provider.history.isNotEmpty) ...[
                              HistoryChart(
                                history: provider.history,
                                isDarkMode: true,
                              ),
                              const SizedBox(height: 16),
                              HistoryList(
                                history: provider.history,
                                isDarkMode: true,
                              ),
                            ],
                          ],
                        ),
                    ] else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_outlined, size: 80, color: Colors.white24),
                              SizedBox(height: 16),
                              Text(
                                'Busque uma cidade para começar',
                                style: TextStyle(color: Colors.white54, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}