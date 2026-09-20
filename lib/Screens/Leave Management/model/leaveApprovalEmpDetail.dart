// To parse this JSON data, do
//
//     final leaveApprovelEmpModel = leaveApprovelEmpModelFromJson(jsonString);

import 'dart:convert';

LeaveApprovalEmpModel leaveApprovalEmpModelFromJson(String str) =>
    LeaveApprovalEmpModel.fromJson(json.decode(str));

String leaveApprovalEmpModelToJson(LeaveApprovalEmpModel data) =>
    json.encode(data.toJson());

class LeaveApprovalEmpModel {
  List<Datum>? data;

  LeaveApprovalEmpModel({
    this.data,
  });

  factory LeaveApprovalEmpModel.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalEmpModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic id;
  dynamic levyear;
  dynamic emPCode;
  dynamic emPName;
  dynamic atdate;
  dynamic appdate;
  dynamic lvtype;
  dynamic lvdesc;
  dynamic lvdays;
  dynamic status;
  dynamic statuS1;
  dynamic reason;
  dynamic halFDay;
  dynamic mngrRemarks;

  Datum({
    this.id,
    this.levyear,
    this.emPCode,
    this.emPName,
    this.atdate,
    this.appdate,
    this.lvtype,
    this.lvdesc,
    this.lvdays,
    this.status,
    this.statuS1,
    this.reason,
    this.halFDay,
    this.mngrRemarks,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        levyear: json["levyear"],
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        atdate: json["atdate"],
        appdate: json["appdate"],
        lvtype: json["lvtype"],
        lvdesc: json["lvdesc"],
        lvdays: json["lvdays"],
        status: json["status"],
        statuS1: json["statuS1"],
        reason: json["reason"],
        halFDay: json["halF_DAY"],
        mngrRemarks: json["mngrRemarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "levyear": levyear,
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "atdate": atdate,
        "appdate": appdate,
        "lvtype": lvtype,
        "lvdesc": lvdesc,
        "lvdays": lvdays,
        "status": status,
        "statuS1": statuS1,
        "reason": reason,
        "halF_DAY": halFDay,
        "mngrRemarks": mngrRemarks,
      };
}
