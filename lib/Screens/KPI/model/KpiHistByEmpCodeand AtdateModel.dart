class KpiHistByEmpCodeandAtdateModel {
  List<Data>? data;

  KpiHistByEmpCodeandAtdateModel({this.data});

  KpiHistByEmpCodeandAtdateModel.fromJson(Map<String, dynamic> json) {
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
  int? kpiid;
  String? emPCODE;
  String? atdate;
  String? paydate;
  int? actuaLFMPLAN;
  int? actuaLFDPLAN;
  int? actuaLDEMO;
  int? actuaLFARMERDATA;
  int? actuaLLIQUIDATION;
  int? actuaLCOLLECTION;
  int? fMPLANMASTER;
  int? fDPLANMASTER;
  int? demOMASTER;
  int? farmerdatAMASTER;
  int? liquidatioNMASTER;
  int? collectioNMASTER;
  String? remarks;
  String? createddate;

  Data(
      {this.kpiid,
      this.emPCODE,
      this.atdate,
      this.paydate,
      this.actuaLFMPLAN,
      this.actuaLFDPLAN,
      this.actuaLDEMO,
      this.actuaLFARMERDATA,
      this.actuaLLIQUIDATION,
      this.actuaLCOLLECTION,
      this.fMPLANMASTER,
      this.fDPLANMASTER,
      this.demOMASTER,
      this.farmerdatAMASTER,
      this.liquidatioNMASTER,
      this.collectioNMASTER,
      this.remarks,
      this.createddate});

  Data.fromJson(Map<String, dynamic> json) {
    kpiid = json['kpiid'];
    emPCODE = json['emP_CODE'];
    atdate = json['atdate'];
    paydate = json['paydate'];
    actuaLFMPLAN = json['actuaL_FM_PLAN'];
    actuaLFDPLAN = json['actuaL_FD_PLAN'];
    actuaLDEMO = json['actuaL_DEMO'];
    actuaLFARMERDATA = json['actuaL_FARMERDATA'];
    actuaLLIQUIDATION = json['actuaL_LIQUIDATION'];
    actuaLCOLLECTION = json['actuaL_COLLECTION'];
    fMPLANMASTER = json['fM_PLAN_MASTER'];
    fDPLANMASTER = json['fD_PLAN_MASTER'];
    demOMASTER = json['demO_MASTER'];
    farmerdatAMASTER = json['farmerdatA_MASTER'];
    liquidatioNMASTER = json['liquidatioN_MASTER'];
    collectioNMASTER = json['collectioN_MASTER'];
    remarks = json['remarks'];
    createddate = json['createddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kpiid'] = kpiid;
    data['emP_CODE'] = emPCODE;
    data['atdate'] = atdate;
    data['paydate'] = paydate;
    data['actuaL_FM_PLAN'] = actuaLFMPLAN;
    data['actuaL_FD_PLAN'] = actuaLFDPLAN;
    data['actuaL_DEMO'] = actuaLDEMO;
    data['actuaL_FARMERDATA'] = actuaLFARMERDATA;
    data['actuaL_LIQUIDATION'] = actuaLLIQUIDATION;
    data['actuaL_COLLECTION'] = actuaLCOLLECTION;
    data['fM_PLAN_MASTER'] = fMPLANMASTER;
    data['fD_PLAN_MASTER'] = fDPLANMASTER;
    data['demO_MASTER'] = demOMASTER;
    data['farmerdatA_MASTER'] = farmerdatAMASTER;
    data['liquidatioN_MASTER'] = liquidatioNMASTER;
    data['collectioN_MASTER'] = collectioNMASTER;
    data['remarks'] = remarks;
    data['createddate'] = createddate;
    return data;
  }
}
