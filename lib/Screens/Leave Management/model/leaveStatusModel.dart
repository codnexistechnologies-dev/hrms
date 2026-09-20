// To parse this JSON data, do
//
//     final leaveStatusModel = leaveStatusModelFromJson(jsonString);

import 'dart:convert';

LeaveStatusModel leaveStatusModelFromJson(String str) =>
    LeaveStatusModel.fromJson(json.decode(str));

String leaveStatusModelToJson(LeaveStatusModel data) =>
    json.encode(data.toJson());

class LeaveStatusModel {
  List<Datum>? data;

  LeaveStatusModel({
    this.data,
  });

  factory LeaveStatusModel.fromJson(Map<String, dynamic> json) =>
      LeaveStatusModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic levyear;
  dynamic emPCode;
  dynamic emPName;
  dynamic atdate;
  dynamic lvtype;
  dynamic lvdesc;
  dynamic lvdays;
  dynamic status;

  Datum({
    this.levyear,
    this.emPCode,
    this.emPName,
    this.atdate,
    this.lvtype,
    this.lvdesc,
    this.lvdays,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        levyear: json["levyear"],
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        atdate: json["atdate"],
        lvtype: json["lvtype"],
        lvdesc: json["lvdesc"],
        lvdays: json["lvdays"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "levyear": levyear,
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "atdate": atdate,
        "lvtype": lvtype,
        "lvdesc": lvdesc,
        "lvdays": lvdays,
        "status": status,
      };
}
