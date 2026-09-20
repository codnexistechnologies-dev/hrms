// To parse this JSON data, do
//
//     final netPayModel = netPayModelFromJson(jsonString);

import 'dart:convert';

NetPayModel netPayModelFromJson(String str) =>
    NetPayModel.fromJson(json.decode(str));

String netPayModelToJson(NetPayModel data) => json.encode(data.toJson());

class NetPayModel {
  List<Datum>? data;

  NetPayModel({
    this.data,
  });

  factory NetPayModel.fromJson(Map<String, dynamic> json) => NetPayModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic emPCode;
  dynamic paydate;
  dynamic grosspay;
  dynamic grossded;
  dynamic netpay;

  Datum({
    this.emPCode,
    this.paydate,
    this.grosspay,
    this.grossded,
    this.netpay,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        paydate: json["paydate"],
        grosspay: json["grosspay"],
        grossded: json["grossded"],
        netpay: json["netpay"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "paydate": paydate,
        "grosspay": grosspay,
        "grossded": grossded,
        "netpay": netpay,
      };
}
