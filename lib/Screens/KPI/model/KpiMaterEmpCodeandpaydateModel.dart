class KpiMaterEmpCodeandpaydateModel {
  List<Data>? data;

  KpiMaterEmpCodeandpaydateModel({this.data});

  KpiMaterEmpCodeandpaydateModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? kpimid;
  String? emPCODE;
  String? paydate;
  int? fMPLANMASTER;
  int? fDPLANMASTER;
  int? demOMASTER;
  int? farmerdatAMASTER;
  int? liquidatioNMASTER;
  int? collectioNMASTER;
  String? kpIMASTERREMARKS;
  String? createddate;

  Data(
      {this.kpimid,
      this.emPCODE,
      this.paydate,
      this.fMPLANMASTER,
      this.fDPLANMASTER,
      this.demOMASTER,
      this.farmerdatAMASTER,
      this.liquidatioNMASTER,
      this.collectioNMASTER,
      this.kpIMASTERREMARKS,
      this.createddate});

  Data.fromJson(Map<String, dynamic> json) {
    kpimid = json['kpimid'];
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    fMPLANMASTER = json['fM_PLAN_MASTER'];
    fDPLANMASTER = json['fD_PLAN_MASTER'];
    demOMASTER = json['demO_MASTER'];
    farmerdatAMASTER = json['farmerdatA_MASTER'];
    liquidatioNMASTER = json['liquidatioN_MASTER'];
    collectioNMASTER = json['collectioN_MASTER'];
    kpIMASTERREMARKS = json['kpI_MASTER_REMARKS'];
    createddate = json['createddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kpimid'] = kpimid;
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['fM_PLAN_MASTER'] = fMPLANMASTER;
    data['fD_PLAN_MASTER'] = fDPLANMASTER;
    data['demO_MASTER'] = demOMASTER;
    data['farmerdatA_MASTER'] = farmerdatAMASTER;
    data['liquidatioN_MASTER'] = liquidatioNMASTER;
    data['collectioN_MASTER'] = collectioNMASTER;
    data['kpI_MASTER_REMARKS'] = kpIMASTERREMARKS;
    data['createddate'] = createddate;
    return data;
  }
}
