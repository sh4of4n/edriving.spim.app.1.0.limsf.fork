import 'dart:async';
import '../utils/local_storage.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;
  String? address;
  String? places;
  double distanceInMeters = 0;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  final localStorage = LocalStorage();

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;
      // Handle the position object
    } on PermissionDeniedException {
      // Handle the permission denied error
      checkLocationPermission();
    } 
  }

  Future<LocationPermission> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    return permission;
  }

  Future<void> getAddress(double? lat, double? long) async {
    // final coordinates = Coordinates();
    // GeoCode geoCode = GeoCode();

    //  Coordinates.fromJson(Map<String, dynamic> coordinates) => Coordinates(
    //   latitude: double.tryParse(tryParse(coordinates['latt']) ?? ''),
    //   longitude: double.tryParse(tryParse(coordinates['longt']) ?? ''));

    // var address =
    //     await geoCode.forwardGeocoding(address: "Latitude:${coordinates.latitude}, Longitude:${coordinates.longitude}");
    // var first = address.first;

    // address = first.addressLine;
    // places = first.adminArea;
  }

  Future<double> getDistance(
      {required double locLatitude, double? locLongitude}) async {
    double? savedLatitude =
        double.tryParse((await localStorage.getUserLatitude())!);
    double? savedLongitude =
        double.tryParse((await localStorage.getUserLongitude())!);

    double distance;

    if (locLatitude > -90 &&
        locLatitude < 90 &&
        locLongitude! > -180 &&
        locLongitude < 180) {
      distanceInMeters = Geolocator.distanceBetween(
          savedLatitude!, savedLongitude!, locLatitude, locLongitude);

      distance = distanceInMeters;

      return distance;
    }
    return 100000000.0;
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
