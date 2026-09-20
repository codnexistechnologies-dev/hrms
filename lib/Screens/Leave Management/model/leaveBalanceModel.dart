// To parse this JSON data, do
//
//     final leaveBalanceModel = leaveBalanceModelFromJson(jsonString);

import 'dart:convert';

LeaveBalanceModel leaveBalanceModelFromJson(String str) =>
    LeaveBalanceModel.fromJson(json.decode(str));

String leaveBalanceModelToJson(LeaveBalanceModel data) =>
    json.encode(data.toJson());

class LeaveBalanceModel {
  List<LeaveBalenceData>? data;

  LeaveBalanceModel({
    this.data,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceModel(
        data: List<LeaveBalenceData>.from(
            json["data"].map((x) => LeaveBalenceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LeaveBalenceData {
  dynamic levyear;
  dynamic emPCode;
  dynamic emPName;
  dynamic wef;
  dynamic earned;
  dynamic earneD1;
  dynamic lvtype;
  dynamic lvdesc;
  dynamic tot;
  dynamic availed;
  dynamic lapse;
  dynamic balance;

  LeaveBalenceData({
    this.levyear,
    this.emPCode,
    this.emPName,
    this.wef,
    this.earned,
    this.earneD1,
    this.lvtype,
    this.lvdesc,
    this.tot,
    this.availed,
    this.lapse,
    this.balance,
  });

  factory LeaveBalenceData.fromJson(Map<String, dynamic> json) =>
      LeaveBalenceData(
        levyear: json["levyear"],
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        wef: json["wef"],
        earned: json["earned"],
        earneD1: json["earneD1"],
        lvtype: json["lvtype"],
        lvdesc: json["lvdesc"],
        tot: json["tot"],
        availed: json["availed"],
        lapse: json["lapse"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "levyear": levyear,
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "wef": wef,
        "earned": earned,
        "earneD1": earneD1,
        "lvtype": lvtype,
        "lvdesc": lvdesc,
        "tot": tot,
        "availed": availed,
        "lapse": lapse,
        "balance": balance,
      };
}
