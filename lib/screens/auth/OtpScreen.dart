// ignore_for_file: prefer_const_constructors, unused_import, prefer_final_fields, duplicate_ignore, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable, file_names

import 'dart:developer';

import 'package:figgocabs/controllers/auth_controller.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId, phone;

  const OtpScreen({
    Key? key,
    required this.verificationId,
    required this.phone,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _code = "";
  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    startListener();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/otp_check.png',
                  scale: 2,
                ),
                24.height,
                Text(
                  'OTP Verification',
                  style: TextStyle(
                      color: Color(0xff203757),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                4.height,
                Text(
                  'Enter the otp sent to',
                  style: TextStyle(color: Color(0xffB1B1B1), fontSize: 18.0),
                ),
                4.height,
                Text(
                  '+91 ${widget.phone}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                4.height,
                PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                  currentCode: _code,
                  onCodeChanged: (code) {
                    if (code!.length == 6) {
                      _code = code;
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
                8.height,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't received OTP?",
                        style:
                            TextStyle(color: Color(0xffB1B1B1), fontSize: 18.0),
                      ),
                      8.width,
                      Text(
                        "Resend OTP",
                        style:
                            TextStyle(color: Color(0xff203757), fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => authController.isLoading.value
                      ? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: primaryColor, size: 48),
                        )
                      : InkWell(
                          onTap: () {
                            authController.verifyOtp(
                                context, _code, widget.verificationId);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              'VERIFY',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startListener() async {
    await SmsAutoFill().listenForCode();
  }
}
