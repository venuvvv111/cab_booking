// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:figgocabs/models/booking_detail_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ride_history_model.dart';

class RideHistoryController extends GetxController {
  final box = GetStorage();
  RideHistoryModel? rideHistoryModel;
  BookingDetailModel? bookingDetailModel;
  var data = 0.obs;
  var isFetching = false.obs;
  var isLoading = false.obs;

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  Future<void> fetchData() async {
    isFetching(true);
    final url = Uri.parse(
        '${Constant.baseUrl}${UrlHelper.rideHistory}?id=${box.read(Constant.id)}');
    final response =
        await http.get(url, headers: {"token": box.read(Constant.token)});
    print('${box.read(Constant.id)}');

    debugPrint(response.body);
    debugPrint('${box.read(Constant.token)}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status'] == "Success") {
        rideHistoryModel = rideHistoryModelFromJson(response.body);
        data(rideHistoryModel!.data.length);
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    isFetching(false);
  }

  Future<void> fetchBookingInfo(String bookingID) async {
    isLoading(true);

    debugPrint("id is $bookingID");
    var response = await http.get(
        Uri.parse("${Constant.baseUrl}${UrlHelper.getBookingDetail}?booking_id=$bookingID"),
        headers: {"token": box.read(Constant.token)});

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      bookingDetailModel = bookingDetailModelFromJson(response.body);
      destinationController.text = bookingDetailModel!.data.tonameLocation;
      departureController.text = bookingDetailModel!.data.fromnameLocation;
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

}
