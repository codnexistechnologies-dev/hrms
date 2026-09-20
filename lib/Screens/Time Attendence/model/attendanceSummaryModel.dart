// To parse this JSON data, do
//
//     final attendanceSummaryModel = attendanceSummaryModelFromJson(jsonString);

import 'dart:convert';

AttendanceSummaryModel attendanceSummaryModelFromJson(String str) =>
    AttendanceSummaryModel.fromJson(json.decode(str));

String attendanceSummaryModelToJson(AttendanceSummaryModel data) =>
    json.encode(data.toJson());

class AttendanceSummaryModel {
  List<Datum>? data;

  AttendanceSummaryModel({
    this.data,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      AttendanceSummaryModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic emPCode;
  dynamic emPName;
  dynamic loCName;
  dynamic depTName;
  dynamic dsGName;
  dynamic paydate;
  dynamic present;
  dynamic absent;
  dynamic leave;
  dynamic latecoming;
  dynamic holidays;
  dynamic weekoff;
  dynamic mondays;
  dynamic totaLPresent;

  Datum({
    this.emPCode,
    this.emPName,
    this.loCName,
    this.depTName,
    this.dsGName,
    this.paydate,
    this.present,
    this.absent,
    this.leave,
    this.latecoming,
    this.holidays,
    this.weekoff,
    this.mondays,
    this.totaLPresent,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        loCName: json["loC_NAME"],
        depTName: json["depT_NAME"],
        dsGName: json["dsG_NAME"],
        paydate: json["paydate"],
        present: json["present"],
        absent: json["absent"],
        leave: json["leave"],
        latecoming: json["latecoming"],
        holidays: json["holidays"],
        weekoff: json["weekoff"],
        mondays: json["mondays"],
        totaLPresent: json["totaL_PRESENT"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "loC_NAME": loCName,
        "depT_NAME": depTName,
        "dsG_NAME": dsGName,
        "paydate": paydate,
        "present": present,
        "absent": absent,
        "leave": leave,
        "latecoming": latecoming,
        "holidays": holidays,
        "weekoff": weekoff,
        "mondays": mondays,
        "totaL_PRESENT": totaLPresent,
      };
}
