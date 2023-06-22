import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String status;
  Data data;

  ProfileModel({
    required this.status,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
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

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  };
}