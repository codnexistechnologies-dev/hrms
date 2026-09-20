class DemoPlanAchievementModel {
  List<DemoPlanAchievement>? data;

  DemoPlanAchievementModel({this.data});

  DemoPlanAchievementModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DemoPlanAchievement>[];
      json['data'].forEach((v) {
        data!.add(DemoPlanAchievement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DemoPlanAchievement {
  String? emPCODE;
  String? paydate;
  dynamic demOPLANACHIEVEMENT;

  DemoPlanAchievement({this.emPCODE, this.paydate, this.demOPLANACHIEVEMENT});

  DemoPlanAchievement.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    demOPLANACHIEVEMENT = json['demO_PLAN_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['demO_PLAN_ACHIEVEMENT'] = demOPLANACHIEVEMENT;
    return data;
  }
}
