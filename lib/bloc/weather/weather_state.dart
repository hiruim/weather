import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:weather/ui/widgets/weather_data.dart';

@immutable
abstract class WeatherMapState {}

class WeatherMapInitial extends WeatherMapState {}

class WeatherLoading extends WeatherMapState {}

class WeatherLoaded extends WeatherMapState {
  final WeatherData weatherData;

  WeatherLoaded(this.weatherData);
}

class WeatherError extends WeatherMapState {
  final String message;
  WeatherError(String s, {required this.message});
}

class WeatherMapPermissionLoadingState extends WeatherMapState {}

class WeatherMapPermissionSuccessState extends WeatherMapState {
  final LatLng? currentLocation;

  WeatherMapPermissionSuccessState({this.currentLocation});
}

class WeatherMapPermissionNotGivenState extends WeatherMapState {
  final String error;

  WeatherMapPermissionNotGivenState({required this.error});
}

class LocationPermissionGranted extends WeatherMapState {}

class LocationPermissionDenied extends WeatherMapState {
  final String error;

  LocationPermissionDenied({required this.error});
}

class UserLocationUpdated extends WeatherMapState {
  final LatLng location;
  UserLocationUpdated(this.location);
}
