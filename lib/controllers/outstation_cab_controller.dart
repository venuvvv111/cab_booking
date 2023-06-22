import 'dart:convert';

import 'package:figgocabs/models/FetchFareModel.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OutstationCabController extends GetxController {
  var isOneWay = true.obs;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final pickupDateController = TextEditingController();
  final pickupTimeController = TextEditingController();
  final returnDateController = TextEditingController();
  LatLng? startLatLng;
  LatLng? endLatLng;
  RxDouble distance = 0.0.obs;
  RxString duration = "".obs;
  var disableButtons = false.obs;

  FetchFareModel? fareModel;
  var isLoading = false.obs;

  var box = GetStorage();

  updateTripType(){
    isOneWay.value = isOneWay.value ? false : true;
  }

  Future<void> fetchFare(String km) async {
    isLoading(true);

    Map<String, String> body = {
      "km": km,
      "triptype": isOneWay.value ? 'OW' : 'TW',
      "pickupdate": pickupDateController.text,
      "pickuptime": pickupTimeController.text,
      "returndate": returnDateController.text
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.fetchOutstationFare),
        headers: {"token": box.read(Constant.token)},
        body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      fareModel = fetchFareModelFromJson(response.body);
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
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