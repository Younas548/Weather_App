import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_screen.dart';
import 'main.dart';
import 'weather_model.dart';
import 'weather_provider.dart';
import 'weather_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Ek hi baar banaye jaate hain, har build() pe nahi — isse GlobalKey
  // duplicate hone wala error nahi aata
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  void _searchWeather() {
    if (_formKey.currentState!.validate()) {
      context.read<WeatherProvider>().fetchWeather(_controller.text.trim());
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Weather App'))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: 'Search a city',
                          prefixIcon: Icon(Icons.search, color: AppColors.inkMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "City can't be empty";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _searchWeather(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _searchWeather,
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<WeatherProvider>(
                builder: (context, weatherProvider, child) {
                  switch (weatherProvider.state) {
                    case ScreenState.initial:
                      return const _MessageView(
                        icon: Icons.wb_cloudy_outlined,
                        message: 'Search a city to see the weather',
                      );

                    case ScreenState.loading:
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.accent),
                      );

                    case ScreenState.empty:
                      return const _MessageView(
                        icon: Icons.edit_outlined,
                        message: 'Please enter a city name',
                      );

                    case ScreenState.error:
                      return _MessageView(
                        icon: Icons.error_outline,
                        message: weatherProvider.errorMessage,
                        actionLabel: 'Retry',
                        onAction: () =>
                            weatherProvider.fetchWeather(_controller.text.trim()),
                      );

                    case ScreenState.success:
                      final currentWeather = weatherProvider.currentWeather!;
                      return _WeatherView(weather: currentWeather);
                  }
                },
              ),
            ),
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                if (weatherProvider.favourites.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 10),
                      Text('Favourites', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: weatherProvider.favourites.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final fav = weatherProvider.favourites[index];
                            return ActionChip(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.line),
                              label: Text(fav.city),
                              onPressed: () => weatherProvider.fetchWeather(fav.city),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Success state — condition-aware accent color drives the icon and temperature
class _WeatherView extends StatelessWidget {
  final WeatherModel weather;
  const _WeatherView({required this.weather});

  @override
  Widget build(BuildContext context) {
    final style = WeatherStyle.fromCondition(weather.condition);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(weather: weather)),
        );
        if (result == true) {
          context.read<WeatherProvider>().addToFavourites(weather);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Text(weather.city, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              Icon(style.icon, size: 56, color: style.color),
              const SizedBox(height: 8),
              Text(
                '${weather.temperature.toStringAsFixed(0)}°',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                weather.condition,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: style.color, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Divider(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(
                    icon: Icons.water_drop_outlined,
                    value: '${weather.humidity}%',
                    label: 'Humidity',
                  ),
                  _StatColumn(
                    icon: Icons.air,
                    value: '${weather.windSpeed} m/s',
                    label: 'Wind',
                  ),
                  _StatColumn(
                    icon: Icons.thermostat_outlined,
                    value: '${weather.feelsLike.toStringAsFixed(0)}°',
                    label: 'Feels like',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Tap for details',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatColumn({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.inkMuted),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            )),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageView({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.inkMuted),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}