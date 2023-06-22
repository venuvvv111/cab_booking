// To parse this JSON data, do
//
//     final fetchFareModel = fetchFareModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

FetchFareModel fetchFareModelFromJson(String str) =>
    FetchFareModel.fromJson(json.decode(str));

String fetchFareModelToJson(FetchFareModel data) => json.encode(data.toJson());

class FetchFareModel {
  String status;
  String message;
  List<Datum> data;

  FetchFareModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FetchFareModel.fromJson(Map<String, dynamic> json) => FetchFareModel(
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
  String vechicleType;
  int price;

  Datum({
    required this.vechicleType,
    required this.price,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vechicleType: json["vechicle_type"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "vechicle_type": vechicleType,
        "price": price,
      };
}
