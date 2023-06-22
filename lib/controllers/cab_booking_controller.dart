import 'dart:convert';

import 'package:figgocabs/models/FetchFareModel.dart';

import 'package:figgocabs/models/get_accepted_driver_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class CabBookingController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  FetchFareModel? fareModel;
  GetAcceptedDriversModel? getAcceptedDriversModel;

  var currentCabDriverIndex = 0.obs;
  var showWaitingCard = false.obs;
  var showCabCard = false.obs;
  var result = false.obs;
  var pickupDate = ''.obs;
  var pickupTime = ''.obs;

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  String amountToPay = '';
  String selectedVehicle = '';
  String selectedDriverId = '';

  Future<void> fetchFare(String km) async {
    isLoading(true);

    Map<String, String> body = {
      "km": km,
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.fetchFare),
        headers: {"token": box.read(Constant.token)},
        body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      fareModel = fetchFareModelFromJson(response.body);
      update();
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

  Future<void> initiateRide(
      String pickLat,
      String pickLng,
      String dropLat,
      String dropLng,
      String distance,
      String price,
      String vehicleCategory,
      String pickAddress,
      String dropAddress,
      ) async {
    isLoading(true);

    Map<String, String> body = {
      'user_id': box.read(Constant.id),
      'pickup_lat': pickLat,
      'pickup_lng': pickLng,
      'dropoff_lat': dropLat,
      'dropoff_lng': dropLng,
      'distance': distance,
      'pickup_address': pickAddress,
      'drop_address': dropAddress,
      'price': price,
      'ride_status': '0',
      'vehicle_category': vehicleCategory,
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.rideRequest),
        headers: {"token": box.read(Constant.token)},
        body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status'] == "success") {
        showWaitingCard(true);
        Constant.currentRideId = json['ride_id'].toString();
        toast('ride created successfully');

        // todo increase time later
        Future.delayed(const Duration(seconds: 10), () {
          fetchAcceptedDrivers();
        });
      }
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

  Future<void> fetchAcceptedDrivers() async {
    isLoading(true);

    toast('Method called ${Constant.currentRideId}');
    debugPrint(
        'url is ${Constant.baseUrl}${UrlHelper.fetchAcceptedDrivers}?ride_id=19');
    var response = await http.get(
        Uri.parse(
            '${Constant.baseUrl}${UrlHelper.fetchAcceptedDrivers}?ride_id=${Constant.currentRideId}'),
        headers: {"token": box.read(Constant.token)});

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      getAcceptedDriversModel = getAcceptedDriversModelFromJson(response.body);
      showWaitingCard(false);
      showCabCard(true);
      update();
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
      showWaitingCard(false);
    }

    isLoading(false);
  }

  resetState() {
    showWaitingCard(false);
    showCabCard(false);
    result(false);
    currentCabDriverIndex(0);
  }

  updateCurrentDriverIndex() {
    if (getAcceptedDriversModel != null &&
        currentCabDriverIndex.value <
            getAcceptedDriversModel!.drivers.length - 1) {
      currentCabDriverIndex++;
    }
  }
}
