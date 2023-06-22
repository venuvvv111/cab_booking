// ignore_for_file: use_build_context_synchronously

import 'package:figgocabs/models/login_model.dart';
import 'package:figgocabs/screens/auth/LoginScreen.dart';
import 'package:figgocabs/screens/auth/OtpScreen.dart';
import 'package:figgocabs/screens/auth/set_name_screen.dart';
import 'package:figgocabs/screens/common/something_went_wrong_screen.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  var phoneController = TextEditingController();
  var isLoading = false.obs;
  late LoginModel loginmodel;
  final box = GetStorage();
  var fcmToken = '';

  @override
  void onInit(){
    super.onInit();
    getToken();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        if (value.user != null) {
          loginUser(context);
        }
      });
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> sendOtp(BuildContext context) async {
    isLoading(true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneController.text.trim()}',
      codeSent: (verificationId, resendToken) {
        isLoading(false);
        OtpScreen(
          verificationId: verificationId,
          phone: phoneController.text.trim(),
        ).launch(context,
            isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        isLoading(false);
        Get.showSnackbar(errorSnackBar(message: ex.message.toString()));

      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> loginUser(BuildContext context) async {
    var auth = FirebaseAuth.instance.currentUser;

    Map<String, String> bodyData = {
      "google_id": auth!.uid,
      "mobile": phoneController.text.toString(),
      "FCM_Token": fcmToken,
    };

    var response = await http
        .post(Uri.parse(Constant.baseUrl + UrlHelper.login), body: bodyData);

    debugPrint('response is ${response.statusCode} && ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.startsWith('<!doctype html>')){
        FirebaseAuth.instance.signOut();
        const SomethingWentWrongScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }else{
        loginmodel = loginModelFromJson(response.body);
        box.write(Constant.token, loginmodel.data.token);
        box.write(Constant.walletId, loginmodel.data.uniqueId);
        box.write(Constant.id, loginmodel.data.id);
        box.write(Constant.name, loginmodel.data.name);
        box.write(Constant.mobile, loginmodel.data.mobileNumber);
        if(!loginmodel.data.profileImage.isEmptyOrNull) {
          box.write(Constant.profilePic, loginmodel.data.profileImage);
        }

        if (context.mounted) {
          Get.showSnackbar(successSnackBar(message: 'You have been logged in successfully'));

          if (loginmodel.data.name.isEmpty) {
            const SetNameScreen().launch(context,
                isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          } else {
            DashboardScreen().launch(context,
                isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          }
        }
      }

    } else {
      if (context.mounted) {
        await FirebaseAuth.instance.signOut();
        Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
      }
    }
  }

  void verifyOtp(
      BuildContext context, String code, String verificationId) async {
    isLoading(true);
    String otp = code;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        loginUser(context);
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value ?? '';
      debugPrint(fcmToken);
    });
  }
}
