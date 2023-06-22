import 'package:fbroadcast/fbroadcast.dart';
import 'package:figgocabs/controllers/booked_cab_controller.dart';
import 'package:figgocabs/models/accept_driver_model.dart';
import 'package:figgocabs/screens/cabservice/common/ride_complete_screen.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class BookedCabScreen extends StatefulWidget {
  final String? pickupDate;
  final String? pickupTime;
  final String? paymentMode;
  final AcceptDriverModel? acceptDriverModel;
  final bool? isHistory;
  final String? bookingID;
  final String? transactionID;

  const BookedCabScreen(
      {Key? key,
      this.acceptDriverModel,
      this.pickupDate,
      this.pickupTime,
      this.paymentMode,
      this.isHistory,
      this.bookingID,
      this.transactionID})
      : super(key: key);

  @override
  State<BookedCabScreen> createState() => _BookedCabScreenState();
}

class _BookedCabScreenState extends State<BookedCabScreen> {
  var controller = Get.put(BookedCabController());
  String _mapStyle = "";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    if (widget.isHistory!) {
      controller.fetchBookingInfo(widget.bookingID!);
    } else {
      debugPrint('inside check');
      var data = widget.acceptDriverModel!;
      controller.acceptDriver(
          data.pickLatLng.latitude.toString(),
          data.pickLatLng.longitude.toString(),
          data.dropLatLng.latitude.toString(),
          data.dropLatLng.longitude.toString(),
          data.distance,
          data.bookingType,
          data.departureName,
          data.destinationName,
          data.amountToPay,
          data.selectedVehicle,
          data.selectedDriverId,
          widget.paymentMode!,
          widget.pickupDate!,
          widget.pickupTime!,
          widget.transactionID!);
    }

    /// register and listen to broadcast
    FBroadcast.instance().register(Constant.rideBroadcast, (value, callback) {
      debugPrint('Got broadcast');

      if (value == "Ride Complete") {
        const RideCompleteScreen().launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }

      if (value == "Ride Start") {
        controller.updatePolyLineToDestination();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (controller.positionStreamSubscription != null) {
      controller.positionStreamSubscription!.cancel();
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                padding: const EdgeInsets.only(bottom: 150),
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(19.018255973653343, 72.84793849278007),
                    zoom: 18.0,
                    tilt: 0,
                    bearing: 0),
                onMapCreated: (GoogleMapController mapController) async {
                  controller.mapController = mapController;
                  mapController.setMapStyle(_mapStyle);
                },
                polylines: Set<Polyline>.of(controller.polyLines.values),
                myLocationEnabled: false,
                markers: controller.markers.values.toSet(),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(DashboardScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Obx(
              () => controller.isLoading.value
                  ? buildLoadingCard(MediaQuery.of(context).size)
                  : widget.isHistory!
                      ? controller.bookingDetailModel != null
                          ? buildRideDetailCard(MediaQuery.of(context).size)
                          : SizedBox(
                              height: 150,
                              child: Text(
                                'No data',
                                style: primaryTextStyle(),
                              ),
                            )
                      : controller.bookedRideModel != null
                          ? buildCurrentBookedCabDriver(
                              MediaQuery.of(context).size)
                          : SizedBox(
                              height: 150,
                              child: Text(
                                'No data',
                                style: primaryTextStyle(),
                              ),
                            ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCurrentBookedCabDriver(Size size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Text(
                'OTP - ${controller.bookedRideModel!.rideDetails.otp}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 58, 47, 47).withOpacity(0.6),
                    blurRadius: 15.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: const Offset(
                      5.0, // Move to right 5  horizontally
                      5.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.bookedRideModel!.driverDetails.vehicleType,
                      style: primaryTextStyle(),
                    ),
                    Text(
                      controller.bookedRideModel!.driverDetails.vehicleNum,
                      style: primaryTextStyle(),
                    )
                  ],
                ),
                12.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: FadeInImage(
                            placeholder:
                                const AssetImage('assets/icons/user.png'),
                            image: NetworkImage(controller
                                .bookedRideModel!.driverDetails.profilePic),
                          ).image,
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.bookedRideModel!.driverDetails.name,
                              style: boldTextStyle(),
                            ),
                            4.height,
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_outlined,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  '5.0 (200 +)',
                                  style: primaryTextStyle(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(
                            Icons.phone,
                            size: 16,
                          ),
                        ),
                        12.width,
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(
                            Icons.message,
                            size: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                16.height,
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ride details',
                        style: boldTextStyle(),
                      ),
                      12.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 6.0,
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup',
                                style:
                                    primaryTextStyle(weight: FontWeight.w500),
                              ),
                              Text(
                                controller
                                    .bookedRideModel!.rideDetails.departure,
                                maxLines: 1,
                                style: primaryTextStyle(),
                              )
                            ],
                          ).expand()
                        ],
                      ),
                      8.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 6.0,
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Drop off',
                                style:
                                    primaryTextStyle(weight: FontWeight.w500),
                              ),
                              Text(
                                controller
                                    .bookedRideModel!.rideDetails.destination,
                                style: primaryTextStyle(),
                              )
                            ],
                          ).expand()
                        ],
                      )
                    ],
                  ),
                ),
                12.height
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text(
                        'Why you want to cancel the ride?',
                        style: boldTextStyle(size: 18),
                      ),
                      message: Text(
                        'Choose one of the reasons below',
                        style: primaryTextStyle(size: 16),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: const Text("I don't want to go now"),
                          onPressed: () {
                            Navigator.of(context);
                            controller.cancelRide(controller
                                .bookedRideModel!.rideDetails.bookingId
                                .toString());
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('I have other reasons'),
                          onPressed: () {
                            Navigator.of(context);
                            controller.cancelRide(controller
                                .bookedRideModel!.rideDetails.bookingId
                                .toString());
                          },
                        )
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Cancel Ride',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildRideDetailCard(Size size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Text(
                'OTP - ${controller.bookingDetailModel!.data.otp}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 58, 47, 47).withOpacity(0.6),
                    blurRadius: 15.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: const Offset(
                      5.0, // Move to right 5  horizontally
                      5.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.bookingDetailModel!.driver.vehicleType,
                      style: primaryTextStyle(),
                    ),
                    Text(
                      controller.bookingDetailModel!.driver.vehicleNum,
                      style: primaryTextStyle(),
                    )
                  ],
                ),
                12.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: FadeInImage(
                            placeholder:
                                const AssetImage('assets/icons/user.png'),
                            image: NetworkImage(controller
                                .bookingDetailModel!.driver.profileImage),
                          ).image,
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.bookingDetailModel!.driver.name,
                              style: boldTextStyle(),
                            ),
                            4.height,
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_outlined,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  '5.0 (200 +)',
                                  style: primaryTextStyle(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(
                            Icons.phone,
                            size: 16,
                          ),
                        ),
                        12.width,
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(
                            Icons.message,
                            size: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                16.height,
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ride details',
                        style: boldTextStyle(),
                      ),
                      12.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 6.0,
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup',
                                style:
                                    primaryTextStyle(weight: FontWeight.w500),
                              ),
                              Text(
                                controller
                                    .bookingDetailModel!.data.fromnameLocation,
                                maxLines: 1,
                                style: primaryTextStyle(),
                              )
                            ],
                          ).expand()
                        ],
                      ),
                      8.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 6.0,
                            ),
                          ),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Drop off',
                                style:
                                    primaryTextStyle(weight: FontWeight.w500),
                              ),
                              Text(
                                controller
                                    .bookingDetailModel!.data.tonameLocation,
                                style: primaryTextStyle(),
                              )
                            ],
                          ).expand()
                        ],
                      )
                    ],
                  ),
                ),
                12.height
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text(
                        'Why you want to cancel the ride?',
                        style: boldTextStyle(size: 18),
                      ),
                      message: Text(
                        'Choose one of the reasons below',
                        style: primaryTextStyle(size: 16),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: const Text("I don't want to go now"),
                          onPressed: () {
                            Navigator.of(context);
                            if (widget.isHistory!) {
                              controller.cancelRide(controller
                                  .bookingDetailModel!.data.bookingId);
                            } else {
                              controller.cancelRide(controller
                                  .bookedRideModel!.rideDetails.bookingId
                                  .toString());
                            }
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('I have other reasons'),
                          onPressed: () {
                            Navigator.of(context);
                            if (widget.isHistory!) {
                              controller.cancelRide(controller
                                  .bookingDetailModel!.data.bookingId);
                            } else {
                              controller.cancelRide(controller
                                  .bookedRideModel!.rideDetails.bookingId
                                  .toString());
                            }
                          },
                        )
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Cancel Ride',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoadingCard(Size size) {
    return Container(
      height: size.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: primaryColor, size: 48),
          4.height,
          Text(
            'Fetching ride info...',
            style: primaryTextStyle(),
          )
        ],
      ),
    );
  }
}
