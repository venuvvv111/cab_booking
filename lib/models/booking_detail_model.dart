// To parse this JSON data, do
//
//     final bookingDetailModel = bookingDetailModelFromJson(jsonString);

import 'dart:convert';

BookingDetailModel bookingDetailModelFromJson(String str) => BookingDetailModel.fromJson(json.decode(str));

String bookingDetailModelToJson(BookingDetailModel data) => json.encode(data.toJson());

class BookingDetailModel {
  String status;
  String message;
  Data data;
  User user;
  Driver driver;

  BookingDetailModel({
    required this.status,
    required this.message,
    required this.data,
    required this.user,
    required this.driver,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) => BookingDetailModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    user: User.fromJson(json["user"]),
    driver: Driver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
    "user": user.toJson(),
    "driver": driver.toJson(),
  };
}

class Data {
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
  String dateTime;
  DateTime createdAt;
  dynamic updatedAt;

  Data({
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
    required this.dateTime,
    required this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    dateTime: json["date_time"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
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
    "date_time": dateTime,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
  };
}

class Driver {
  String id;
  String uniqueId;
  String name;
  String email;
  String userType;
  String panNumber;
  String mobile;
  String code;
  String secondNumber;
  String state;
  String city;
  String location;
  String lat;
  String lng;
  String dlNumber;
  String rememberToken;
  String aadharNumber;
  String recharge;
  String bookingLimit;
  String requestLimit;
  String status;
  String isApproved;
  DateTime createdAt;
  String updatedAt;
  String pinCode;
  String address;
  String firebaseId;
  String token;
  String password;
  String monthlysalary;
  String fcmToken;
  String gender;
  String dob;
  String profileImage;
  String activeStatus;
  String rating;
  String perHrs;
  String perKm;
  String hold;
  String vehicleType;
  String vehicleNum;
  String dateOfJoining;
  String referralCode;
  String walletBalance;

  Driver({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.userType,
    required this.panNumber,
    required this.mobile,
    required this.code,
    required this.secondNumber,
    required this.state,
    required this.city,
    required this.location,
    required this.lat,
    required this.lng,
    required this.dlNumber,
    required this.rememberToken,
    required this.aadharNumber,
    required this.recharge,
    required this.bookingLimit,
    required this.requestLimit,
    required this.status,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
    required this.pinCode,
    required this.address,
    required this.firebaseId,
    required this.token,
    required this.password,
    required this.monthlysalary,
    required this.fcmToken,
    required this.gender,
    required this.dob,
    required this.profileImage,
    required this.vehicleNum,
    required this.vehicleType,
    required this.activeStatus,
    required this.rating,
    required this.perHrs,
    required this.perKm,
    required this.hold,
    required this.dateOfJoining,
    required this.referralCode,
    required this.walletBalance,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    uniqueId: json["unique_id"],
    name: json["name"],
    email: json["email"],
    userType: json["user_type"],
    panNumber: json["pan_number"],
    mobile: json["mobile"],
    code: json["code"],
    secondNumber: json["second_number"],
    state: json["state"],
    city: json["city"],
    location: json["location"],
    lat: json["lat"],
    lng: json["lng"],
    dlNumber: json["dl_number"],
    rememberToken: json["remember_token"],
    aadharNumber: json["aadhar_number"],
    recharge: json["recharge"],
    bookingLimit: json["booking_limit"],
    requestLimit: json["request_limit"],
    status: json["status"],
    isApproved: json["is_approved"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    pinCode: json["pin_code"],
    address: json["address"],
    firebaseId: json["firebase_id"],
    token: json["token"],
    vehicleType: json["vehicle_type"] ?? "",
    vehicleNum: json["vehicle_num"] ?? "",
    password: json["password"],
    monthlysalary: json["monthlysalary"],
    fcmToken: json["FCM_Token"],
    gender: json["gender"],
    dob: json["dob"],
    profileImage: json["profile_image"],
    activeStatus: json["active_status"],
    rating: json["rating"],
    perHrs: json["per_hrs"],
    perKm: json["per_km"],
    hold: json["hold"],
    dateOfJoining: json["date_of_joining"],
    referralCode: json["referral_code"],
    walletBalance: json["wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "name": name,
    "email": email,
    "user_type": userType,
    "pan_number": panNumber,
    "mobile": mobile,
    "code": code,
    "second_number": secondNumber,
    "state": state,
    "city": city,
    "location": location,
    "lat": lat,
    "lng": lng,
    "dl_number": dlNumber,
    "remember_token": rememberToken,
    "aadhar_number": aadharNumber,
    "recharge": recharge,
    "booking_limit": bookingLimit,
    "request_limit": requestLimit,
    "status": status,
    "is_approved": isApproved,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "pin_code": pinCode,
    "address": address,
    "firebase_id": firebaseId,
    "token": token,
    "password": password,
    "monthlysalary": monthlysalary,
    "FCM_Token": fcmToken,
    "gender": gender,
    "dob": dob,
    "profile_image": profileImage,
    "active_status": activeStatus,
    "rating": rating,
    "per_hrs": perHrs,
    "per_km": perKm,
    "hold": hold,
    "vehicle_num": vehicleNum,
    "vehicle_type": vehicleType,
    "date_of_joining": dateOfJoining,
    "referral_code": referralCode,
    "wallet_balance": walletBalance,
  };
}

class User {
  String id;
  String uniqueId;
  String googleId;
  String name;
  String email;
  String profileImage;
  String locale;
  String user;
  String userType;
  String mobileNumber;
  String firebaseId;
  String token;
  String gender;
  String dob;
  String lat;
  String lng;
  String fcmToken;
  String walletBalance;

  User({
    required this.id,
    required this.uniqueId,
    required this.googleId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.locale,
    required this.user,
    required this.userType,
    required this.mobileNumber,
    required this.firebaseId,
    required this.token,
    required this.gender,
    required this.dob,
    required this.lat,
    required this.lng,
    required this.fcmToken,
    required this.walletBalance,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    uniqueId: json["unique_id"],
    googleId: json["google_id"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    locale: json["locale"],
    user: json["user"],
    userType: json["user_type"],
    mobileNumber: json["mobile_number"],
    firebaseId: json["firebase_id"],
    token: json["token"],
    gender: json["gender"],
    dob: json["dob"],
    lat: json["lat"],
    lng: json["lng"],
    fcmToken: json["FCM_Token"],
    walletBalance: json["wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "google_id": googleId,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "locale": locale,
    "user": user,
    "user_type": userType,
    "mobile_number": mobileNumber,
    "firebase_id": firebaseId,
    "token": token,
    "gender": gender,
    "dob": dob,
    "lat": lat,
    "lng": lng,
    "FCM_Token": fcmToken,
    "wallet_balance": walletBalance,
  };
}
