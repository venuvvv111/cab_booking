import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rating_dialog/rating_dialog.dart';

class RideCompleteScreen extends StatefulWidget {
  const RideCompleteScreen({Key? key}) : super(key: key);

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  final box = GetStorage();

  final _dialog = RatingDialog(
    initialRating: 1.0,
    // your app's name?
    title: const Text(
      'Rate the captain',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      'How well you think our service was?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: CircleAvatar(
      radius: 50,
      child: Image.network("https://staticg.sportskeeda.com/editor/2022/01/4619c-16428809335980-1920.jpg"),
    ),
    submitButtonText: 'Submit',
    commentHint: 'Write a few words about the service',
    onCancelled: () => debugPrint('cancelled'),
    onSubmitted: (response) {
      debugPrint('rating: ${response.rating}, comment: ${response.comment}');
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Thank you', style: boldTextStyle(size: 26),),
                12.height,
                Text('Mrr. ${box.read(Constant.name)}', style: primaryTextStyle(size: 22),),
                12.height,
                Text('You can download the Invoice from Booking history. also we will share the invoice in your registered e-mail.',
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(size: 20),)
              ],
            )),
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
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Rs 20', style: primaryTextStyle(size: 24),),
                    8.height,
                    Text('Cashback Earned', style: primaryTextStyle(size: 22),),
                    8.height,
                    Text('Cashback Will send to your figgo wallet within 24 hours.',
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(size: 18),)
                  ],
                ),
                24.height,
                Column(
                  children: [
                    Text('Rs 10', style: primaryTextStyle(size: 24),),
                    8.height,
                    Text('Inconvenience', style: primaryTextStyle(size: 22),),
                    8.height,
                    Text('Sorry For The Inconvenience, figgo will pay you for extra Waiting due to our driver.',
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(size: 18),)
                  ],
                )
              ],
            ))
          ],
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
            height: 46,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.offAll(DashboardScreen());
                showDialog(
                  context: context,
                  barrierDismissible: false, // set to false if you want to force a rating
                  builder: (context) => _dialog,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: primaryColor,
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )),
      ),
    );
  }
}
