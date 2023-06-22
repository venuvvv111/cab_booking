// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:figgocabs/utility/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String lat = '';
  String lng = '';

  @override
  void initState() {
    super.initState();
    LocationService.fetchUserLocation();
  }

  @override
  void dispose() {
    LocationService.locationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<UserLocation>(
        stream: LocationService.locationController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userLocation = snapshot.data!;
            return Center(
                child: Text(
                    'Latitude: ${userLocation.latitude}, Longitude: ${userLocation.longitude}'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class LocationService {
  static StreamController<UserLocation> locationController =
      StreamController<UserLocation>();

  static Future<void> fetchUserLocation() async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://figgo.in/api/user/get_driver_location.php?driver_id=62'),
          headers: {'token': GetStorage().read(Constant.token)});
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        final data = json.decode(response.body);
        final userLocation = UserLocation(
          latitude: data['data']['lat'],
          longitude: data['data']['lng'],
        );
        locationController.add(userLocation);
      } else {
        throw Exception('Failed to fetch user location');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

class UserLocation {
  final String latitude;
  final String longitude;

  UserLocation({required this.latitude, required this.longitude});
}
