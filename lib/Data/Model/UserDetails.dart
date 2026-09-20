// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  List<Datum> data;

  UserModel({
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String? empCode;
  String? empName;
  String? emailId;
  String? mobileno;
  String? compCode;
  String? compName;
  String? locCode;
  String? locName;
  String? longitude;
  String? latitude;
  int? ltype;

  Datum({
    this.empCode,
    this.empName,
    this.emailId,
    this.mobileno,
    this.compCode,
    this.compName,
    this.locCode,
    this.locName,
    this.longitude,
    this.latitude,
    this.ltype,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        empCode: json["EMP_CODE"],
        empName: json["EMP_NAME"],
        emailId: json["EmailId"],
        mobileno: json["MOBILENO"],
        compCode: json["COMP_CODE"],
        compName: json["COMP_NAME"],
        locCode: json["LOC_CODE"],
        locName: json["LOC_NAME"],
        longitude: json["LONGITUDE"],
        latitude: json["LATITUDE"],
        ltype: json["LTYPE"],
      );

  Map<String, dynamic> toJson() => {
        "EMP_CODE": empCode,
        "EMP_NAME": empName,
        "EmailId": emailId,
        "MOBILENO": mobileno,
        "COMP_CODE": compCode,
        "COMP_NAME": compName,
        "LOC_CODE": locCode,
        "LOC_NAME": locName,
        "LONGITUDE": longitude,
        "LATITUDE": latitude,
        "LTYPE": ltype,
      };
}
