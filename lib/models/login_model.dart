import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
  Data({
    required this.id,
    required this.googleId,
    required this.name,
    required this.email,
    required this.uniqueId,
    required this.profileImage,
    required this.locale,
    required this.user,
    required this.userType,
    required this.mobileNumber,
    required this.firebaseId,
    required this.token,
  });

  String id;
  String googleId;
  String uniqueId;
  String name;
  String email;
  String profileImage;
  String locale;
  String user;
  String userType;
  String mobileNumber;
  String firebaseId;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    googleId: json["google_id"],
    name: json["name"],
    email: json["email"],
    uniqueId: json["unique_id"],
    profileImage: json["profile_image"],
    locale: json["locale"],
    user: json["user"],
    userType: json["user_type"],
    mobileNumber: json["mobile_number"],
    firebaseId: json["firebase_id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "google_id": googleId,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "locale": locale,
    "unique_id": uniqueId,
    "user": user,
    "user_type": userType,
    "mobile_number": mobileNumber,
    "firebase_id": firebaseId,
    "token": token,
  };
}