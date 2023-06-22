import 'package:figgocabs/models/package_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class PackageController extends GetxController {
  List<PackageModel>? packageModel;
  final box = GetStorage();
  var walletAmount = 0.obs;

  Future<void> fetchData() async {
    var token = box.read(Constant.token);
    final url = Uri.parse(
        'https://figgo.in/api/user/packagedetails.php?number=${box.read(Constant.mobile)}');
    final response = await http.get(url, headers: {
      "token": token,
    });

    if (kDebugMode) {
      print(token);
    }
    if (kDebugMode) {
      print(response.statusCode);
    }
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      packageModel = packageModelFromJson(response.body);
      int amount = 0;
      for (var data in packageModel!) {
        if (data.type == "Family Package" ||
            data.type == "Professional Package" ||
            data.type == "Corporate Package") {
          amount = amount + data.budget.toInt();
        }
      }
      walletAmount.value = amount;
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }
  }
}
