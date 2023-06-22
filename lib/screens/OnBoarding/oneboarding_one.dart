// ignore_for_file: file_names

import 'package:figgocabs/screens/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:nb_utils/nb_utils.dart';

class OnBoard1 extends StatefulWidget {
  const OnBoard1({super.key});

  @override
  State<OnBoard1> createState() => _OnBoard1State();
}

class _OnBoard1State extends State<OnBoard1> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      Container(
        color: const Color(0xFF2C3E50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/onBoardingC1.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to our taxi app!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: "Sofia",
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "We make getting around easier and more convenient than ever before. Whether you're heading to work, meeting friends, or running errands, we're here to help you get there quickly and safely.",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonTheme(
                    height: 50,
                    minWidth: 150,
                    child: OutlinedButton(
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        const LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        color: const Color(0xFF34495E),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/onBoardingC2.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book a ride in seconds',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: "Sofia",
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "With just a few taps on your phone, you can book a ride to anywhere you need to go. Our app makes it easy to get a ride quickly and easily, so you can get on with your day.",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonTheme(
                    height: 50,
                    minWidth: 150,
                    child: OutlinedButton(
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        const LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        color: const Color(0xFFA51845),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/onBoardingC3.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get where you need to go, fast',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: "Sofia",
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "With our taxi app, you can easily book a ride and get to your destination quickly and efficiently. Our drivers are trained to provide the best service possible, and our app allows you to track your ride in real time.",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonTheme(
                    height: 50,
                    minWidth: 150,
                    child: OutlinedButton(
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        const LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];

    return Scaffold(
      body: LiquidSwipe(
        pages: pages,
        positionSlideIcon: 0,
        initialPage: 0,
        enableLoop: false,
        slideIconWidget: null,
      ),
    );
  }
}
