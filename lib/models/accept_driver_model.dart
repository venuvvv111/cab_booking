import 'package:google_maps_flutter/google_maps_flutter.dart';

class AcceptDriverModel {
  LatLng pickLatLng;
  LatLng dropLatLng;
  String distance;
  String bookingType;
  String departureName;
  String destinationName;
  String amountToPay;
  String selectedVehicle;
  String selectedDriverId;

  AcceptDriverModel(this.pickLatLng, this.dropLatLng,
      this.distance, this.bookingType, this.departureName, this.destinationName,
      this.amountToPay, this.selectedVehicle, this.selectedDriverId);
}