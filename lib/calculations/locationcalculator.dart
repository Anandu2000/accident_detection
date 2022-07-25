import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as Math;

class LocationCalculator{
  Position position;
  String currentAddress = '';
  LocationCalculator(this.position);

  String toDegreesMinutesAndSeconds(var coordinate) {
    var absolute = coordinate.abs();
    var degrees = absolute.floor();
    var minutesNotTruncated = (absolute - degrees) * 60;
    var minutes = minutesNotTruncated.floor();
    var seconds = (minutesNotTruncated - minutes) * 60.floor();

    return "$degrees $minutes $seconds";
  }

  String convertDMS() {
    var latitude = toDegreesMinutesAndSeconds(position.latitude);
    var latitudeCardinal = position.latitude >= 0 ? "N" : "S";

    var longitude = toDegreesMinutesAndSeconds(position.longitude);
    var longitudeCardinal = position.longitude >= 0 ? "E" : "W";

    return "$latitude $latitudeCardinal \n$longitude $longitudeCardinal";
  }


}