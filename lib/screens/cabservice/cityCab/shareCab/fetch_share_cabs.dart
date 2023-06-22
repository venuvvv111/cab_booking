import 'package:figgocabs/screens/cabservice/common/payment_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FetchShareCabs extends StatefulWidget {
  final String destination;
  final String from;

  const FetchShareCabs({Key? key, required this.destination, required this.from}) : super(key: key);

  @override
  State<FetchShareCabs> createState() => _FetchShareCabsState();
}

class _FetchShareCabsState extends State<FetchShareCabs> {

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    departureController.text = widget.from;
    destinationController.text = widget.destination;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: noTitleAppbar(context),
      body: Column(
        children: [
          buildLocationCard(),
          buildTaxiSheet(MediaQuery.of(context).size)
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
          child: Row(
            children: [
              Image.asset(
                'assets/icons/ic_pic_drop_location.png',
                height: 85,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              title: "Departure",
                              textController: departureController,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      buildTextField(
                        title: "Where do you want to go ?",
                        textController: destinationController,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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

  Widget buildTaxiSheet(Size size) {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              const PaymentScreen(isAdvance: true, amount: '129', pickupDate: '', pickupTime: '', ).launch(context, isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12 ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('08:00 AM', style: boldTextStyle(color: primaryColor, size: 22),),
                        SizedBox(
                          height: 32,
                          child: ListView.builder(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.all(2.0),
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(100.0)
                                  ),
                                  child: Center(child: Text('M', style: primaryTextStyle(color: primaryColor, size: 12),)),
                                );
                              }),
                        )
                      ],
                    ),
                    18.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Vacant seats', style: secondaryTextStyle(),),
                        Row(
                          children: [
                            Icon(Icons.event_seat, color: Colors.grey.shade600,),
                            4.width,
                            Text('3', style: primaryTextStyle(size: 20),)
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle', style: secondaryTextStyle(),),
                            Text('White swift', style: primaryTextStyle(),),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price', style: secondaryTextStyle(),),
                            Text('\$ 1000', style: primaryTextStyle(),),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Driver name', style: secondaryTextStyle(),),
                            Text('Abhishek Maurya', style: primaryTextStyle(),),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ratings', style: secondaryTextStyle(),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.star, color: Colors.yellow.shade700,),
                                4.width,
                                Text('2.5', style: primaryTextStyle(),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }



}
