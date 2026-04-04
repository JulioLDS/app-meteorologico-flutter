import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Brasil',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherTestScreen(),
    );
  }
}

class WeatherTestScreen extends StatefulWidget {
  const WeatherTestScreen({super.key});

  @override
  State<WeatherTestScreen> createState() => _WeatherTestScreenState();
}

class _WeatherTestScreenState extends State<WeatherTestScreen> {
  WeatherData? weather;
  String status = 'Clique para buscar...';

  Future<void> buscarClima() async {
    setState(() { status = 'Buscando...'; });
    
    try {
      final service = WeatherService();
      // Se quiser testar outra cidade, passe o parâmetro:
      // final data = await service.fetchWeather(city: 'São Paulo');
      final data = await service.fetchWeather();
      
      setState(() {
        weather = data;
        status = 'Dados carregados!';
      });
      
      // Logs no terminal com os NOVOS nomes de campo
      print('✅ Cidade: ${data.cityName}');
      print('✅ Temperatura: ${data.temperature} °C');
      print('✅ Umidade: ${data.humidity}%');
      print('✅ Condição: ${data.description}');
      if (data.forecast != null && data.forecast!.isNotEmpty) {
        print('📅 Previsão amanhã: ${data.forecast![0].description}');
      }
      
    } catch (e) {
      setState(() { status = 'Erro: $e'; });
      print('❌ Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste API HG Weather')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: buscarClima,
              child: const Text('Buscar Clima'),
            ),
            if (weather != null) ...[
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        weather!.cityName ?? 'Local desconhecido',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${weather!.temperature?.toStringAsFixed(1)} °C',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                      ),
                      Text(weather!.description ?? ''),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text('${weather!.humidity}% umidade'),
                          const SizedBox(width: 20),
                          Icon(Icons.air, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text('${weather!.windSpeed}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}