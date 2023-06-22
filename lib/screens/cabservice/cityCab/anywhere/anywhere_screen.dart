// ignore_for_file: unused_local_variable, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';
import 'dart:ui' as ui;

import 'package:figgocabs/controllers/location_controller.dart';
import 'package:figgocabs/screens/cabservice/common/advance_time_picker.dart';
import 'package:figgocabs/screens/cabservice/cityCab/anywhere/current_booking_screen.dart';
import 'package:figgocabs/screens/common/select_location.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class AnywhereScreen extends StatefulWidget {
  const AnywhereScreen({super.key});

  @override
  State<AnywhereScreen> createState() => _AnywhereScreenState();
}

class _AnywhereScreenState extends State<AnywhereScreen> {
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  final controller = Get.put(LocationController());

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  GoogleMapController? _controller;
  Timer? timer;
  String _mapStyle = "";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    controller.fetchData();
    timer = Timer.periodic(
        const Duration(seconds: 30), (Timer t) => controller.fetchData());
    setIcons();
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
    controller.polyLines.clear();
    controller.departureLatLong.value = null;
    controller.destinationLatLong.value = null;
    controller.markers.clear();
    if (timer != null){
      timer!.cancel();
      timer = null;
    }
  }

  var nLat, nLon, sLat, sLon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => SizedBox(
                height: size.height,
                width: size.width,
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  padding: const EdgeInsets.only(bottom: 150),
                  myLocationButtonEnabled: false,
                  initialCameraPosition: controller.kInitialPosition.value,
                  onMapCreated: (GoogleMapController mapController) async {
                    _controller = mapController;
                    mapController.setMapStyle(_mapStyle);
                    if(controller.departureLatLong.value != null && controller.destinationLatLong.value != null){
                      final bounds = LatLngBounds(
                        southwest: LatLng(
                            controller.departureLatLong.value!.latitude,
                            controller.departureLatLong.value!.longitude),
                        northeast: LatLng(
                            controller.destinationLatLong.value!.latitude,
                            controller.destinationLatLong.value!.longitude),
                      );
                      final padding = EdgeInsets.only(
                        top: 50.0,
                        bottom: 50.0,
                        left: 50.0,
                        right: 50.0,
                      );
                      if (controller.departureLatLong.value!.latitude <=
                          controller.destinationLatLong.value!.latitude) {
                        sLat = controller.departureLatLong.value!.latitude;
                        nLat = controller.destinationLatLong.value!.latitude;
                      } else {
                        nLat = controller.departureLatLong.value!.latitude;
                        sLat = controller.destinationLatLong.value!.latitude;
                      }
                      if (controller.departureLatLong.value!.longitude <=
                          controller.destinationLatLong.value!.longitude) {
                        sLon = controller.departureLatLong.value!.longitude;
                        nLon = controller.destinationLatLong.value!.longitude;
                      } else {
                        nLon = controller.departureLatLong.value!.longitude;
                        sLon = controller.destinationLatLong.value!.longitude;
                      }
                      _controller!.animateCamera(
                        CameraUpdate.newLatLngBounds(
                            LatLngBounds(
                              northeast: LatLng(nLat, nLon),
                              southwest: LatLng(sLat, sLon),
                            ),
                            15),
                      );
                    }
                  },
                  polylines: Set<Polyline>.of(controller.polyLines.values),
                  myLocationEnabled: true,
                  markers: controller.markers.values.toSet(),
                ),
              )),
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
          Positioned(
              bottom: 0, left: 0, right: 0, child: buildBookingSheet(size)),
        ],
      ),
    );
  }

  Widget buildBookingSheet(Size size) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          TextFormField(
              controller: _startSearchFieldController,
              readOnly: true,
              maxLines: 1,
              onTap: () {
                _navigateAndFetchDeparture(context);
              },
              decoration: inputDecoration(context,
                  hintText: "From", prefixIcon: Icons.location_on_outlined)),
          12.height,
          TextFormField(
              controller: _endSearchFieldController,
              readOnly: true,
              onTap: () {
                _navigateAndFetchDestination(context);
              },
              decoration: inputDecoration(context,
                  hintText: "To", prefixIcon: Icons.my_location_outlined)),
          12.height,
          Visibility(
            visible: _startSearchFieldController.text.isNotEmpty &&
                _endSearchFieldController.text.isNotEmpty,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${controller.distance.value.ceil()} KM',
                        style: primaryTextStyle(),
                      ),
                      Text(
                        'Distance',
                        style: secondaryTextStyle(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        controller.duration.value,
                        style: primaryTextStyle(),
                      ),
                      Text(
                        'Reach Within',
                        style: secondaryTextStyle(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          12.height,
          SizedBox(
              height: 46,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(!controller.disableButtons.value){
                    if (controller.departureLatLong.value == null ||
                        _startSearchFieldController.text.isEmpty) {
                      toast('Select departure location');
                      return;
                    }

                    if (controller.destinationLatLong.value == null ||
                        _endSearchFieldController.text.isEmpty) {
                      toast('Select destination location');
                      return;
                    }

                    CurrentBookingScreen(
                      startAddress: _startSearchFieldController.text,
                      destAddress: _endSearchFieldController.text,
                      distance: controller.distance.value.toString(),
                      vehicleTypes: controller.vehicle_types,
                      pickupDate: DateTime.now().toString(),
                      pickupTime: TimeOfDay.now().toString(),
                    ).launch(context,
                        isNewTask: false,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  }else{
                    Get.showSnackbar(defaultSnackBar(message: 'Use outstation if travel distance is greater than 40KM'));
                  }

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: primaryColor,
                ),
                child: const Text(
                  'Current',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
          12.height,
          SizedBox(
              height: 46,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(!controller.disableButtons.value){
                    if (controller.departureLatLong.value == null ||
                        _startSearchFieldController.text.isEmpty) {
                      toast('Select departure location');
                      return;
                    }

                    if (controller.destinationLatLong.value == null ||
                        _endSearchFieldController.text.isEmpty) {
                      toast('Select destination location');
                      return;
                    }

                    AdvanceDateTimePicker(
                      bookingType: Constant.cityRide,
                      startAddress: _startSearchFieldController.text,
                      destAddress: _endSearchFieldController.text,
                      distance: controller.distance.value.toString(),
                      vehicleType: controller.vehicle_types,
                    ).launch(context,
                        isNewTask: false,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  }else{
                    Get.showSnackbar(defaultSnackBar(message: 'Use outstation if travel distance is greater than 40KM'));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: primaryColor,
                ),
                child: const Text(
                  'Advance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
        ],
      ),
    );
  }

  setDepartureMarker(LatLng departure) {
    controller.markers.remove("Departure");
    controller.markers['Departure'] = Marker(
      markerId: const MarkerId('Departure'),
      infoWindow: InfoWindow(title: _startSearchFieldController.text),
      position: departure,
      icon: controller.departureIcon.value!,
    );
    controller.departureLatLong.value = departure;
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(departure.latitude, departure.longitude), zoom: 18)));

    if (controller.departureLatLong.value != null &&
        controller.destinationLatLong.value != null) {
      getExtraInfo();
    }

    setState(() {});
  }

  setDestinationMarker(LatLng destination) {
    controller.markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: InfoWindow(title: _endSearchFieldController.text),
      position: destination,
      icon: controller.destinationIcon.value!,
    );
    controller.destinationLatLong.value = destination;
    if (controller.departureLatLong.value != null) {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(controller.departureLatLong.value!.latitude,
              controller.departureLatLong.value!.longitude),
          zoom: 14)));
    }
    if (controller.departureLatLong.value != null &&
        controller.destinationLatLong.value != null) {
      getExtraInfo();
    }

    setState(() {});
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result =
        await controller.polylinePoints.value.getRouteBetweenCoordinates(
      Constant.kGoogleApiKey.toString(),
      PointLatLng(controller.departureLatLong.value!.latitude,
          controller.departureLatLong.value!.longitude),
      PointLatLng(controller.destinationLatLong.value!.latitude,
          controller.destinationLatLong.value!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    controller.polyLines[id] = polyline;
    _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(boundsFromLatLngList([
          controller.departureLatLong.value!,
          controller.destinationLatLong.value!
        ]), 50));
  }

  setIcons() async {
    await getBytesFromAsset('assets/icons/car_marker.png', 100).then((onValue) {
      controller.taxiIcon.value = BitmapDescriptor.fromBytes(onValue);
    });

    await getBytesFromAsset('assets/icons/depart_pin.png', 80).then((onValue) {
      controller.departureIcon.value = BitmapDescriptor.fromBytes(onValue);
    });

    await getBytesFromAsset('assets/icons/dest_pin.png', 80).then((onValue) {
      controller.destinationIcon.value = BitmapDescriptor.fromBytes(onValue);
    });

    setCurrentAddressAsDeparture();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> getExtraInfo() async {
    await controller
        .getDurationDistance(controller.departureLatLong.value!,
            controller.destinationLatLong.value!)
        .then((durationValue) {
        setState(() {
          controller.distance.value =
              durationValue['rows'].first['elements'].first['distance']['value'] /
                  1000.00;
          controller.duration.value =
          durationValue['rows'].first['elements'].first['duration']['text'];
        });

        if(controller.distance.value > 40) {
          controller.disableButtons(true);
          Get.showSnackbar(defaultSnackBar(message: 'Use outstation if travel distance is greater than 40KM'));
        }else{
          controller.disableButtons(false);
        }

        getDirections();
    });
  }

  Future<void> _navigateAndFetchDeparture(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
    );

    if (!mounted) return;
    setState(() {
      if (data != null) {
        _startSearchFieldController.text = data.result.name.toString();
        setDepartureMarker(LatLng(data.result.geometry!.location.lat,
            data.result.geometry!.location.lng));
      }
    });
  }

  Future<void> _navigateAndFetchDestination(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
    );

    if (!mounted) return;
    setState(() {
      if (data != null) {
        _endSearchFieldController.text = data.result.name.toString();
        setDestinationMarker(LatLng(data.result.geometry!.location.lat,
            data.result.geometry!.location.lng));
      }
    });
  }

  setCurrentAddressAsDeparture() async {
    _startSearchFieldController.text = await controller.getCurrentAddress();
    await controller.fetchCurrentLatLng();
    controller.departureLatLong.value = controller.currentLatLng;
    setDepartureMarker(controller.currentLatLng);
  }
}
