import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  String status;
  String message;
  Data data;

  DashboardModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<String> offers;
  String bankOffer;

  Data({
    required this.offers,
    required this.bankOffer,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    offers: List<String>.from(json["offers"].map((x) => x)),
    bankOffer: json["bankOffer"],
  );

  Map<String, dynamic> toJson() => {
    "offers": List<dynamic>.from(offers.map((x) => x)),
    "bankOffer": bankOffer,
  };
}
