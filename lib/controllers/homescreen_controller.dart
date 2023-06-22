import 'package:figgocabs/models/dashboard_model.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HomeScreenController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  late DashboardModel dashboardModel;
  RxList banners = [].obs;

  Future<void> fetchBanners() async {
    isLoading(true);
    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.dashboard),
        headers: {"token": box.read(Constant.token)});

    debugPrint('response is ${response.statusCode} && ${response.body}');

    if (response.statusCode == 200) {
      dashboardModel = dashboardModelFromJson(response.body);
      banners.assignAll(dashboardModel.data.offers);
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }
}
