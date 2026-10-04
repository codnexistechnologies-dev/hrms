class FarmerVisitAchievementModel {
  List<Data>? data;

  FarmerVisitAchievementModel({this.data});

  FarmerVisitAchievementModel.fromJson(Map<String, dynamic> json)
    : data = (json['data'] as List<dynamic>?)
          ?.map((v) => Data.fromJson(v as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    final items = data;
    if (items != null) {
      json['data'] = items.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Data {
  String? emPCODE;
  String? paydate;
  int? farmeRVISITACHIEVEMENT;

  Data({this.emPCODE, this.paydate, this.farmeRVISITACHIEVEMENT});

  Data.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    farmeRVISITACHIEVEMENT = json['farmeR_VISIT_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['farmeR_VISIT_ACHIEVEMENT'] = farmeRVISITACHIEVEMENT;
    return data;
  }
}
