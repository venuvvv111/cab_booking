import 'dart:convert';

import 'package:figgocabs/models/accept_driver_model.dart';
import 'package:figgocabs/screens/cabservice/cityCab/booked_cab_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentController extends GetxController {
  var processing = true.obs;
  var success = false.obs;
  var failed = false.obs;
  final box = GetStorage();
  var transactionID = "";

  Future<void> payViaWallet(String amount, String pickupDate, String pickupTime,
      AcceptDriverModel acceptDriverModel, BuildContext context) async {

    processing(true);
    Map<String, String> body = {
      'unique_id': box.read(Constant.walletId),
      'amount': amount,
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.payByWallet),
        headers: {"token": box.read(Constant.token)},
        body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['status'] == "Success") {
        processing(false);
        success(true);
        transactionID = json["data"];
        Future.delayed(const Duration(seconds: 3)).then((value) {
          BookedCabScreen(pickupDate: pickupDate, pickupTime: pickupTime, paymentMode: "wallet",
            acceptDriverModel: acceptDriverModel, isHistory: false, transactionID: transactionID,)
              .launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        });
      }else{
        processing(false);
        failed(true);
      }
    } else {
      processing(false);
      failed(true);
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pop(context);
      });
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

  }
}