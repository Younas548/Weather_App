import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

enum ScreenState { initial, loading, success, error, empty }

class WeatherProvider extends ChangeNotifier {
  // Apni API key yahan daalo
  static const String _apiKey = 'd1bf177be2afbcb58fe5f67af37a66ac';

  WeatherModel? _currentWeather;
  WeatherModel? get currentWeather => _currentWeather;

  ScreenState _state = ScreenState.initial;
  ScreenState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final List<WeatherModel> _favourites = [];
  List<WeatherModel> get favourites => _favourites;

  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      _state = ScreenState.empty;
      notifyListeners();
      return;
    }

    _state = ScreenState.loading;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentWeather = WeatherModel.fromJson(data);
        _state = ScreenState.success;
      } else if (response.statusCode == 404) {
        _state = ScreenState.error;
        _errorMessage = 'City not found. Check the spelling and try again.';
      } else if (response.statusCode == 401) {
        _state = ScreenState.error;
        _errorMessage = 'API key not active yet. New keys can take up to 2 hours.';
      } else {
        _state = ScreenState.error;
        _errorMessage = 'Server error (${response.statusCode}). Please try again.';
      }
    } on SocketException {
      _state = ScreenState.error;
      _errorMessage = 'No internet connection. Check your network and retry.';
    } on TimeoutException {
      _state = ScreenState.error;
      _errorMessage = 'Request timed out. Please try again.';
    } on FormatException {
      _state = ScreenState.error;
      _errorMessage = 'Received unexpected data from the server.';
    } catch (e) {
      _state = ScreenState.error;
      _errorMessage = 'Something went wrong: $e';
    }

    notifyListeners();
  }

  void addToFavourites(WeatherModel weather) {
    if (_favourites.any((w) => w.city == weather.city)) return;
    _favourites.add(weather);
    notifyListeners();
  }

  void removeFromFavourites(WeatherModel weather) {
    _favourites.remove(weather);
    notifyListeners();
  }
}