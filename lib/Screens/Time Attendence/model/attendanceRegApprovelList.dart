// To parse this JSON data, do
//
//     final attendanceRegApprovelListModel = attendanceRegApprovelListModelFromJson(jsonString);

import 'dart:convert';

AttendanceRegApprovelListModel attendanceRegApprovelListModelFromJson(
        String str) =>
    AttendanceRegApprovelListModel.fromJson(json.decode(str));

String attendanceRegApprovelListModelToJson(
        AttendanceRegApprovelListModel data) =>
    json.encode(data.toJson());

class AttendanceRegApprovelListModel {
  List<Attendancehist>? data;

  AttendanceRegApprovelListModel({
    this.data,
  });

  factory AttendanceRegApprovelListModel.fromJson(Map<String, dynamic> json) =>
      AttendanceRegApprovelListModel(
        data: List<Attendancehist>.from(
            json["data"].map((x) => Attendancehist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Attendancehist {
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
  dynamic shifTFrom;
  dynamic shifTTo;
  dynamic weekDay;
  dynamic atTFlag;
  dynamic status;
  dynamic ouTOfDuty;
  dynamic oldInTime;
  dynamic oldOutTime;
  dynamic mngrCode;
  dynamic remarks;

  Attendancehist({
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
    this.shifTFrom,
    this.shifTTo,
    this.weekDay,
    this.atTFlag,
    this.status,
    this.ouTOfDuty,
    this.oldInTime,
    this.oldOutTime,
    this.mngrCode,
    this.remarks,
  });

  factory Attendancehist.fromJson(Map<String, dynamic> json) => Attendancehist(
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
        shifTFrom: json["shifT_FROM"],
        shifTTo: json["shifT_TO"],
        weekDay: json["weekDay"],
        atTFlag: json["atT_FLAG"],
        status: json["status"],
        ouTOfDuty: json["ouT_OF_DUTY"],
        oldInTime: json["oldInTime"],
        oldOutTime: json["oldOutTime"],
        mngrCode: json["mngr_code"],
        remarks: json["remarks"],
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
        "shifT_FROM": shifTFrom,
        "shifT_TO": shifTTo,
        "weekDay": weekDay,
        "atT_FLAG": atTFlag,
        "status": status,
        "ouT_OF_DUTY": ouTOfDuty,
        "oldInTime": oldInTime,
        "oldOutTime": oldOutTime,
        "mngr_code": mngrCode,
        "remarks": remarks,
      };
}
