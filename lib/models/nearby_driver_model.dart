// To parse this JSON data, do
//
//     final nearbyDriversModel = nearbyDriversModelFromJson(jsonString);

import 'dart:convert';

NearbyDriversModel nearbyDriversModelFromJson(String str) => NearbyDriversModel.fromJson(json.decode(str));

String nearbyDriversModelToJson(NearbyDriversModel data) => json.encode(data.toJson());

class NearbyDriversModel {
  String status;
  String message;
  List<Datum> data;

  NearbyDriversModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NearbyDriversModel.fromJson(Map<String, dynamic> json) => NearbyDriversModel(
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
  String name;
  String lat;
  String lng;
  String vehicleType;

  Datum({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.vehicleType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    lat: json["lat"],
    lng: json["lng"],
    vehicleType: json["vehicle_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lat": lat,
    "lng": lng,
    "vehicle_type": vehicleType,
  };
}
