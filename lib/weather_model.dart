class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'],
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}