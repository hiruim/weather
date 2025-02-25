import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherMapEvent {}

class PermissionRequestEvent extends WeatherMapEvent {}

class UpdateUserLocation extends WeatherMapEvent {
  final LatLng location;
  UpdateUserLocation(this.location);
}

class FetchWeatherEvent extends WeatherMapEvent {
  final LatLng location;
  FetchWeatherEvent(this.location);
}
