import 'package:flaterbatash/models/weather_model.dart';
import 'package:flaterbatash/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService('91c418fd3fb6216874bfc2d58e9b5506');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
    _weather = null; // Reset to null on error
  });
      print(e); // Log the error for debugging
    }
  }

  // weather animation
String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null) return 'assets/sunny.json';

  switch (mainCondition) {
    case "Clear":
      return "assets/sunny.json";
    case "Clouds":
      return "assets/cloudy.json";
    case "Drizzle":
      return "assets/drizzle.json";
    case "Rain":
      return "assets/rainy.json";
    case "Snow":
      return "assets/snow.json";
    case "Thunderstorm":
      return "assets/thunderstorm.json";
    case "shower rain":
      return "assets/rainy.json";
    default:
      return "assets/sunny.json";
  }
}

  // init state

  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // city name
            Text(_weather?.cityName ?? "loading city.."),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()}°C'),

            // weathr condition
            Text (_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}