# Weather App 🌤️

A clean, Flutter-based weather app that fetches live weather data from the OpenWeatherMap API. Built as a hands-on project to practice state management, API integration, and error handling in Flutter.

## Features

- 🔍 Search current weather for any city
- 🌡️ Displays temperature, condition, humidity, wind speed, and "feels like" temperature
- ⭐ Save cities to Favourites and revisit them with one tap
- 🎨 Custom UI — condition-aware accent colors and icons (Clear, Rain, Clouds, Snow, Thunderstorm)
- ⚡ Full state handling: loading, error, empty, and success states
- 🛡️ Robust error handling — specific messages for no internet, timeouts, invalid city names, and server errors

## Tech Stack

- **Flutter** (Dart)
- **Provider** — state management
- **http** — API requests
- **OpenWeatherMap API** — live weather data

## Architecture

- `WeatherModel` — data model with `fromJson()` for parsing the API response
- `WeatherProvider` — a `ChangeNotifier` that owns all app state (current weather, favourites, screen state) and exposes methods like `fetchWeather()`, `addToFavourites()`
- `HomeScreen` — search bar + weather display, built with `Consumer<WeatherProvider>`
- `DetailScreen` — full weather details with an "Add to Favourites" action

## Getting Started

1. Clone the repo
   ```bash
   git clone <your-repo-url>
   cd weather_app
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api) and add it in `lib/weather_provider.dart`:
   ```dart
   static const String _apiKey = 'YOUR_API_KEY_HERE';
   ```
   > New API keys can take up to 2 hours to activate.

4. Run the app
   ```bash
   flutter run
   ```

## Screenshots

_Add screenshots here once available._

## What I Learned

This project was built to practice:
- Dart models and JSON serialization (`fromJson`/`toJson`)
- Async/await and exception handling (`SocketException`, `TimeoutException`, `FormatException`)
- State management with Provider (`ChangeNotifier`, `Consumer`)
- Navigation with data passing (`Navigator.push`/`pop` with results)
- Building a polished, custom UI in Flutter

## License

This project is open source and available for learning purposes.
