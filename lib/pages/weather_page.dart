import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sunnee/models/weather_model.dart';
import 'package:sunnee/services/weather_service.dart';

const Color backgroundColor = Color(0xFF121212); // Very dark grey

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('6630c8548801b96a1d78a9bee2e1aa3e');
  Weather? _weather;

  Future<void> _fetchWeather() async {
    print("Getting current weather");
    setState(() {
      _weather = null;
    });
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'sunny';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'cloud';
      case 'rain':
      case 'drizze':
      case 'shower rain':
        return 'rain';
      case 'thunderstorm':
        return 'thunder';
      case 'clear':
        return 'sunny';
      default:
        return 'sunny';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200), // optional padding
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weather?.cityName ?? "...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Lottie.asset(
                            'assets/animations/${getWeatherAnimation(_weather?.mainCondition)}.json',
                          ),
                          Text(
                            "${_weather?.temperature.round() ?? '...'}°C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _weather?.mainCondition ?? "...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(), // pushes content to center vertically
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
