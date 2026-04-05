// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      cityName: json['cityName'] as String?,
      description: json['description'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toInt(),
      windSpeed: json['windSpeed'] as String?,
      date: json['date'] as String?,
      forecast: (json['forecast'] as List<dynamic>?)
          ?.map((e) => Forecast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'description': instance.description,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'date': instance.date,
      'forecast': instance.forecast,
    };

Forecast _$ForecastFromJson(Map<String, dynamic> json) => Forecast(
      date: json['date'] as String?,
      weekday: json['weekday'] as String?,
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
      description: json['description'] as String?,
      rainProbability: (json['rainProbability'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
      'date': instance.date,
      'weekday': instance.weekday,
      'min': instance.min,
      'max': instance.max,
      'description': instance.description,
      'rainProbability': instance.rainProbability,
    };
