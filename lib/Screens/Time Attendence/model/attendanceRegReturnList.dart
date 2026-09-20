// To parse this JSON data, do
//
//     final attendanceRegReturnListModel = attendanceRegReturnListModelFromJson(jsonString);

import 'dart:convert';

AttendanceRegReturnListModel attendanceRegReturnListModelFromJson(String str) =>
    AttendanceRegReturnListModel.fromJson(json.decode(str));

String attendanceRegReturnListModelToJson(AttendanceRegReturnListModel data) =>
    json.encode(data.toJson());

class AttendanceRegReturnListModel {
  Data? data;

  AttendanceRegReturnListModel({
    this.data,
  });

  factory AttendanceRegReturnListModel.fromJson(Map<String, dynamic> json) =>
      AttendanceRegReturnListModel(
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
