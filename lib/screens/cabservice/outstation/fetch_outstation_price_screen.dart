import 'package:figgocabs/controllers/outstation_cab_controller.dart';
import 'package:figgocabs/screens/cabservice/outstation/review_booking_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class FetchOutstationPriceScreen extends StatefulWidget {
  final bool isReturn;

  const FetchOutstationPriceScreen(
      {Key? key, required this.isReturn,})
      : super(key: key);

  @override
  State<FetchOutstationPriceScreen> createState() =>
      _FetchOutstationPriceScreenState();
}

class _FetchOutstationPriceScreenState
    extends State<FetchOutstationPriceScreen> {

  var controller = Get.put(OutstationCabController());

  @override
  void initState() {
    super.initState();
    controller.fetchFare(controller.distance.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: noTitleAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildLocationCard(),
            Obx(() => controller.isLoading.value ?
                LoadingAnimationWidget.staggeredDotsWave(color: primaryColor, size: 48)
                : controller.fareModel != null ?
                controller.fareModel!.data.isNotEmpty ?
            buildTaxiSheet(MediaQuery.of(context).size) :
            const SizedBox() : const SizedBox()),
          ],
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                                  textController: controller.fromController,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          buildTextField(
                            title: "Where do you want to go ?",
                            textController: controller.toController,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              24.height,
              Text(
                'Pickup date and Time',
                style: boldTextStyle(size: 14),
              ),
              12.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      8.width,
                      Text(controller.pickupDateController.text, style: primaryTextStyle())
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.watch_later_rounded),
                      8.width,
                      Text(
                        controller.pickupTimeController.text,
                        style: primaryTextStyle(),
                      )
                    ],
                  ),
                ],
              ),
              Visibility(
                  visible: widget.isReturn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.height,
                      Text(
                        'Return date',
                        style: boldTextStyle(size: 14),
                      ),
                      12.height,
                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          8.width,
                          Text(controller.returnDateController.text, style: primaryTextStyle())
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaxiSheet(Size size) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: InkWell(
            onTap: (){
          ReviewBookingScreen(
            isOutstation: true,
            tripName: widget.isReturn ? 'One way' : 'Round Trip',
            price: controller.fareModel!.data[index].price.toString(),
          ).launch(context,
              isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
            },
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.fareModel!.data[index].vechicleType,
                                  style: const TextStyle(
                                      color: Color(0xff203757),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text('Lowest price')
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
                      Text(
                  controller.fareModel!.data[index].price.toString(),
                        style: const TextStyle(
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
          ),
        );
      },
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
