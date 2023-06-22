// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

AppBar noTitleAppbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),
    ),
  );
}

AppBar appBar(BuildContext context, String title, bool isCenter) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: isCenter,
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),
    ),
  );
}

InputDecoration inputDecoration(
  BuildContext context, {
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  double? borderRadius,
  String? hintText,
}) {
  return InputDecoration(
    counterText: "",
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    hintText: hintText.validate(),
    hintStyle: secondaryTextStyle(),
    isDense: true,
    prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, size: 22, color: gray) : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    filled: true,
    fillColor: const Color(0xFFF8F8F8),
  );
}

GetSnackBar successSnackBar(
    {String title = 'Success', required String message}) {
  Get.log("[$title] $message");
  return GetSnackBar(
    titleText: Text(title.tr,
        style: const TextStyle(color: Colors.white)),
    messageText: Text(message,
        style: const TextStyle(color: Colors.white)),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(20),
    backgroundColor: Colors.green,
    icon: const Icon(Icons.check_circle_outline,
        size: 32, color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    dismissDirection: DismissDirection.horizontal,
    duration: const Duration(seconds: 5),
  );
}

GetSnackBar errorSnackBar({String title = 'Error', required String message}) {
  Get.log("[$title] $message", isError: true);
  return GetSnackBar(
    titleText: Text(title.tr,
        style: const TextStyle(color: Colors.white)),
    messageText: Text(message.substring(0, min(message.length, 200)),
        style: const TextStyle(color: Colors.white)),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(20),
    backgroundColor: Colors.redAccent,
    icon: const Icon(Icons.remove_circle_outline,
        size: 32, color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    duration: const Duration(seconds: 5),
  );
}

GetSnackBar defaultSnackBar({String title = 'Alert', required String message}) {
  Get.log("[$title] $message", isError: false);
  return GetSnackBar(
    titleText: Text(title.tr,
        style: const TextStyle(color: Colors.white)),
    messageText: Text(message,
        style: const TextStyle(color: Colors.white)),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(20),
    backgroundColor: primaryColor,
    borderColor: Get.theme.focusColor.withOpacity(0.1),
    icon: const Icon(Icons.warning_amber_rounded, size: 32, color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    duration: const Duration(seconds: 5),
  );
}
