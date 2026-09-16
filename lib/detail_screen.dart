import 'package:flutter/material.dart';
import 'main.dart';
import 'weather_model.dart';
import 'weather_style.dart';

class DetailScreen extends StatelessWidget {
  final WeatherModel weather;
  const DetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final style = WeatherStyle.fromCondition(weather.condition);

    return Scaffold(
      appBar: AppBar(title: Text(weather.city)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(style.icon, size: 48, color: style.color),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      weather.condition,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: style.color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 20),

            _infoRow(context, 'Humidity', '${weather.humidity}%'),
            _infoRow(context, 'Wind Speed', '${weather.windSpeed} m/s'),
            _infoRow(context, 'Feels Like', '${weather.feelsLike.toStringAsFixed(1)}°C'),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            Text('Forecast', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Multi-day forecast is a future addition — this app currently shows live current-weather data.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.favorite_border),
                label: const Text('Add to Favourites'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}