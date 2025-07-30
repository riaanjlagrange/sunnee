import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Future<String> getCurrentCity() async {
    print("Getting current city");

    // get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
