import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({Key? key}) : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/star.png',
                    width: 50,
                    height: 50,
                  ),
                  12.width,
                  const Text(
                    'Congratulation',
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                  12.width,
                  Image.asset(
                    'assets/icons/star.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              24.height,
              const Text(
                'Your Booking with Booking ID 134556 is Confirmed. you can check all details of your booking in my booking.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          height: 46,
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              DashboardScreen().launch(context,
                  isNewTask: false,
                  pageRouteAnimation: PageRouteAnimation.Fade);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: primaryColor,
            ),
            child: const Text(
              'Back to home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )),
    );
  }
}
