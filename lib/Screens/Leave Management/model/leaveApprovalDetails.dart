// To parse this JSON data, do
//
//     final leaveApprovelDetailsModel = leaveApprovelDetailsModelFromJson(jsonString);

import 'dart:convert';

LeaveApprovalDetailsModel leaveApprovalDetailsModelFromJson(String str) =>
    LeaveApprovalDetailsModel.fromJson(json.decode(str));

String leaveApprovalDetailsModelToJson(LeaveApprovalDetailsModel data) =>
    json.encode(data.toJson());

class LeaveApprovalDetailsModel {
  List<LeaveApproval>? data;

  LeaveApprovalDetailsModel({
    this.data,
  });

  factory LeaveApprovalDetailsModel.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalDetailsModel(
        data: List<LeaveApproval>.from(
            json["data"].map((x) => LeaveApproval.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LeaveApproval {
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

  LeaveApproval({
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
  });

  factory LeaveApproval.fromJson(Map<String, dynamic> json) => LeaveApproval(
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
      };
}
