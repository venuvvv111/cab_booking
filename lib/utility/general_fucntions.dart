import 'package:figgocabs/screens/auth/LoginScreen.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

Future<String> getCurrentDateAndTime() async {
  final now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy HH:mm');
  return formatter.format(now);
}

void sessionExpireSnackBar(){
  Get.showSnackbar(errorSnackBar(message: 'Session Expired'));
}

void signout(){
  FirebaseAuth.instance.signOut().then((value) {
    Get.offAll(const LoginScreen());
    GetStorage().erase();
  });
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
      if (latLng.longitude < (y0 ?? 0)) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
}

Widget buildTextField(
    {required title, required TextEditingController textController}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: title,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabled: false,
      ),
    ),
  );
}