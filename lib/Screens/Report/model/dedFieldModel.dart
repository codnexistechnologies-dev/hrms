// To parse this JSON data, do
//
//     final dedFiledModel = dedFiledModelFromJson(jsonString);

import 'dart:convert';

DedFiledModel dedFiledModelFromJson(String str) =>
    DedFiledModel.fromJson(json.decode(str));

String dedFiledModelToJson(DedFiledModel data) => json.encode(data.toJson());

class DedFiledModel {
  List<Datum>? data;

  DedFiledModel({
    this.data,
  });

  factory DedFiledModel.fromJson(Map<String, dynamic> json) => DedFiledModel(
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
