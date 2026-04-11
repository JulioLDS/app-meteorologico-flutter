import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherData {
  final String? cityName;           
  final String? country;            
  final String? description;        
  final double? temperature;        
  final int? humidity;              
  final double? windSpeed;          
  final String? date;               
  final List<Forecast>? forecast;   

  WeatherData({
    this.cityName,
    this.country,
    this.description,
    this.temperature,
    this.humidity,
    this.windSpeed,
    this.date,
    this.forecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

@JsonSerializable()
class Forecast {
  final String? date;
  final String? weekday;
  final int? min;
  final int? max;
  final String? description;
  final int? rainProbability;

  Forecast({
    this.date,
    this.weekday,
    this.min,
    this.max,
    this.description,
    this.rainProbability,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastToJson(this);
}