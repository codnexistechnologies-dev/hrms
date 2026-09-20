// To parse this JSON data, do
//
//     final employeeWithManagersModel = employeeWithManagersModelFromJson(jsonString);

import 'dart:convert';

EmployeeWithManagersModel employeeWithManagersModelFromJson(String str) =>
    EmployeeWithManagersModel.fromJson(json.decode(str));

String employeeWithManagersModelToJson(EmployeeWithManagersModel data) =>
    json.encode(data.toJson());

class EmployeeWithManagersModel {
  List<Datum>? data;

  EmployeeWithManagersModel({
    this.data,
  });

  factory EmployeeWithManagersModel.fromJson(Map<String, dynamic> json) =>
      EmployeeWithManagersModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic emPCode;
  dynamic emPName;
  dynamic mngRCode;
  dynamic mngRName;
  dynamic type;
  dynamic mngRCode1;
  dynamic mngRName1;

  Datum({
    this.emPCode,
    this.emPName,
    this.mngRCode,
    this.mngRName,
    this.type,
    this.mngRCode1,
    this.mngRName1,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        emPName: json["emP_NAME"],
        mngRCode: json["mngR_CODE"],
        mngRName: json["mngR_NAME"],
        type: json["type"],
        mngRCode1: json["mngR_CODE1"],
        mngRName1: json["mngR_NAME1"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "emP_NAME": emPName,
        "mngR_CODE": mngRCode,
        "mngR_NAME": mngRName,
        "type": type,
        "mngR_CODE1": mngRCode1,
        "mngR_NAME1": mngRName1,
      };
}
