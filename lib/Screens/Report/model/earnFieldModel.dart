// To parse this JSON data, do
//
//     final earnFiledModel = earnFiledModelFromJson(jsonString);

import 'dart:convert';

EarnFiledModel earnFiledModelFromJson(String str) =>
    EarnFiledModel.fromJson(json.decode(str));

String earnFiledModelToJson(EarnFiledModel data) => json.encode(data.toJson());

class EarnFiledModel {
  List<Datum>? data;

  EarnFiledModel({
    this.data,
  });

  factory EarnFiledModel.fromJson(Map<String, dynamic> json) => EarnFiledModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic emPCode;
  dynamic paydate;
  dynamic field;
  dynamic amount;
  dynamic prinTName;

  Datum({
    this.emPCode,
    this.paydate,
    this.field,
    this.amount,
    this.prinTName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        paydate: json["paydate"],
        field: json["field"],
        amount: json["amount"],
        prinTName: json["prinT_NAME"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "paydate": paydate,
        "field": field,
        "amount": amount,
        "prinT_NAME": prinTName,
      };
}
