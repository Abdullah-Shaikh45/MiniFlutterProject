class Weather {
  final String mainCondition;
  final double temperature;
  final String cityName;

  Weather({
    required this.mainCondition,
    required this.temperature,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      mainCondition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      cityName: json['name'],
    );
  }
}
