class DemoPlanHistByEmpCodeAndAtdate {
  List<DemoPlanEmpCodeAtdate>? data;

  DemoPlanHistByEmpCodeAndAtdate({this.data});

  DemoPlanHistByEmpCodeAndAtdate.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DemoPlanEmpCodeAtdate>[];
      json['data'].forEach((v) {
        data!.add(DemoPlanEmpCodeAtdate.fromJson(v));
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

class DemoPlanEmpCodeAtdate {
  int? demoid;
  String? emPCODE;
  String? farmeRNAME;
  String? mobilENO;
  String? tanKQTY;
  int? producTCODE;
  dynamic imagEFILE;
  String? remarks;
  String? statECODE;
  int? districTCODE;
  int? tehsiLCODE;
  int? villagECODE;
  double? latitude;
  double? longitude;
  String? address;
  String? entrydatetime;
  String? uploaDFILE;
  String? producTNAME;
  String? statENAME;
  String? districTNAME;
  String? tehsiLNAME;
  String? villagENAME;

  DemoPlanEmpCodeAtdate(
      {this.demoid,
      this.emPCODE,
      this.farmeRNAME,
      this.mobilENO,
      this.tanKQTY,
      this.producTCODE,
      this.imagEFILE,
      this.remarks,
      this.statECODE,
      this.districTCODE,
      this.tehsiLCODE,
      this.villagECODE,
      this.latitude,
      this.longitude,
      this.address,
      this.entrydatetime,
      this.uploaDFILE,
      this.producTNAME,
      this.statENAME,
      this.districTNAME,
      this.tehsiLNAME,
      this.villagENAME});

  DemoPlanEmpCodeAtdate.fromJson(Map<String, dynamic> json) {
    demoid = json['demoid'];
    emPCODE = json['emP_CODE'];
    farmeRNAME = json['farmeR_NAME'];
    mobilENO = json['mobilE_NO'];
    tanKQTY = json['tanK_QTY'];
    producTCODE = json['producT_CODE'];
    imagEFILE = json['imagE_FILE'];
    remarks = json['remarks'];
    statECODE = json['statE_CODE'];
    districTCODE = json['districT_CODE'];
    tehsiLCODE = json['tehsiL_CODE'];
    villagECODE = json['villagE_CODE'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    entrydatetime = json['entrydatetime'];
    uploaDFILE = json['uploaD_FILE'];
    producTNAME = json['producT_NAME'];
    statENAME = json['statE_NAME'];
    districTNAME = json['districT_NAME'];
    tehsiLNAME = json['tehsiL_NAME'];
    villagENAME = json['villagE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['demoid'] = demoid;
    data['emP_CODE'] = emPCODE;
    data['farmeR_NAME'] = farmeRNAME;
    data['mobilE_NO'] = mobilENO;
    data['tanK_QTY'] = tanKQTY;
    data['producT_CODE'] = producTCODE;
    data['imagE_FILE'] = imagEFILE;
    data['remarks'] = remarks;
    data['statE_CODE'] = statECODE;
    data['districT_CODE'] = districTCODE;
    data['tehsiL_CODE'] = tehsiLCODE;
    data['villagE_CODE'] = villagECODE;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['entrydatetime'] = entrydatetime;
    data['uploaD_FILE'] = uploaDFILE;
    data['producT_NAME'] = producTNAME;
    data['statE_NAME'] = statENAME;
    data['districT_NAME'] = districTNAME;
    data['tehsiL_NAME'] = tehsiLNAME;
    data['villagE_NAME'] = villagENAME;
    return data;
  }
}
