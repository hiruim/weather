import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather/bloc/weather/weather_event.dart';
import 'package:weather/bloc/weather/weather_state.dart';
import 'package:weather/ui/widgets/weather_data.dart';

class WeatherMapBloc extends Bloc<WeatherMapEvent, WeatherMapState> {
  WeatherMapBloc() : super(WeatherMapInitial()) {
    on<FetchWeatherEvent>(_fetchWeather);
  }

  Future<void> _fetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherMapState> emit,
  ) async {
    try {
      emit(WeatherLoading());

      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=${event.location.latitude}'
        '&longitude=${event.location.longitude}'
        '&current_weather=true'
        '&hourly=temperature_2m,relativehumidity_2m,windspeed_10m',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromJson(data);
        emit(WeatherLoaded(weatherData));
      } else {
        emit(WeatherError(
            'Failed to fetch weather data (Status: ${response.statusCode})',
            message: ''));
      }
    } catch (e) {
      emit(WeatherError('Error fetching weather data: $e', message: ''));
    }
  }

  Future<String> fetchCityName(
      double latitude, double longitude, dynamic event) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${event.location.latitude}&lon=${event.location.longitude}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['address']['city'] ?? data['address']['town'] ?? 'Unknown';
    } else {
      return 'Unknown';
    }
  }
}
