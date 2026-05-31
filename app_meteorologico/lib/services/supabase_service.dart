import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://fjzpnzobyiljbamarhgo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqenBuem9ieWlsamJhbWFyaGdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0MDM1NzYsImV4cCI6MjA5MDk3OTU3Nn0.9UKXCtvL5Y5w5Y-nllGjj2CKt1oX0mnwsr4tBxk7w98';

  static late SupabaseClient client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    client = Supabase.instance.client;
    print('🗄️ Supabase conectado com sucesso!');
  }

  static Future<void> saveWeatherData({
    required String city,
    double? temperature,
    double? humidity,
  }) async {
    try {
      await client.from('weather_logs').insert({
        'city': city,
        'temperature': temperature,
        'humidity': humidity,
        'recorded_at': DateTime.now().toIso8601String(),
      });
      print('💾 Dados salvos no Supabase para $city');
    } catch (e) {
      print('❌ Erro ao salvar no Supabase: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getWeatherHistory({
    required String city,
    int limit = 10,
  }) async {
    try {
      final response = await client
          .from('weather_logs')
          .select()
          .eq('city', city)
          .order('recorded_at', ascending: false)
          .limit(limit);

      print('📜 Histórico recuperado: ${response.length} registros');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Erro ao buscar histórico: $e');
      return [];
    }
  }
}