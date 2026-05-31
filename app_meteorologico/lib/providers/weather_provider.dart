import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/supabase_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();
  
  static const String _cityKey = 'last_searched_city';
  SharedPreferences? _prefs;

  WeatherData? _weather;
  String? _currentCity;
  bool _isLoading = false;
  String? _error;

  WeatherData? get weather => _weather;
  String? get currentCity => _currentCity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> _history = [];
  bool _isLoadingHistory = false;
  
  List<Map<String, dynamic>> get history => _history;
  bool get isLoadingHistory => _isLoadingHistory;

  Future<void> initPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> loadSavedCity() async {
    await initPreferences();
    final savedCity = _prefs?.getString(_cityKey);
    if (savedCity != null && savedCity.isNotEmpty) {
      await fetchWeather(city: savedCity);
    }
  }

    Future<void> fetchWeather({String? city}) async {
    _setLoading(true);
    _clearError();
    _history = []; // ✅ Limpa histórico imediatamente ao buscar nova cidade
    notifyListeners();

    try {
      final data = await _service.fetchWeather(city: city);
      _weather = data;
      _currentCity = city ?? data.cityName;

      await SupabaseService.saveWeatherData(
        city: _currentCity!,
        temperature: data.temperature,
        humidity: data.humidity?.toDouble(),
      );

      await _saveCityPreference(_currentCity!);

      // ✅ Carrega histórico da NOVA cidade automaticamente
      await loadHistory();

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveCityPreference(String city) async {
    await initPreferences();
    await _prefs?.setString(_cityKey, city);
  }

    Future<void> loadHistory({String? city}) async {
    final cityToLoad = city ?? _currentCity;
    if (cityToLoad == null) return;
    
    _isLoadingHistory = true;
    notifyListeners();
    
    try {
      _history = await SupabaseService.getWeatherHistory(city: cityToLoad);
    } catch (e) {
      print('Erro ao carregar histórico: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
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

   void clearHistory() {
    _history = [];
    notifyListeners();
  }
}