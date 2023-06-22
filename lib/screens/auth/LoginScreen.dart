// ignore_for_file: use_build_context_synchronously, file_names

import 'package:figgocabs/controllers/auth_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var authController = Get.put(AuthController());
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.cover)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Get Up to 50% off on Your',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('First Booking',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  buildLoginCard(size)
                ],
              )
            ],
          ),
        ));
  }

  Widget buildLoginCard(Size size) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Obx(
          () => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 10,
            color: Colors.white,
            child: Container(
              height: size.height / 3,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: authController.isLoading.value
                  ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.black, size: 32),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.black)),
                            child: TextFormField(
                              controller: authController.phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (item) {
                                return item.toString().length == 10
                                    ? null
                                    : "Enter valid mobile number ";
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter mobile number'),
                            ),
                          ),
                          InkWell(
                            onTap: () => authController.sendOtp(context),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // Hide Google login for now
                          /*const Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                authController.signInWithGoogle(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.red.shade300)),
                              child: const Image(
                                  image: AssetImage('assets/icons/google.png')),
                            ),
                          ),*/
                          const Text(
                            'Have a Refferal Code?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
