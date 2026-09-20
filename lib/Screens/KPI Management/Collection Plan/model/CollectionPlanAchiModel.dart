class CollectionPlanAchiModel {
  List<CollectionPlanAchi>? data;

  CollectionPlanAchiModel({this.data});

  CollectionPlanAchiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CollectionPlanAchi>[];
      json['data'].forEach((v) {
        data!.add(CollectionPlanAchi.fromJson(v));
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

class CollectionPlanAchi {
  String? emPCODE;
  String? paydate;
  int? collectioNPLANACHIEVEMENT;

  CollectionPlanAchi(
      {this.emPCODE, this.paydate, this.collectioNPLANACHIEVEMENT});

  CollectionPlanAchi.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    collectioNPLANACHIEVEMENT = json['collectioN_PLAN_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['collectioN_PLAN_ACHIEVEMENT'] = collectioNPLANACHIEVEMENT;
    return data;
  }
}
