import 'package:figgocabs/models/wallet_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  final box = GetStorage();
  WalletModel? walletModel;
  var walletAmount = 0.obs;

  Future<void> fetchData() async {
    final url = Uri.parse(
        '${Constant.baseUrl}${UrlHelper.wallet}?main_id=${box.read(Constant.id)}&unique_id=${box.read(Constant.walletId)}');
    final response =
        await http.get(url, headers: {"token": box.read(Constant.token)});

    if (kDebugMode) {
      print('${box.read(Constant.walletId)}');
    }
    if (kDebugMode) {
      print('${box.read(Constant.token)}');
    }
    if (response.statusCode == 200) {
      walletModel = walletModelFromJson(response.body);
      walletAmount(walletModel!.walletBalance);
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }
  }
}
