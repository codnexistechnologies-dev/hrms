class LiquidationPlanAchiModel {
  List<LiquidationPlanAchi>? data;

  LiquidationPlanAchiModel({this.data});

  LiquidationPlanAchiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LiquidationPlanAchi>[];
      json['data'].forEach((v) {
        data!.add(LiquidationPlanAchi.fromJson(v));
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

class LiquidationPlanAchi {
  String? emPCODE;
  String? paydate;
  int? liquidatioNPLANACHIEVEMENT;

  LiquidationPlanAchi(
      {this.emPCODE, this.paydate, this.liquidatioNPLANACHIEVEMENT});

  LiquidationPlanAchi.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    liquidatioNPLANACHIEVEMENT = json['liquidatioN_PLAN_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['liquidatioN_PLAN_ACHIEVEMENT'] = liquidatioNPLANACHIEVEMENT;
    return data;
  }
}
