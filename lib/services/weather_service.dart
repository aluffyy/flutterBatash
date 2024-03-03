import 'dart:convert';
import 'package:flaterbatash/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String city) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather');
    }
  }

  Future<String> getCurrentCity() async {
    
    // Get permissions from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert te location into list of placemark object
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract city name fromthe first placemark
    String? city = placemark[0].locality;
    return city ?? "";
  }
}
