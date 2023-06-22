import 'package:figgocabs/screens/cabservice/outstation/review_booking_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/category_title.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FetchPackagePriceScreen extends StatefulWidget {
  final String from;

  const FetchPackagePriceScreen({Key? key, required this.from})
      : super(key: key);

  @override
  State<FetchPackagePriceScreen> createState() =>
      _FetchPackagePriceScreenState();
}

class _FetchPackagePriceScreenState extends State<FetchPackagePriceScreen> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    departureController.text = widget.from;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: noTitleAppbar(context),
      body: Column(
        children: [
          const CategoryTitle(title: 'Ride details'),
          buildLocationCard(),
          const CategoryTitle(title: 'Choose a ride'),
          buildTaxiSheet(MediaQuery.of(context).size),
          Container(
              height: 46,
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  const ReviewBookingScreen(
                    isOutstation: false,
                    tripName: 'Package',
                    price: '',
                  ).launch(context,
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
                  'Review Booking',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ))
        ],
      ),
    );
  }

  Widget buildLocationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      radius: 6.0,
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: Text(
                      departureController.text,
                      style: primaryTextStyle(size: 24),
                    ),
                  ),
                ],
              ),
              12.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      8.width,
                      const Text('22/12/2023', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.watch_later_rounded),
                      8.width,
                      const Text(
                        '08:10 AM',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaxiSheet(Size size) {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 8,
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/hatchback.png',
                              width: 100,
                              height: 100,
                            ),
                            12.width,
                            Column(
                              children: const [
                                Text(
                                  'Hatchback',
                                  style: TextStyle(
                                      color: Color(0xff203757),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Lowest price')
                              ],
                            )
                          ],
                        ),
                        const Text('WagonR, Swift, Alto or Similar')
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '2000',
                        style: TextStyle(
                            color: Color(0xff203757),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      16.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          iconWithText(Icons.ac_unit, "AC"),
                          4.height,
                          iconWithText(Icons.location_history, "GPS tracking"),
                          4.height,
                          iconWithText(Icons.luggage, "Luggage"),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
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

  Widget iconWithText(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 12,
        ),
        8.width,
        Text(
          text,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
