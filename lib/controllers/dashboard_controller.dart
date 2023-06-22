import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  late PageController pageController;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getToken();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  void onButtonPressed(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      selectedIndex.value,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      if (kDebugMode) {
        print('token is $value');
      }
    });
  }
}
