class WeatherData {
  final String city;
  final String temperature;
  final String windSpeed;
  final String midnightTemp;
  final String minTemp;
  final String morningTemp;
  final String afternoonTemp;
  final String eveningTemp;
  final String nightTemp;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.midnightTemp,
    required this.minTemp,
    required this.morningTemp,
    required this.afternoonTemp,
    required this.eveningTemp,
    required this.nightTemp,
  });

  static final WeatherData parisWeather = WeatherData(
    city: "Paris",
    temperature: "-7.7°C",
    windSpeed: "3.8 km/h (Feels colder)",
    midnightTemp: "-6.4°C",
    minTemp: "-8.6°C",
    morningTemp: "-8.2°C",
    afternoonTemp: "-1.3°C",
    eveningTemp: "-2.7°C",
    nightTemp: "-5.5°C",
  );
}
