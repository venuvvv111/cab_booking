import 'package:figgocabs/screens/OnBoarding/oneboarding_one.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      //This block of code will execute after 3 sec of app launch
      FirebaseAuth.instance.currentUser != null
          ? DashboardScreen().launch(
          context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade)
          : const OnBoard1().launch(context, isNewTask: true,
          pageRouteAnimation: PageRouteAnimation.Fade);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFF203757),
                  Color(0xFF141414),
                ],
                radius: 1,
              ),
            ),
          ),
          const Center(
            child: Image(
              image: AssetImage('assets/images/splash.png'),
              width: 150,
              height: 150,),
          ),
        ],),
      ),
    );
  }

}
