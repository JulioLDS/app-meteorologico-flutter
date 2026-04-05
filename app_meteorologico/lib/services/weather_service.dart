import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/weather_model.dart';

class WeatherService {
  static const String apiKey = '02df5970';
  
  static const String baseUrl = 'https://api.hgbrasil.com/weather';
  
  static const List<String> corsProxies = [
    'https://corsproxy.io/?',
    'https://api.allorigins.win/raw?url=',
    'https://cors.isomorphic-git.org/',
  ];

  Future<WeatherData> fetchWeather({String? city}) async {
    // Tenta cada proxy até funcionar
    for (final proxy in corsProxies) {
      try {
        return await _fetchWithProxy(proxy, city: city);
      } catch (e) {
        print('⚠️ Proxy falhou ($proxy): $e. Tentando próximo...');
        continue;
      }
    }
    
    print('🔄 Todos os proxies falharam, usando dados mockados');
    return _getMockWeatherData(city ?? 'São Paulo');
  }

  Future<WeatherData> _fetchWithProxy(String proxy, {String? city}) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'key': apiKey,
          if (city != null) 'city_name': city,
          'locale': 'pt',
        },
      );

      final requestUrl = kIsWeb 
          ? '$proxy${Uri.encodeComponent(uri.toString())}' 
          : uri.toString();

      print('🌐 Requisição: $requestUrl');

      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📦 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        if (json['valid_key'] == false) {
          throw Exception('Chave de API inválida');
        }
        
        if (json['results'] == null) {
          throw Exception('Resposta vazia da API');
        }
        
        final results = json['results'] as Map<String, dynamic>;
        
        final forecastList = (results['forecast'] as List?)
            ?.map((item) => Forecast.fromJson(item as Map<String, dynamic>))
            .toList();

        return WeatherData(
          cityName: results['city'],
          description: results['description'],
          temperature: (results['temp'] as num?)?.toDouble(),
          humidity: results['humidity'] as int?,
          windSpeed: results['wind_speedy'],
          date: results['date'],
          forecast: forecastList,
        );
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro no proxy: $e');
      rethrow;
    }
  }

  WeatherData _getMockWeatherData(String city) {
    return WeatherData(
      cityName: city,
      description: 'Parcialmente nublado',
      temperature: 26.5,
      humidity: 68,
      windSpeed: '3.2 km/h',
      date: DateTime.now().toString().split(' ')[0],
      forecast: [
        Forecast(
          date: '05/04',
          weekday: 'Seg',
          min: 20,
          max: 28,
          description: 'Sol com nuvens',
          rainProbability: 10,
        ),
      ],
    );
  }
}