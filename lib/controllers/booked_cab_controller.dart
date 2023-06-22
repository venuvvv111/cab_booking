import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:figgocabs/models/booked_ride_model.dart';
import 'package:figgocabs/models/booking_detail_model.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:figgocabs/screens/testScreen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:figgocabs/utility/url_helper.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class BookedCabController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var nLat, nLon, sLat, sLon;

  Position? currentPosition;
  final polyLines = <PolylineId, Polyline>{}.obs;
  final polylinePoints = PolylinePoints().obs;
  final RxMap<String, Marker> markers = RxMap<String, Marker>();

  final destinationIcon = Rx<BitmapDescriptor?>(null);
  final taxiIcon = Rx<BitmapDescriptor?>(null);

  final departureLatLong = Rx<LatLng?>(null);
  final destinationLatLong = Rx<LatLng?>(null);
  final driverLatLng = Rx<LatLng?>(null);
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStreamSubscription;

  BookedRideModel? bookedRideModel;
  BookingDetailModel? bookingDetailModel;

  @override
  void onInit() {
    super.onInit();
    setIcons();
    _getUserCurrentLocation();
  }

  Future<void> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
        debugPrint(error.toString());

    });

    currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> acceptDriver(String pickLat, String pickLng, String dropLat, String dropLng,
      String distance, String bookingType, String departureName, String destinationName,
      String amountToPay, String selectedVehicle, String selectedDriverId, String paymentMode, 
      String pickupDate, String pickupTime, String transactionID) async {
    isLoading(true);

    debugPrint('Hitting accept driver API');

    Map<String, String> body = {
      'user_id':box.read(Constant.id),
      'fromlat_location':pickLat,
      'fromlng_location':pickLng,
      'tolat_location':dropLat,
      'tolng_location':dropLng,
      'distance': distance,
      'amount':amountToPay,
      'vehicle_type': selectedVehicle,
      'booking_type': bookingType,
      'transaction_id':transactionID,
      'status':'pending',
      'date_time': bookingType == Constant.currentBooking ? await getCurrentDateAndTime() : '$pickupDate $pickupTime',
      'payment_type': paymentMode,
      'toname_location':destinationName,
      'fromname_location':departureName,
      'driver_id': selectedDriverId
    };

    var response = await http
        .post(Uri.parse(Constant.baseUrl + UrlHelper.acceptDriver), headers: {
      "token" : box.read(Constant.token)
    }, body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if(json['status'] == "success"){
        bookedRideModel = bookedRideModelFromJson(response.body);
        driverLatLng(LatLng(bookedRideModel!.driverDetails.lat.toDouble(), bookedRideModel!.driverDetails.lng.toDouble()));
        departureLatLong(LatLng(bookedRideModel!.rideDetails.fromlatLocation.toDouble(), bookedRideModel!.rideDetails.fromlngLocation.toDouble()));
        destinationLatLong(LatLng(bookedRideModel!.rideDetails.tolatLocation.toDouble(), bookedRideModel!.rideDetails.tolngLocation.toDouble()));
        setDestinationMarker(departureLatLong.value!);
        setDriverMarker(driverLatLng.value!);
        getDriverToUserDirections();
      }
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

  setDriverMarker(LatLng position) {
    markers.remove('driver');
    markers['driver'] = Marker(
      markerId: const MarkerId('driver'),
      position: position,
      icon: taxiIcon.value!,
    );
      mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: position,
          zoom: 14)));
  }
  
  setDestinationMarker(LatLng destination) {
    markers.remove('Destination');
    markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      position: destination,
      icon: destinationIcon.value!,
    );
  }

  getUserToDestinationDirections() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
      List<LatLng> polylineCoordinates = [];
      currentPosition = position;

      PolylineResult result = await polylinePoints.value.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey.toString(),
        PointLatLng(position.latitude, position.longitude),
        PointLatLng(destinationLatLong.value!.latitude, destinationLatLong.value!.longitude),
        travelMode: TravelMode.driving,
      );

      setDriverMarker(LatLng(position.latitude, position.longitude));
      setDestinationMarker(destinationLatLong.value!);

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      addUserToDestinationPolyLine(polylineCoordinates);
    });

  }

  addUserToDestinationPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: primaryColor,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    polyLines[id] = polyline;
    mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList([
              LatLng(currentPosition!.latitude, currentPosition!.longitude),
              destinationLatLong.value!
            ]),
            50));
    update();
  }

  getDriverToUserDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result =
    await polylinePoints.value.getRouteBetweenCoordinates(
      Constant.kGoogleApiKey.toString(),
      PointLatLng(driverLatLng.value!.latitude,
          driverLatLng.value!.longitude),
      PointLatLng(departureLatLong.value!.latitude,
          departureLatLong.value!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    addDriverToUserPolyLine(polylineCoordinates);
  }

  addDriverToUserPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: primaryColor,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    polyLines[id] = polyline;
    mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList([
              driverLatLng.value!,
              destinationLatLong.value!
            ]),
            50));
    update();
  }

  setIcons() async {
    await getBytesFromAsset('assets/icons/car_marker.png', 100).then((onValue) {
      taxiIcon.value = BitmapDescriptor.fromBytes(onValue);
    });

    await getBytesFromAsset('assets/icons/dest_pin.png', 80).then((onValue) {
      destinationIcon.value = BitmapDescriptor.fromBytes(onValue);
    });

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

  Future<void> cancelRide(String bookingID) async {
    isLoading(true);

    Map<String, String> body = {
      "ride_id": bookingID,
    };

    var response = await http.post(
        Uri.parse(Constant.baseUrl + UrlHelper.cancelRide),
        headers: {"token": box.read(Constant.token)},
        body: body);

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json["status"] == "Success"){
        Get.offAll(DashboardScreen());
      }
    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

  Future<void> fetchBookingInfo(String bookingID) async {
    isLoading(true);

    debugPrint("id is $bookingID");
    var response = await http.get(
        Uri.parse("${Constant.baseUrl}${UrlHelper.getBookingDetail}?booking_id=$bookingID"),
        headers: {"token": box.read(Constant.token)});

    debugPrint('response is ${response.statusCode} && ${response.body}');
    if (response.statusCode == 200) {
      bookingDetailModel = bookingDetailModelFromJson(response.body);
      driverLatLng(LatLng(bookingDetailModel!.driver.lat.toDouble(), bookingDetailModel!.driver.lng.toDouble()));
      departureLatLong(LatLng(bookingDetailModel!.data.fromlatLocation.toDouble(), bookingDetailModel!.data.fromlngLocation.toDouble()));
      destinationLatLong(LatLng(bookingDetailModel!.data.tolatLocation.toDouble(), bookingDetailModel!.data.tolngLocation.toDouble()));

      if(bookingDetailModel!.data.status == "3"){
        getUserToDestinationDirections();
      }else{
        getDriverToUserDirections();
        setDestinationMarker(departureLatLong.value!);
        setDriverMarker(driverLatLng.value!);
      }

    } else {
      Get.showSnackbar(errorSnackBar(message: '${response.statusCode} : Something went wrong'));
    }

    isLoading(false);
  }

  updatePolyLineToDestination(){
    polyLines.clear();
    getUserToDestinationDirections();
  }
}