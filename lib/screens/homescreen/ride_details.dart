import 'package:figgocabs/controllers/ride_history_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class RideDetails extends StatefulWidget {
  final String bookingID;

  const RideDetails({Key? key, required this.bookingID}) : super(key: key);

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {

  var controller = Get.put(RideHistoryController());

  @override
  void initState() {
    super.initState();
    controller.fetchBookingInfo(widget.bookingID);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => controller.isLoading.value ? Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: primaryColor, size: 48))
            .expand(): controller.bookingDetailModel != null ? buildRideInfoUI() : const Center(child: Text('No Data found'))),
      ),
    );
  }

  buildRideInfoUI(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.bookingDetailModel!.data.dateTime, style: boldTextStyle(size: 22),),
            12.height,
            Container(
              height: 300,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(1, 2),
                    blurRadius: 20)
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  padding: const EdgeInsets.only(bottom: 150),
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController mapController) async {},
                  myLocationEnabled: true,
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(19.018255973653343, 72.84793849278007),
                      zoom: 18.0,
                      tilt: 0,
                      bearing: 0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.bookingDetailModel!.driver.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              color: Color(0xffefc868),
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall,
                            )
                          ],
                        ),
                        Text(
                          controller.bookingDetailModel!.data.vehicleType,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Car name",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.7),
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: Text(
                            controller.bookingDetailModel!.driver.vehicleNum,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall?.copyWith(
                                color: Colors.white
                            ),
                          ),
                        )
                      ]),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: primaryColor.withOpacity(0.1)),
              child: Row(children: [
                Text(
                  "Payment method",
                  style:
                  Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const SizedBox(width: 8),
                Text(
                  controller.bookingDetailModel!.data.paymentType,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: primaryColor.withOpacity(0.1)),
              child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Trip information",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                      child: Column(
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
                                              textController:
                                              controller.departureController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      buildTextField(
                                        title: "Where do you want to go ?",
                                        textController:
                                        controller.destinationController,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
