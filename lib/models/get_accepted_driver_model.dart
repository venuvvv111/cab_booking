// To parse this JSON data, do
//
//     final getAcceptedDriversModel = getAcceptedDriversModelFromJson(jsonString);

import 'dart:convert';

GetAcceptedDriversModel getAcceptedDriversModelFromJson(String str) => GetAcceptedDriversModel.fromJson(json.decode(str));

String getAcceptedDriversModelToJson(GetAcceptedDriversModel data) => json.encode(data.toJson());

class GetAcceptedDriversModel {
  String status;
  String message;
  List<Driver> drivers;

  GetAcceptedDriversModel({
    required this.status,
    required this.message,
    required this.drivers,
  });

  factory GetAcceptedDriversModel.fromJson(Map<String, dynamic> json) => GetAcceptedDriversModel(
    status: json["status"],
    message: json["message"],
    drivers: List<Driver>.from(json["drivers"].map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "drivers": List<dynamic>.from(drivers.map((x) => x.toJson())),
  };
}

class Driver {
  String id;
  String name;
  String profile;
  String rating;
  String vehicleNo;

  Driver({
    required this.id,
    required this.name,
    required this.profile,
    required this.rating,
    required this.vehicleNo,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    name: json["name"],
    profile: json["profile"],
    rating: json["rating"],
    vehicleNo: json["vehicle_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile": profile,
    "rating": rating,
    "vehicle_no": vehicleNo,
  };
}
