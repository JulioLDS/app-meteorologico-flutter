import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherService {
  // 🔑 COLOQUE SUA CHAVE DA OPENWEATHERMAP AQUI
  static const String apiKey = '96a013c01f5627f982ef4adc1ac842a4';
  
  // Endpoint com CORS nativo ✅
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<WeatherData> fetchWeather({String? city}) async {
    try {
      final cityName = city ?? 'São Paulo';
      
      // Monta a URL com parâmetros
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric', // Retorna temperatura em °C
          'lang': 'pt_br',   // Descrições em português
        },
      );

      print('🌐 OpenWeatherMap URL: $uri');

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📦 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        // Mapeia a resposta da OpenWeatherMap para nosso modelo
        return WeatherData(
          cityName: json['name'],
          country: json['sys']['country'],
          description: json['weather'][0]['description'],
          temperature: (json['main']['temp'] as num).toDouble(),
          humidity: json['main']['humidity'] as int,
          windSpeed: (json['wind']['speed'] as num).toDouble(),
          date: DateTime.now().toIso8601String().split('T').first,
          // Gera forecast mockado baseado na temperatura atual (a API free não retorna forecast detalhado por cidade)
          forecast: _generateMockForecast(
            currentTemp: (json['main']['temp'] as num).toDouble(),
            description: json['weather'][0]['description'],
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception('OpenWeatherMap error: ${error['message']}');
      }
    } catch (e) {
      print('❌ Erro no serviço: $e');
      rethrow;
    }
  }

  // Gera previsão mockada para os próximos 4 dias (baseado na temperatura atual)
  List<Forecast> _generateMockForecast({
    required double currentTemp,
    required String description,
  }) {
    final weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final today = DateTime.now().weekday;
    final forecasts = <Forecast>[];
    
    for (int i = 1; i <= 4; i++) {
      final dayIndex = (today + i - 1) % 7;
      // Varia temperatura aleatoriamente em ±3°C
      final variation = (i % 2 == 0 ? 1 : -1) * (1 + (i % 3));
      final temp = currentTemp + variation;
      
      forecasts.add(Forecast(
        date: '${DateTime.now().day + i}/04',
        weekday: weekdays[dayIndex],
        min: (temp - 2).round(),
        max: (temp + 2).round(),
        description: _getPortugueseDescription(description),
        rainProbability: (description.toLowerCase().contains('rain') || description.toLowerCase().contains('chuva')) ? 70 : 20,
      ));
    }
    
    return forecasts;
  }

  // Traduz descrição para português (caso a API retorne em inglês)
  String _getPortugueseDescription(String enDescription) {
    final translations = {
      'clear sky': 'Céu limpo',
      'few clouds': 'Poucas nuvens',
      'scattered clouds': 'Nuvens dispersas',
      'broken clouds': 'Nublado',
      'shower rain': 'Chuvas esparsas',
      'rain': 'Chuva',
      'thunderstorm': 'Tempestade',
      'snow': 'Neve',
      'mist': 'Neblina',
    };
    return translations[enDescription.toLowerCase()] ?? enDescription;
  }
}