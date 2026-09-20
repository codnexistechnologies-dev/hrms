class ResignationAppStatusByEmpCode {
  List<Data>? data;

  ResignationAppStatusByEmpCode({this.data});

  ResignationAppStatusByEmpCode.fromJson(Map<String, dynamic> json) {
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
  dynamic emPCODE;
  String? resignationdate;
  String? settlementrelievingdate;
  String? releavingdate;
  String? emPREMARKS;
  dynamic mngRREMARKS;
  dynamic mngrapr;
  dynamic hrapr;
  dynamic acctapr;
  dynamic itapr;
  dynamic hRREMARKS;
  dynamic noticeperiodserved;
  dynamic pemailid;

  Data(
      {this.emPCODE,
      this.resignationdate,
      this.settlementrelievingdate,
      this.releavingdate,
      this.emPREMARKS,
      this.mngRREMARKS,
      this.mngrapr,
      this.hrapr,
      this.acctapr,
      this.itapr,
      this.hRREMARKS,
      this.noticeperiodserved,
      this.pemailid});

  Data.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    resignationdate = json['resignationdate'];
    settlementrelievingdate = json['settlementrelievingdate'];
    releavingdate = json['releavingdate'];
    emPREMARKS = json['emP_REMARKS'];
    mngRREMARKS = json['mngR_REMARKS'];
    mngrapr = json['mngrapr'];
    hrapr = json['hrapr'];
    acctapr = json['acctapr'];
    itapr = json['itapr'];
    hRREMARKS = json['hR_REMARKS'];
    noticeperiodserved = json['noticeperiodserved'];
    pemailid = json['pemailid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['resignationdate'] = resignationdate;
    data['settlementrelievingdate'] = settlementrelievingdate;
    data['releavingdate'] = releavingdate;
    data['emP_REMARKS'] = emPREMARKS;
    data['mngR_REMARKS'] = mngRREMARKS;
    data['mngrapr'] = mngrapr;
    data['hrapr'] = hrapr;
    data['acctapr'] = acctapr;
    data['itapr'] = itapr;
    data['hR_REMARKS'] = hRREMARKS;
    data['noticeperiodserved'] = noticeperiodserved;
    data['pemailid'] = pemailid;
    return data;
  }
}
