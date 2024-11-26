import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherServices _weatherService;
  Weather? _weather;
  String? _cityName;

  @override
  void initState() {
    super.initState();

    // Initialize WeatherServices with the API key from .env
    _weatherService = WeatherServices(dotenv.env['API_KEY']!);
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      Position position = await _determinePosition();
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weather = weather;
        _cityName = weather.cityName;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch weather: $e')),
      );
    }
  }

  Widget _getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Lottie.asset('assets/images/sunny.json', width: 400, height: 400);
      case 'clouds':
        return Lottie.asset('assets/images/cloudy.json', width: 300, height: 300);
      case 'rain':
        return Lottie.asset('assets/images/rainy.json', width: 150, height: 150);
      case 'thunderstorm':
        return Lottie.asset('assets/images/thunder.json', width: 150, height: 150);
      default:
        return const Text(
          'Weather animation not available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 92, 114, 112), // Teal Blue
              Color.fromARGB(255, 38, 39, 39), // Deep Sky Blue
            ],
          ),
        ),
        child: Center(
          child: _weather == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _cityName ?? 'Unknown City',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _getWeatherAnimation(_weather!.mainCondition),
                    const SizedBox(height: 16),
                    Text(
                      '${_weather!.temperature}°C',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
