// To parse this JSON data, do
//
//     final bookedRideModel = bookedRideModelFromJson(jsonString);

import 'dart:convert';

BookedRideModel bookedRideModelFromJson(String str) => BookedRideModel.fromJson(json.decode(str));

String bookedRideModelToJson(BookedRideModel data) => json.encode(data.toJson());

class BookedRideModel {
  String status;
  String message;
  RideDetails rideDetails;
  DriverDetails driverDetails;

  BookedRideModel({
    required this.status,
    required this.message,
    required this.rideDetails,
    required this.driverDetails,
  });

  factory BookedRideModel.fromJson(Map<String, dynamic> json) => BookedRideModel(
    status: json["status"],
    message: json["message"],
    rideDetails: RideDetails.fromJson(json["ride_details"]),
    driverDetails: DriverDetails.fromJson(json["driver_details"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ride_details": rideDetails.toJson(),
    "driver_details": driverDetails.toJson(),
  };
}

class DriverDetails {
  String id;
  String name;
  String mobileNum;
  String profilePic;
  String vehicleType;
  String vehicleNum;
  String lat;
  String lng;

  DriverDetails({
    required this.id,
    required this.name,
    required this.mobileNum,
    required this.profilePic,
    required this.vehicleType,
    required this.vehicleNum,
    required this.lat,
    required this.lng
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
    id: json["id"],
    name: json["name"],
    mobileNum: json["mobile_num"],
    profilePic: json["profile_pic"],
    vehicleType: json["vehicle_type"] ?? "",
    vehicleNum: json["vehicle_num"],
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_num": mobileNum,
    "profile_pic": profilePic,
    "vehicle_type": vehicleType,
    "vehicle_num": vehicleNum,
    "lat": lat,
    "lng": lng
  };
}

class RideDetails {
  int bookingId;
  String fromlatLocation;
  String fromlngLocation;
  String tolatLocation;
  String tolngLocation;
  String departure;
  String destination;
  String bookingType;
  String rideStatus;
  String otp;

  RideDetails({
    required this.bookingId,
    required this.fromlatLocation,
    required this.fromlngLocation,
    required this.tolatLocation,
    required this.tolngLocation,
    required this.departure,
    required this.destination,
    required this.bookingType,
    required this.rideStatus,
    required this.otp,
  });

  factory RideDetails.fromJson(Map<String, dynamic> json) => RideDetails(
    bookingId: json["booking_id"],
    fromlatLocation: json["fromlat_location"],
    fromlngLocation: json["fromlng_location"],
    tolatLocation: json["tolat_location"],
    tolngLocation: json["tolng_location"],
    departure: json["departure"],
    destination: json["destination"],
    bookingType: json["booking_type"],
    rideStatus: json["ride_status"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "fromlat_location": fromlatLocation,
    "fromlng_location": fromlngLocation,
    "tolat_location": tolatLocation,
    "tolng_location": tolngLocation,
    "departure": departure,
    "destination": destination,
    "booking_type": bookingType,
    "ride_status": rideStatus,
    "otp": otp,
  };
}
