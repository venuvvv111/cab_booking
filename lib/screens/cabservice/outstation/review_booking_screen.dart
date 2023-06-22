import 'package:figgocabs/controllers/outstation_cab_controller.dart';
import 'package:figgocabs/screens/cabservice/common/payment_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewBookingScreen extends StatefulWidget {
  final bool isOutstation;
  final String price;
  final String tripName;

  const ReviewBookingScreen({Key? key, required this.isOutstation, required this.tripName, required this.price}) : super(key: key);

  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {

  var controller = Get.put(OutstationCabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: noTitleAppbar(context),
      body: Column(
        children: [
          buildTopSegment(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48.0),
            child: Center(child: Text('Sedan(Etios, Swift Dzire or Similar)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)),
          ),
          buildFairSegment()
        ],
      ),
      bottomNavigationBar: Container(
          height: 46,
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              const PaymentScreen(isAdvance: true, amount: '', pickupDate: '', pickupTime: '',).launch(context, isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: primaryColor,
            ),
            child: const Text(
              'Book now',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )),
    );
  }

  buildTopSegment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            controller.isOneWay.value ? 'One way' : 'Two way',
            style: medium.copyWith(
              fontSize: 28
            ),
          ),
        ),
        22.height,
        Container(
          color: const Color(0xffEBEBEB),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 6.0,
                ),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pickup',
                    style: boldsize.copyWith(
                        fontSize: 16
                    ),
                  ),
                  6.height,
                  Expanded(
                    child: Text(
                      controller.fromController.text,
                      style: normalsize.copyWith(
                          fontSize: 14
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 6.0,
                ),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Drop-off',
                    style: semiBold,
                  ),
                  6.height,
                  Expanded(
                    child: Text(
                      controller.toController.text,
                      style: normalsize,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  buildFairSegment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          listWidget('Maximum Passengers', '4'),
          4.height,
          listWidget('Time', controller.pickupTimeController.text),
          4.height,
          listWidget('Date', controller.pickupDateController.text),
          4.height,
          listWidget('Distance', controller.distance.toString()),
          4.height,
          listWidget('Time Taken', 'Approx ${controller.duration}'),
          4.height,
          listWidget('Amount', 'Rs. ${widget.price}'),
        ],
      ),
    );
  }

  Widget listWidget(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: const TextStyle(fontSize: 16),),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
      ],
    );
  }
}
