import 'dart:async';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final box = GetStorage();
  final StreamController<Position> _locationController =
      StreamController<Position>.broadcast();
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Position? _previousPosition;

  Stream<Position> get locationStream => _locationController.stream;

  Future<void> startListening() async {
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {
      _locationController.add(position);
      var distanceInMeters = -1.0;
      if (_previousPosition != null) {
        distanceInMeters = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );
      }
      if (_previousPosition == null || distanceInMeters > 10) {
        updateLocation(
            position.latitude.toString(), position.longitude.toString());
        _previousPosition = position;
      }
    });
  }

  void stopListening() {
    _locationController.close();
  }

  updateLocation(String lat, String lng) async {
    Map<String, String> bodyData = {
      "id": box.read(Constant.id),
      "lat": lat,
      "lng": lng
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.locationUpdate),
        body: bodyData,
        headers: {"token": box.read(Constant.token)});

    if (kDebugMode) {
      print('response is ${response.statusCode} && ${response.body}');
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Location updated successfully');
      }
    } else {
      if (kDebugMode) {
        print('Error in updating location');
      }
    }
  }
}
