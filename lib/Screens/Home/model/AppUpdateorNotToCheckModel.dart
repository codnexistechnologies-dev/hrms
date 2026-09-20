import 'dart:convert';

AppUpdateorNotToCheckModel appUpdateorNotToCheckModelFromJson(String str) =>
    AppUpdateorNotToCheckModel.fromJson(json.decode(str));

String appUpdateorNotToCheckModelToJson(AppUpdateorNotToCheckModel data) =>
    json.encode(data.toJson());

class AppUpdateorNotToCheckModel {
  Data? data;

  AppUpdateorNotToCheckModel({
    this.data,
  });

  factory AppUpdateorNotToCheckModel.fromJson(Map<String, dynamic> json) =>
      AppUpdateorNotToCheckModel(
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
