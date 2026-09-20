// To parse this JSON data, do
//
//     final paySlipEmpCodeandMonthYearModel = paySlipEmpCodeandMonthYearModelFromJson(jsonString);

import 'dart:convert';

PaySlipEmpCodeandMonthYearModel paySlipEmpCodeandMonthYearModelFromJson(
        String str) =>
    PaySlipEmpCodeandMonthYearModel.fromJson(json.decode(str));

String paySlipEmpCodeandMonthYearModelToJson(
        PaySlipEmpCodeandMonthYearModel data) =>
    json.encode(data.toJson());

class PaySlipEmpCodeandMonthYearModel {
  List<Datum>? data;

  PaySlipEmpCodeandMonthYearModel({
    this.data,
  });

  factory PaySlipEmpCodeandMonthYearModel.fromJson(Map<String, dynamic> json) =>
      PaySlipEmpCodeandMonthYearModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic emPCode;
  dynamic paydate;
  dynamic paysliPName;
  dynamic paysliPPath;
  dynamic message;

  Datum({
    this.emPCode,
    this.paydate,
    this.paysliPName,
    this.paysliPPath,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        paydate: DateTime.parse(json["paydate"]),
        paysliPName: json["paysliP_NAME"],
        paysliPPath: json["paysliP_PATH"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "paydate": paydate.toIso8601String(),
        "paysliP_NAME": paysliPName,
        "paysliP_PATH": paysliPPath,
        "message": message,
      };
}
