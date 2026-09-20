// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

Attendance attendanceFromJson(String str) =>
    Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  List<Datum> data;

  Attendance({
    required this.data,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String? emPCode;
  DateTime? atdate;
  String? iNTime;
  String? ouTTime;
  String? checKInOut;

  Datum({
    this.emPCode,
    this.atdate,
    this.iNTime,
    this.ouTTime,
    this.checKInOut,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        emPCode: json["emP_CODE"],
        atdate: DateTime.parse(json["atdate"]),
        iNTime: json["iN_TIME"],
        ouTTime: json["ouT_TIME"],
        checKInOut: json["checK_IN_OUT"],
      );

  Map<String, dynamic> toJson() => {
        "emP_CODE": emPCode,
        "atdate": atdate?.toIso8601String(),
        "iN_TIME": iNTime,
        "ouT_TIME": ouTTime,
        "checK_IN_OUT": checKInOut,
      };
}
