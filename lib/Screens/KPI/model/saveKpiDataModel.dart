// To parse this JSON data, do
//
//     final saveKpiDataModel = saveKpiDataModelFromJson(jsonString);

import 'dart:convert';

SaveKpiDataModel saveKpiDataModelFromJson(String str) =>
    SaveKpiDataModel.fromJson(json.decode(str));

String saveKpiDataModelToJson(SaveKpiDataModel data) =>
    json.encode(data.toJson());

class SaveKpiDataModel {
  Data data;

  SaveKpiDataModel({
    required this.data,
  });

  factory SaveKpiDataModel.fromJson(Map<String, dynamic> json) =>
      SaveKpiDataModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  bool isSuccess;
  String returnMessage;
  dynamic data;

  Data({
    required this.isSuccess,
    required this.returnMessage,
    required this.data,
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
