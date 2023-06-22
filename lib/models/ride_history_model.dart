// To parse this JSON data, do
//
//     final rideHistoryModel = rideHistoryModelFromJson(jsonString);

import 'dart:convert';

RideHistoryModel rideHistoryModelFromJson(String str) => RideHistoryModel.fromJson(json.decode(str));

String rideHistoryModelToJson(RideHistoryModel data) => json.encode(data.toJson());

class RideHistoryModel {
  String status;
  String message;
  List<Datum> data;

  RideHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) => RideHistoryModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String bookingId;
  String userId;
  String driverId;
  String toLocation;
  String tolatLocation;
  String tolngLocation;
  String tonameLocation;
  String fromLocation;
  String fromlatLocation;
  String fromlngLocation;
  String fromnameLocation;
  String vehicleType;
  String bookingType;
  String otp;
  String transactionId;
  String paymentType;
  String status;
  String amount;
  String dateTime;
  String createdAt;
  String? updatedAt;

  Datum({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.driverId,
    required this.toLocation,
    required this.tolatLocation,
    required this.tolngLocation,
    required this.tonameLocation,
    required this.fromLocation,
    required this.fromlatLocation,
    required this.fromlngLocation,
    required this.fromnameLocation,
    required this.vehicleType,
    required this.bookingType,
    required this.otp,
    required this.transactionId,
    required this.paymentType,
    required this.status,
    required this.amount,
    required this.dateTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    bookingId: json["booking_id"],
    userId: json["user_id"],
    driverId: json["driver_id"],
    toLocation: json["to_location"],
    tolatLocation: json["tolat_location"],
    tolngLocation: json["tolng_location"],
    tonameLocation: json["toname_location"],
    fromLocation: json["from_location"],
    fromlatLocation: json["fromlat_location"],
    fromlngLocation: json["fromlng_location"],
    fromnameLocation: json["fromname_location"],
    vehicleType: json["vehicle_type"],
    bookingType: json["booking_type"],
    otp: json["otp"],
    transactionId: json["transaction_id"],
    paymentType: json["payment_type"],
    status: json["status"],
    amount: json["amount"],
    dateTime: json["date_time"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "user_id": userId,
    "driver_id": driverId,
    "to_location": toLocation,
    "tolat_location": tolatLocation,
    "tolng_location": tolngLocation,
    "toname_location": tonameLocation,
    "from_location": fromLocation,
    "fromlat_location": fromlatLocation,
    "fromlng_location": fromlngLocation,
    "fromname_location": fromnameLocation,
    "vehicle_type": vehicleType,
    "booking_type": bookingType,
    "otp": otp,
    "transaction_id": transactionId,
    "payment_type": paymentType,
    "status": status,
    "amount": amount,
    "date_time": dateTime,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}