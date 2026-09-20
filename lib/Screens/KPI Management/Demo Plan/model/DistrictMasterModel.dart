class DistrictMasterModel {
  List<DistrictData>? data;

  DistrictMasterModel({this.data});

  DistrictMasterModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DistrictData>[];
      json['data'].forEach((v) {
        data!.add(DistrictData.fromJson(v));
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

class DistrictData {
  int? districTCODE;
  String? districTNAME;
  int? isactive;
  String? statECODE;

  DistrictData(
      {this.districTCODE, this.districTNAME, this.isactive, this.statECODE});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DistrictData &&
        other.districTCODE == districTCODE &&
        other.districTNAME == districTNAME;
  }

  @override
  int get hashCode => districTCODE.hashCode ^ districTNAME.hashCode;

  DistrictData.fromJson(Map<String, dynamic> json) {
    districTCODE = json['districT_CODE'];
    districTNAME = json['districT_NAME'];
    isactive = json['isactive'];
    statECODE = json['statE_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['districT_CODE'] = districTCODE;
    data['districT_NAME'] = districTNAME;
    data['isactive'] = isactive;
    data['statE_CODE'] = statECODE;
    return data;
  }
}
