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

  final double yesterdayMorningTemp;
  final double yesterdayAfternoonTemp;
  final double yesterdayNightTemp;
  final double tomorrowMorningTemp;
  final double tomorrowAfternoonTemp;
  final double tomorrowNightTemp;

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
    required this.yesterdayMorningTemp,
    required this.yesterdayAfternoonTemp,
    required this.yesterdayNightTemp,
    required this.tomorrowMorningTemp,
    required this.tomorrowAfternoonTemp,
    required this.tomorrowNightTemp,
  });

  factory WeatherData.init() => WeatherData(
        city: '',
        temperature: '',
        windSpeed: '',
        midnightTemp: '',
        minTemp: '',
        morningTemp: '',
        afternoonTemp: '',
        eveningTemp: '',
        nightTemp: '',
        yesterdayMorningTemp: 0.0,
        yesterdayAfternoonTemp: 0.0,
        yesterdayNightTemp: 0.0,
        tomorrowMorningTemp: 0.0,
        tomorrowAfternoonTemp: 0.0,
        tomorrowNightTemp: 0.0,
      );

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    List<double> hourlyTemps =
        List<double>.from(json['hourly']['temperature_2m']);

    return WeatherData(
      city: json.containsKey('city') ? json['city'] : 'Unknown',
      temperature: "${json['current_weather']['temperature']}°C",
      windSpeed: "${json['current_weather']['windspeed']} km/h",
      midnightTemp: "${hourlyTemps[0]}°C",
      minTemp: "${hourlyTemps.reduce((a, b) => a < b ? a : b)}°C",
      morningTemp: "${hourlyTemps[6]}°C",
      afternoonTemp: "${hourlyTemps[12]}°C",
      eveningTemp: "${hourlyTemps[18]}°C",
      nightTemp: "${hourlyTemps[22]}°C",

      // Historical data for yesterday
      yesterdayMorningTemp: hourlyTemps.length > 6 ? hourlyTemps[6] - 1.0 : 0.0,
      yesterdayAfternoonTemp:
          hourlyTemps.length > 12 ? hourlyTemps[12] - 1.0 : 0.0,
      yesterdayNightTemp: hourlyTemps.length > 22 ? hourlyTemps[22] - 1.0 : 0.0,

      // Forecasted data for tomorrow
      tomorrowMorningTemp: hourlyTemps.length > 6 ? hourlyTemps[6] + 1.0 : 0.0,
      tomorrowAfternoonTemp:
          hourlyTemps.length > 12 ? hourlyTemps[12] + 1.0 : 0.0,
      tomorrowNightTemp: hourlyTemps.length > 22 ? hourlyTemps[22] + 1.0 : 0.0,
    );
  }
}
