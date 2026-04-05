import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();
  
  WeatherData? _weather;
  String? _currentCity;
  bool _isLoading = false;
  String? _error;

  WeatherData? get weather => _weather;
  String? get currentCity => _currentCity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather({String? city}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final data = await _service.fetchWeather(city: city);
      
      _weather = data;
      _currentCity = city ?? data.cityName;
      
      notifyListeners();
      
    } catch (e) {
      _setError(e.toString());
      notifyListeners();
      rethrow; 
    } finally {
      _setLoading(false);
    }
  }

  void clearError() => _clearError();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}