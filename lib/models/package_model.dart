import 'dart:convert';

List<PackageModel> packageModelFromJson(String str) =>
    List<PackageModel>.from(json.decode(str)["data"].map((x) => PackageModel.fromJson(x)));

String packageModelToJson(List<PackageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageModel {
    PackageModel({
        required this.id,
        required this.requiredFrom,
        required this.bdeId,
        required this.employeesId,
        required this.type,
        required this.vichle,
        required this.duration,
        required this.name,
        required this.fname,
        required this.homeadd,
        required this.homepin,
        required this.dest,
        required this.destpin,
        required this.distance,
        required this.number,
        required this.state,
        required this.pickupTime,
        required this.offTime,
        required this.eid,
        required this.tripId,
        required this.price,
        required this.budget,
        required this.chequeNo,
        required this.transitionId,
        required this.status,
        required this.city,
        required this.profession,
        required this.requiredDays,
        required this.outstationShare,
        required this.firstMemberName,
        required this.secondMemberName,
        required this.thirdMemberName,
        required this.firstMemberRelation,
        required this.secondMemberRelation,
        required this.thirdMemberRelation,
        required this.firstMemberMobile,
        required this.secondMemberMobile,
        required this.thirdMemberMobile,
        required this.forthMemberName,
        required this.forthMemberRelation,
        required this.forthMemberMobile,
        required this.members,
        required this.companyName,
        required this.allotedDriver,
        required this.date,
        required this.way,
        required this.paymentToDriver,
        required this.cancelDate,
        required this.invoiceNumber,
    });

    String id;
    String requiredFrom;
    String bdeId;
    String employeesId;
    String type;
    String vichle;
    String duration;
    String name;
    String fname;
    String homeadd;
    String homepin;
    String dest;
    String destpin;
    String distance;
    String number;
    String state;
    String pickupTime;
    String offTime;
    String eid;
    String tripId;
    String price;
    String budget;
    String chequeNo;
    String transitionId;
    String status;
    String city;
    String profession;
    String requiredDays;
    String outstationShare;
    String firstMemberName;
    String secondMemberName;
    String thirdMemberName;
    String firstMemberRelation;
    String secondMemberRelation;
    String thirdMemberRelation;
    String firstMemberMobile;
    String secondMemberMobile;
    String thirdMemberMobile;
    String forthMemberName;
    String forthMemberRelation;
    String forthMemberMobile;
    String members;
    String companyName;
    String allotedDriver;
    String date;
    String way;
    String paymentToDriver;
    String cancelDate;
    String invoiceNumber;

    factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: json["id"],
        requiredFrom: json["required_from"],
        bdeId: json["BDE_id"],
        employeesId: json["employees_id"],
        type: json["type"],
        vichle: json["Vichle"],
        duration: json["duration"],
        name: json["name"],
        fname: json["fname"],
        homeadd: json["homeadd"],
        homepin: json["homepin"],
        dest: json["dest"],
        destpin: json["destpin"],
        distance: json["distance"],
        number: json["number"],
        state: json["state"],
        pickupTime: json["pickup_time"],
        offTime: json["off_time"],
        eid: json["eid"],
        tripId: json["trip_id"],
        price: json["price"],
        budget: json["budget"],
        chequeNo: json["cheque_no"],
        transitionId: json["transition_id"],
        status: json["status"],
        city: json["city"],
        profession: json["profession"],
        requiredDays: json["required_days"],
        outstationShare: json["outstation_share"],
        firstMemberName: json["first_member_name"],
        secondMemberName: json["second_member_name"],
        thirdMemberName: json["third_member_name"],
        firstMemberRelation: json["first_member_relation"],
        secondMemberRelation: json["second_member_relation"],
        thirdMemberRelation: json["third_member_relation"],
        firstMemberMobile: json["first_member_mobile"],
        secondMemberMobile: json["second_member_mobile"],
        thirdMemberMobile: json["third_member_mobile"],
        forthMemberName: json["forth_member_name"],
        forthMemberRelation: json["forth_member_relation"],
        forthMemberMobile: json["forth_member_mobile"],
        members: json["members"],
        companyName: json["company_name"],
        allotedDriver: json["alloted_driver"],
        date: json["date"],
        way: json["way"],
        paymentToDriver: json["payment_to_driver"],
        cancelDate: json["cancel_date"],
        invoiceNumber: json["invoice_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "required_from": requiredFrom,
        "BDE_id": bdeId,
        "employees_id": employeesId,
        "type": type,
        "Vichle": vichle,
        "duration": duration,
        "name": name,
        "fname": fname,
        "homeadd": homeadd,
        "homepin": homepin,
        "dest": dest,
        "destpin": destpin,
        "distance": distance,
        "number": number,
        "state": state,
        "pickup_time": pickupTime,
        "off_time": offTime,
        "eid": eid,
        "trip_id": tripId,
        "price": price,
        "budget": budget,
        "cheque_no": chequeNo,
        "transition_id": transitionId,
        "status": status,
        "city": city,
        "profession": profession,
        "required_days": requiredDays,
        "outstation_share": outstationShare,
        "first_member_name": firstMemberName,
        "second_member_name": secondMemberName,
        "third_member_name": thirdMemberName,
        "first_member_relation": firstMemberRelation,
        "second_member_relation": secondMemberRelation,
        "third_member_relation": thirdMemberRelation,
        "first_member_mobile": firstMemberMobile,
        "second_member_mobile": secondMemberMobile,
        "third_member_mobile": thirdMemberMobile,
        "forth_member_name": forthMemberName,
        "forth_member_relation": forthMemberRelation,
        "forth_member_mobile": forthMemberMobile,
        "members": members,
        "company_name": companyName,
        "alloted_driver": allotedDriver,
        "date": date,
        "way": way,
        "payment_to_driver": paymentToDriver,
        "cancel_date": cancelDate,
        "invoice_number": invoiceNumber,
    };
}
