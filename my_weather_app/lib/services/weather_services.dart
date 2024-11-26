import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/models/weather_model.dart';

class WeatherServices {
  final String apiKey;

  WeatherServices(this.apiKey);

  // Fetch weather data based on city name
  Future<Weather> getWeather(String cityName) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch weather data based on latitude and longitude
  Future<Weather> getWeatherByCoordinates(double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
