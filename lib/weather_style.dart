import 'package:flutter/material.dart';

// Har weather condition ke liye ek icon aur ek accent color —
// UI ka accent color isi se decide hota hai (condition-aware design)
class WeatherStyle {
  final IconData icon;
  final Color color;

  const WeatherStyle(this.icon, this.color);

  static WeatherStyle fromCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const WeatherStyle(Icons.wb_sunny_rounded, Color(0xFFC98A3B));
      case 'clouds':
        return const WeatherStyle(Icons.cloud_rounded, Color(0xFF5B6B7A));
      case 'rain':
      case 'drizzle':
        return const WeatherStyle(Icons.water_drop_rounded, Color(0xFF2F5F8A));
      case 'thunderstorm':
        return const WeatherStyle(Icons.bolt_rounded, Color(0xFF4B4560));
      case 'snow':
        return const WeatherStyle(Icons.ac_unit_rounded, Color(0xFF5FA0C9));
      case 'mist':
      case 'haze':
      case 'fog':
        return const WeatherStyle(Icons.foggy, Color(0xFF7A8590));
      default:
        return const WeatherStyle(Icons.wb_cloudy_rounded, Color(0xFF2B5876));
    }
  }
}