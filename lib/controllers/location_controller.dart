// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:figgocabs/models/nearby_driver_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class LocationController extends GetxController {
  Position? currentPosition;
  RxList<Prediction> placesList = RxList<Prediction>();
  RxDouble distance = 0.0.obs;
  RxString duration = "".obs;
  double radiusOfEarth = 6371000; // meters
  final box = GetStorage();
  NearbyDriversModel? nearbyDriversModel;
  List<String> vehicle_types = [];

  var isLoading = false.obs;
  var disableButtons = false.obs;
  final location.Location currentLocation = location.Location();
  var currentLatLng = const LatLng(0.0, 0.0);
  final Rx<CameraPosition> kInitialPosition = const CameraPosition(
          target: LatLng(19.018255973653343, 72.84793849278007),
          zoom: 18.0,
          tilt: 0,
          bearing: 0)
      .obs;
  final RxMap<String, Marker> markers = RxMap<String, Marker>();

  final departureIcon = Rx<BitmapDescriptor?>(null);
  final destinationIcon = Rx<BitmapDescriptor?>(null);
  final taxiIcon = Rx<BitmapDescriptor?>(null);

  final departureLatLong = Rx<LatLng?>(null);
  final destinationLatLong = Rx<LatLng?>(null);

  final polyLines = <PolylineId, Polyline>{}.obs;
  final polylinePoints = PolylinePoints().obs;

  @override
  void onInit() {
    super.onInit();
    _getUserCurrentLocation();
  }

  Future<void> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });

    currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> placeSelectAPI(String input) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${Constant.kGoogleApiKey}'));

    var json = jsonDecode(response.body);
    if (response.statusCode == 200 && json["status"] == "OK") {
      List<dynamic> predictions = json["predictions"];
      placesList.assignAll(predictions
          .map((prediction) => Prediction.fromJson(prediction))
          .toList());
    }
  }

  Future<PlacesDetailsResponse?> displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces? places = GoogleMapsPlaces(
        apiKey: Constant.kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse? detail =
          await places.getDetailsByPlaceId(p.placeId.toString());

      return detail;
    }
    return null;
  }

  Future<LatLng> getCurrentLatLng() async {
    if (currentPosition == null) {
      await _getUserCurrentLocation();
    }

    return LatLng(currentPosition!.latitude, currentPosition!.longitude);
  }

  Future<String> getCurrentAddress() async {
    // Get the address from the current position
    final placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude);

    // Extract the address from the placemark
    final placemark = placemarks.first;
    if (kDebugMode) {
      print(
          '${placemark.name}, ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, '
          '${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.thoroughfare}');
    }
    final address = "${placemark.street}, ${placemark.locality}";

    // Return the address
    return address;
  }

  Future<void> fetchData() async {
    var token = box.read(Constant.token);
    if (currentLatLng.latitude == 0.0) {
      await fetchCurrentLatLng();
    }
    final url = Uri.parse(
        '${Constant.baseUrl}${UrlHelper.nearbyDrivers}?lat=${currentLatLng.latitude}&lng=${currentLatLng.longitude}');
    final response = await http.get(url, headers: {
      "token": token,
    });

    if (kDebugMode) {
      print(token);
      print(url);
      print(response.statusCode);
      print(response.body);
    }

    if (response.statusCode == 200) {
      nearbyDriversModel = nearbyDriversModelFromJson(response.body);
      for (var data in nearbyDriversModel!.data) {
        markers[data.id] = Marker(
          markerId: MarkerId(data.id),
          infoWindow: InfoWindow(title: data.name),
          position: LatLng(data.lat.toDouble(), data.lng.toDouble()),
          icon: taxiIcon.value!,
        );

        vehicle_types.add(data.vehicleType);
      }
      debugPrint('size is ${markers.length}');
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    update();
  }

  Future<void> fetchCurrentLatLng() async {
    await currentLocation.getLocation().then((value) {
      currentLatLng = LatLng(value.latitude!, value.longitude!);
    });
  }

  Future<dynamic> getDurationDistance(
      LatLng departureLatLong, LatLng destinationLatLong) async {
    double originLat, originLong, destLat, destLong;
    originLat = departureLatLong.latitude;
    originLong = departureLatLong.longitude;
    destLat = destinationLatLong.latitude;
    destLong = destinationLatLong.longitude;

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    http.Response restaurantToCustomerTime = await http.get(Uri.parse(
        '$url?units=metric&origins=$originLat,'
        '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'));

    var decodedResponse = jsonDecode(restaurantToCustomerTime.body);

    if (decodedResponse['status'] == 'OK' &&
        decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
      return decodedResponse;
    }
    return null;
  }

}
