class KpiMasterList {
  List<KpiMaster>? data;

  KpiMasterList({this.data});

  KpiMasterList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <KpiMaster>[];
      json['data'].forEach((v) {
        data!.add(KpiMaster.fromJson(v));
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

class KpiMaster {
  int? kpimid;
  String? emPCODE;
  String? paydate;
  int? organiseDFARMERMETTING;
  int? unorganiseDFARMERMETTING;
  int? demOPLAN;
  int? liquidatioNPLAN;
  int? fielDDAYS;
  int? collectioNPLAN;
  int? farmeR_CONTACT_PLAN;
  String? kpIMASTERREMARKS;
  dynamic createddate;

  KpiMaster({
    this.kpimid,
    this.emPCODE,
    this.paydate,
    this.organiseDFARMERMETTING,
    this.unorganiseDFARMERMETTING,
    this.demOPLAN,
    this.liquidatioNPLAN,
    this.fielDDAYS,
    this.collectioNPLAN,
    this.farmeR_CONTACT_PLAN,
    this.kpIMASTERREMARKS,
    this.createddate,
  });

  KpiMaster.fromJson(Map<String, dynamic> json) {
    kpimid = json['kpimid'];
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    organiseDFARMERMETTING = json['organiseD_FARMER_METTING'];
    unorganiseDFARMERMETTING = json['unorganiseD_FARMER_METTING'];
    demOPLAN = json['demO_PLAN'];
    liquidatioNPLAN = json['liquidatioN_PLAN'];
    fielDDAYS = json['fielD_DAYS'];
    collectioNPLAN = json['collectioN_PLAN'];
    farmeR_CONTACT_PLAN = json['farmeR_CONTACT_PLAN'];
    kpIMASTERREMARKS = json['kpI_MASTER_REMARKS'];
    createddate = json['createddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kpimid'] = kpimid;
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['organiseD_FARMER_METTING'] = organiseDFARMERMETTING;
    data['unorganiseD_FARMER_METTING'] = unorganiseDFARMERMETTING;
    data['demO_PLAN'] = demOPLAN;
    data['liquidatioN_PLAN'] = liquidatioNPLAN;
    data['fielD_DAYS'] = fielDDAYS;
    data['collectioN_PLAN'] = collectioNPLAN;
    data['farmeR_CONTACT_PLAN'] = farmeR_CONTACT_PLAN;
    data['kpI_MASTER_REMARKS'] = kpIMASTERREMARKS;
    data['createddate'] = createddate;
    return data;
  }
}
