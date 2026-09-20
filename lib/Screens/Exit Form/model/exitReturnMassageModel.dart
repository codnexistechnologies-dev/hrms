// To parse this JSON data, do
//
//     final exitReturnMassageModel = exitReturnMassageModelFromJson(jsonString);

import 'dart:convert';

ExitReturnMassageModel exitReturnMassageModelFromJson(String str) =>
    ExitReturnMassageModel.fromJson(json.decode(str));

String exitReturnMassageModelToJson(ExitReturnMassageModel data) =>
    json.encode(data.toJson());

class ExitReturnMassageModel {
  Data? data;

  ExitReturnMassageModel({
    this.data,
  });

  factory ExitReturnMassageModel.fromJson(Map<String, dynamic> json) =>
      ExitReturnMassageModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  dynamic isSuccess;
  dynamic returnMessage;
  dynamic data;

  Data({
    this.isSuccess,
    this.returnMessage,
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isSuccess: json["IsSuccess"],
        returnMessage: json["ReturnMessage"],
        data: json["Data"],
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "ReturnMessage": returnMessage,
        "Data": data,
      };
}
