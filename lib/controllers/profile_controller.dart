// ignore_for_file: depend_on_referenced_packages, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:figgocabs/models/profile_model.dart';
import 'package:figgocabs/screens/auth/LoginScreen.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';

import 'auth_controller.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  var isFetchingProfile = false;
  var isLoading = false;
  var message = '';
  String dropdownValue = 'Male';

  late ProfileModel profileModel;
  final userNameController = TextEditingController().obs;
  final userNickNameController = TextEditingController().obs;
  final userDateOfBirthController = TextEditingController().obs;
  final userEmailController = TextEditingController().obs;
  final userContactNumberController = TextEditingController().obs;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();

  Rx<DateTime> selectedDate = DateTime.now().obs;

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
      builder: (_, child) {
        return child!;
      },
    ).then((date) async {
      if (date != null) {
        selectedDate.value = date;
        userDateOfBirthController.value.text =
            DateFormat('dd/MM/yyyy').format(date);
      }
    }).catchError((e) {
      toast(e.toString());
    });
  }

  Future<void> updateProfile() async {
    isLoading = true;
    update();

    var token = box.read(Constant.token);
    print(token);

    Map<String, String> bodyData = {
      "id": box.read(Constant.id),
      "name": userNameController.value.text,
      "email": userEmailController.value.text,
      "gender": dropdownValue,
      "dob": DateFormat('dd/MM/yyyy').format(selectedDate.value),
    };

    print(bodyData);

    var response =
        await http.post(Uri.parse(Constant.baseUrl + UrlHelper.updateProfile),
            headers: {
              "token": token,
            },
            body: bodyData);

    print('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json["status"] == "Success") {
        Get.showSnackbar(successSnackBar(message: 'Profile updated successfully'));
        getProfile(false);
      }
    } else if (response.statusCode == 201) {
      Get.showSnackbar(errorSnackBar(message: 'Token Expired, Try logging in again'));
      signout();
    } else {
    Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }
  }

  Future<void> setName(BuildContext context) async {
    isLoading = true;
    update();

    var token = box.read(Constant.token);
    print(token);

    Map<String, String> bodyData = {
      "id": box.read(Constant.id),
      "name": userNameController.value.text,
    };

    print(bodyData);

    var response =
        await http.post(Uri.parse(Constant.baseUrl + UrlHelper.updateProfile),
            headers: {
              "token": token,
            },
            body: bodyData);

    print('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json["status"] == "Success") {
        box.write(Constant.name, userNameController.value.text);
        DashboardScreen().launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }
  }

  Future<void> getProfile(bool isFetching) async {
    if (isFetching) {
      message = 'Fetching profile, Please wait...';
      isFetchingProfile = true;
      update();
    } else {
      message = 'Fetching updated profile';
    }

    var token = box.read(Constant.token);
    debugPrint(token);

    var response = await http
        .post(Uri.parse(Constant.baseUrl + UrlHelper.getProfile), headers: {
      "token": token,
    });

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      profileModel = profileModelFromJson(response.body);
      userNameController.value.text = profileModel.data.name;
      userDateOfBirthController.value.text = profileModel.data.dob;
      userEmailController.value.text = profileModel.data.email;
      userContactNumberController.value.text = profileModel.data.mobileNumber;
      box.write(Constant.name, profileModel.data.name);
      box.write(Constant.mobile, profileModel.data.mobileNumber);
    } else if (response.statusCode == 201) {
      FirebaseAuth.instance.signOut().then((value) {
        box.erase();
        sessionExpireSnackBar();
        Get.offAll(const LoginScreen());
      });
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    if (isFetching) {
      isFetchingProfile = false;
    } else {
      isLoading = false;
    }

    update();
    message = '';
  }

  updateGender(String value) {
    dropdownValue = value;
    update();
  }

  Future<void> uploadImage(File imageFile, BuildContext context) async {
    var token = box.read(Constant.token);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Constant.baseUrl + UrlHelper.updateProfile),
    );

    var imagePart =
        await http.MultipartFile.fromPath("profile_image", imageFile.path);
    request.files.add(imagePart);
    request.fields['id'] = box.read(Constant.id);
    request.headers['token'] = token;

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('Image uploaded successfully');
      updateProfile();
    } else {
      // Handle the error response
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }
  }
}
