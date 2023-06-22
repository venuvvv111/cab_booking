// ignore_for_file: unused_local_variable, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_import, library_prefixes, unused_element, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:figgocabs/models/accept_driver_model.dart';
import 'package:figgocabs/screens/cabservice/common/payment_screen.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:figgocabs/controllers/cab_booking_controller.dart';
import 'package:figgocabs/controllers/location_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class CurrentBookingScreen extends StatefulWidget {
  final String startAddress;
  final String destAddress;
  final String distance;
  final List<String> vehicleTypes;
  final String pickupDate;
  final String pickupTime;

  const CurrentBookingScreen(
      {super.key,
      required this.startAddress,
      required this.destAddress,
      required this.distance,
      required this.vehicleTypes,
      required this.pickupDate,
      required this.pickupTime});

  @override
  State<CurrentBookingScreen> createState() => _CurrentBookingScreenState();
}

class _CurrentBookingScreenState extends State<CurrentBookingScreen> {
  GoogleMapController? _controller;
  final locationController = Get.find<LocationController>();
  final cabBookingController = Get.put(CabBookingController());
  String _mapStyle = "";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    cabBookingController.departureController.text = widget.startAddress;
    cabBookingController.destinationController.text = widget.destAddress;
    cabBookingController.pickupDate(widget.pickupDate);
    cabBookingController.pickupTime(widget.pickupTime);
    cabBookingController.fetchFare(widget.distance);
  }

  @override
  void dispose() {
    super.dispose();
    cabBookingController.fareModel = null;
    cabBookingController.resetState();
  }

  Io.File? imgFile;
  var nLat, nLon, sLat, sLon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(
                  bottom: size.height / 2, right: size.width / 3),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: locationController.kInitialPosition.value,
              onMapCreated: (GoogleMapController mapController) async {
                _controller = mapController;
                mapController.setMapStyle(_mapStyle);
                await Future.delayed(
                    const Duration(milliseconds: 500)); // Delay for map to load
                mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(
                      boundsFromLatLngList([
                        locationController.departureLatLong.value!,
                        locationController.destinationLatLong.value!
                      ]),
                      50),
                );
              },
              polylines: Set<Polyline>.of(locationController.polyLines.values),
              myLocationEnabled: false,
              markers: locationController.markers.values.toSet(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
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
                Obx(() => (!cabBookingController.showCabCard.value &&
                        !cabBookingController.showWaitingCard.value &&
                        !cabBookingController.result.value)
                    ? buildLocationCard()
                    : Container())
              ],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Obx(() => cabBookingController.showWaitingCard.value
                    ? buildLookingForDriverCard(size)
                    : cabBookingController.showCabCard.value
                        ? buildCabDriverCard(size)
                        : buildTaxiSheet(size)))
          ],
        ),
      ),
    );
  }

  Widget buildLocationCard() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                                      cabBookingController.departureController,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          buildTextField(
                            title: "Where do you want to go ?",
                            textController:
                                cabBookingController.destinationController,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaxiSheet(Size size) {
    return GetBuilder<CabBookingController>(builder: (controller) {
      return Container(
        height: size.height / 2.2,
        width: size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: (controller.fareModel != null &&
                controller.fareModel!.data.isNotEmpty)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 24),
                    child: Text(
                      'Select a ride',
                      style: boldTextStyle(size: 18),
                    ),
                  ),
                  ListView.builder(
                    itemCount: controller.fareModel!.data.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                        child: ListTile(
                            onTap: () {
                              if (widget.vehicleTypes.contains(controller
                                  .fareModel!.data[index].vechicleType)) {
                                controller.showWaitingCard(true);

                                controller.initiateRide(
                                    locationController
                                        .departureLatLong.value!.latitude
                                        .toString(),
                                    locationController
                                        .departureLatLong.value!.longitude
                                        .toString(),
                                    locationController
                                        .destinationLatLong.value!.latitude
                                        .toString(),
                                    locationController
                                        .destinationLatLong.value!.longitude
                                        .toString(),
                                    widget.distance,
                                    controller.fareModel!.data[index].price
                                        .toString(),
                                    controller
                                        .fareModel!.data[index].vechicleType,
                                    controller.departureController.text,
                                    controller.destinationController.text);
                                cabBookingController.amountToPay = controller
                                    .fareModel!.data[index].price
                                    .toString();
                                cabBookingController.selectedVehicle =
                                    controller
                                        .fareModel!.data[index].vechicleType;
                              } else {
                                toast('No drivers available nearby');
                              }
                            },
                            leading: Container(
                                height: 60,
                                width: 80,
                                child: Image(
                                  image: AssetImage(controller.fareModel!
                                              .data[index].vechicleType ==
                                          'Hatchback'
                                      ? 'assets/icons/hatchback.png'
                                      : controller.fareModel!.data[index]
                                                  .vechicleType ==
                                              'Auto'
                                          ? 'assets/icons/auto.png'
                                          : controller.fareModel!.data[index]
                                                      .vechicleType ==
                                                  'Sedan'
                                              ? 'assets/icons/sedan.png'
                                              : controller
                                                          .fareModel!
                                                          .data[index]
                                                          .vechicleType ==
                                                      'Royal'
                                                  ? 'assets/icons/royal.png'
                                                  : controller
                                                              .fareModel!
                                                              .data[index]
                                                              .vechicleType ==
                                                          'MUV'
                                                      ? 'assets/icons/suv.png'
                                                      : controller
                                                                  .fareModel!
                                                                  .data[index]
                                                                  .vechicleType ==
                                                              'Sedan Prime'
                                                          ? 'assets/icons/sedan.png'
                                                          : controller
                                                                      .fareModel!
                                                                      .data[
                                                                          index]
                                                                      .vechicleType ==
                                                                  'MUV Prime'
                                                              ? 'assets/icons/suv.png'
                                                              : controller.fareModel!.data[index].vechicleType == 'Ertiga'
                                                                  ? 'assets/icons/ertiga.png'
                                                                  : controller.fareModel!.data[index].vechicleType == 'Innova'
                                                                      ? 'assets/icons/innova.jpeg'
                                                                      : controller.fareModel!.data[index].vechicleType == 'Travler'
                                                                          ? 'assets/icons/travelor.jpg'
                                                                          : controller.fareModel!.data[index].vechicleType == 'Luxury'
                                                                              ? 'assets/icons/luxury.png'
                                                                              : 'assets/icons/hatchback.png'),
                                  fit: BoxFit.contain,
                                )),
                            title: Text(
                              controller.fareModel!.data[index].vechicleType,
                              style: const TextStyle(color: Color(0xff203757)),
                            ),
                            subtitle: const Text(
                              '0h 30m | Low price',
                              style: TextStyle(),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '₹ ${controller.fareModel!.data[index].price.toString()}',
                                style: boldTextStyle(size: 20),
                              ),
                            )),
                      );
                    },
                  ).expand(),
                ],
              )
            : SizedBox(
                height: 48,
                width: 48,
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: primaryColor, size: 32)),
      );
    });
  }

  Widget buildLookingForDriverCard(Size size) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16.0),
        width: size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Waiting for driver response',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            12.height,
            Center(
              child: AvatarGlow(
                glowColor: Colors.blue,
                endRadius: 100.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 65.0,
                  child: Image.asset(
                    'assets/images/driver_waiting.png',
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildCabDriverCard(Size size) {
    return cabBookingController.getAcceptedDriversModel!.drivers.isNotEmpty
        ? Container(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Arriving time  9:25 AM',
                      style: TextStyle(color: Colors.white),
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
                          color: const Color.fromARGB(255, 58, 47, 47)
                              .withOpacity(0.6),
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
                            cabBookingController.selectedVehicle,
                            style: boldTextStyle(),
                          ),
                          Text(
                            cabBookingController
                                .getAcceptedDriversModel!
                                .drivers[cabBookingController
                                    .currentCabDriverIndex.value]
                                .vehicleNo,
                            style: boldTextStyle(),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          endIndent: 8,
                          indent: 8,
                          thickness: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: FadeInImage(
                                  placeholder:
                                      const AssetImage('assets/icons/user.png'),
                                  image: NetworkImage(cabBookingController
                                      .getAcceptedDriversModel!
                                      .drivers[cabBookingController
                                          .currentCabDriverIndex.value]
                                      .profile),
                                ).image,
                              ),
                              12.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    cabBookingController
                                        .getAcceptedDriversModel!
                                        .drivers[cabBookingController
                                            .currentCabDriverIndex.value]
                                        .name,
                                    style: boldTextStyle(size: 18),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_outlined,
                                        color: Colors.yellow,
                                      ),
                                      Text(
                                        cabBookingController
                                            .getAcceptedDriversModel!
                                            .drivers[cabBookingController
                                                .currentCabDriverIndex.value]
                                            .rating,
                                        style: normalsize,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "₹ ${cabBookingController.amountToPay}",
                            style: boldTextStyle(size: 20),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          endIndent: 8,
                          indent: 8,
                          thickness: 2,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.my_location,
                                size: 20,
                              ),
                              10.width,
                              Flexible(
                                child: Text(
                                  widget.startAddress,
                                  style: normalsize,
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              10.width,
                              Flexible(
                                child: Text(
                                  widget.destAddress,
                                  style: normalsize,
                                ),
                              ),
                            ],
                          ),
                          10.height,
                          const Text(
                            'Parking and Waiting Charges Extra fare will we charged if journey above 25.2 km',
                            style: TextStyle(fontSize: 12),
                          ),
                          15.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width / 2.5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: () {
                                    cabBookingController
                                        .updateCurrentDriverIndex();
                                  },
                                  child: const Text("Reject"),
                                ),
                              ),
                              SizedBox(
                                width: size.width / 2.5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    cabBookingController.selectedDriverId =
                                        cabBookingController
                                            .getAcceptedDriversModel!
                                            .drivers[cabBookingController
                                                .currentCabDriverIndex.value]
                                            .id;

                                    var acceptDriverModel = AcceptDriverModel(
                                        locationController
                                            .departureLatLong.value!,
                                        locationController
                                            .destinationLatLong.value!,
                                        widget.distance,
                                        Constant.currentBooking,
                                        widget.startAddress,
                                        widget.destAddress,
                                        cabBookingController.amountToPay,
                                        cabBookingController.selectedVehicle,
                                        cabBookingController.selectedDriverId);

                                    PaymentScreen(
                                      isAdvance: false,
                                      amount: cabBookingController.amountToPay,
                                      acceptDriverModel: acceptDriverModel,
                                      pickupDate:
                                          cabBookingController.pickupDate.value,
                                      pickupTime:
                                          cabBookingController.pickupTime.value,
                                    ).launch(context,
                                        isNewTask: true,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade);
                                  },
                                  child: const Text("Accept"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                10.height
              ],
            ),
          )
        : Container(
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/404.png',
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: Text(
                        'No Drivers found',
                        style: boldTextStyle(size: 22),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  child: SizedBox(
                    height: 42,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(DashboardScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  setIcons() async {
    final locationController = Get.put(LocationController());
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/pickup.png")
        .then((value) {
      locationController.departureIcon.value = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/dropoff.png")
        .then((value) {
      locationController.destinationIcon.value = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/ic_taxi.png")
        .then((value) {
      locationController.taxiIcon.value = value;
    });

    if (locationController.departureLatLong.value!.latitude <=
        locationController.destinationLatLong.value!.latitude) {
      sLat = locationController.departureLatLong.value!.latitude;
      nLat = locationController.destinationLatLong.value!.latitude;
    } else {
      nLat = locationController.departureLatLong.value!.latitude;
      sLat = locationController.destinationLatLong.value!.latitude;
    }
    if (locationController.departureLatLong.value!.longitude <=
        locationController.destinationLatLong.value!.longitude) {
      sLon = locationController.departureLatLong.value!.longitude;
      nLon = locationController.destinationLatLong.value!.longitude;
    } else {
      nLon = locationController.departureLatLong.value!.longitude;
      sLon = locationController.destinationLatLong.value!.longitude;
    }
    _controller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(nLat, nLon),
          southwest: LatLng(sLat, sLon),
        ),
        20));
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PaymentScreen(
                isAdvance: false,
                amount: cabBookingController.amountToPay,
                pickupDate: '',
                pickupTime: '',
              )),
    );
    if (!mounted) return;
    setState(() {
      if (data == true) {
        debugPrint('Returned success');
        /*cabBookingController.acceptDriver(
            locationController.departureLatLong.value!.latitude.toString(),
            locationController.departureLatLong.value!.longitude.toString(),
            locationController.destinationLatLong.value!.latitude.toString(),
            locationController.destinationLatLong.value!.longitude.toString(),
            widget.distance, 'current_booking', widget.startAddress, widget.destAddress);*/
      }
    });
  }

  // Move camera function
  void moveCameraToRoute() {
    if (locationController.departureLatLong.value!.latitude <=
        locationController.destinationLatLong.value!.latitude) {
      sLat = locationController.departureLatLong.value!.latitude;
      nLat = locationController.destinationLatLong.value!.latitude;
    } else {
      nLat = locationController.departureLatLong.value!.latitude;
      sLat = locationController.destinationLatLong.value!.latitude;
    }
    if (locationController.departureLatLong.value!.longitude <=
        locationController.destinationLatLong.value!.longitude) {
      sLon = locationController.departureLatLong.value!.longitude;
      nLon = locationController.destinationLatLong.value!.longitude;
    } else {
      nLon = locationController.departureLatLong.value!.longitude;
      sLon = locationController.destinationLatLong.value!.longitude;
    }
    _controller!.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(nLat, nLon),
          southwest: LatLng(sLat, sLon),
        ),
        10,
      ),
    );
  }
}
