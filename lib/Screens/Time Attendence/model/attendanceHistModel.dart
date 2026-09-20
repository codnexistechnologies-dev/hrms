// To parse this JSON data, do
//
//     final attendanceHistModel = attendanceHistModelFromJson(jsonString);

import 'dart:convert';

AttendanceHistModel attendanceHistModelFromJson(String str) =>
    AttendanceHistModel.fromJson(json.decode(str));

String attendanceHistModelToJson(AttendanceHistModel data) =>
    json.encode(data.toJson());

class AttendanceHistModel {
  List<Datum>? data;

  AttendanceHistModel({
    this.data,
  });

  factory AttendanceHistModel.fromJson(Map<String, dynamic> json) =>
      AttendanceHistModel(
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
  dynamic iNTime;
  dynamic ouTTime;
  dynamic lvdays;
  dynamic result;
  dynamic lvtype;
  dynamic paydate;
  dynamic shifTCode;
  dynamic iNDate;
  dynamic ouTDate;
  dynamic workinGHour;
  dynamic earlYIn;
  dynamic latEIn;
  dynamic earlYOut;
  dynamic latEOut;
  dynamic shifttime;

  Datum({
    this.levyear,
    this.emPCode,
    this.emPName,
    this.atdate,
    this.iNTime,
    this.ouTTime,
    this.lvdays,
    this.result,
    this.lvtype,
    this.paydate,
    this.shifTCode,
    this.iNDate,
    this.ouTDate,
    this.workinGHour,
    this.earlYIn,
    this.latEIn,
    this.earlYOut,
    this.latEOut,
    this.shifttime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        levyear: json["levyear"],
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        atdate: json["atdate"],
        iNTime: json["iN_TIME"],
        ouTTime: json["ouT_TIME"],
        lvdays: json["lvdays"],
        result: json["result"],
        lvtype: json["lvtype"],
        paydate: json["paydate"],
        shifTCode: json["shifT_CODE"],
        iNDate: json["iN_DATE"],
        ouTDate: json["ouT_DATE"],
        workinGHour: json["workinG_HOUR"],
        earlYIn: json["earlY_IN"],
        latEIn: json["latE_IN"],
        earlYOut: json["earlY_OUT"],
        latEOut: json["latE_OUT"],
        shifttime: json["shifttime"],
      );

  Map<String, dynamic> toJson() => {
        "levyear": levyear,
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "atdate": atdate,
        "iN_TIME": iNTime,
        "ouT_TIME": ouTTime,
        "lvdays": lvdays,
        "result": result,
        "lvtype": lvtype,
        "paydate": paydate,
        "shifT_CODE": shifTCode,
        "iN_DATE": iNDate,
        "ouT_DATE": ouTDate,
        "workinG_HOUR": workinGHour,
        "earlY_IN": earlYIn,
        "latE_IN": latEIn,
        "earlY_OUT": earlYOut,
        "latE_OUT": latEOut,
        "shifttime": shifttime,
      };
}
