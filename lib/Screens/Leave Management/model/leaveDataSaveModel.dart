// To parse this JSON data, do
//
//     final leaveDataSaveModelModel = leaveDataSaveModelModelFromJson(jsonString);

import 'dart:convert';

LeaveDataSaveModelModel leaveDataSaveModelModelFromJson(String str) =>
    LeaveDataSaveModelModel.fromJson(json.decode(str));

String leaveDataSaveModelModelToJson(LeaveDataSaveModelModel data) =>
    json.encode(data.toJson());

class LeaveDataSaveModelModel {
  Data? data;

  LeaveDataSaveModelModel({
    this.data,
  });

  factory LeaveDataSaveModelModel.fromJson(Map<String, dynamic> json) =>
      LeaveDataSaveModelModel(
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
