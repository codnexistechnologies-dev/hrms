class VillageListModel {
  List<VillageData>? data;

  VillageListModel({this.data});

  VillageListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VillageData>[];
      json['data'].forEach((v) {
        data!.add(VillageData.fromJson(v));
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

class VillageData {
  int? villagECODE;
  String? villagENAME;
  int? isactive;
  int? tehsiLCODE;
  int? piNCODE;

  VillageData(
      {this.villagECODE,
      this.villagENAME,
      this.isactive,
      this.tehsiLCODE,
      this.piNCODE});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VillageData &&
        other.villagECODE == villagECODE &&
        other.villagENAME == villagENAME;
  }

  @override
  int get hashCode => tehsiLCODE.hashCode ^ villagENAME.hashCode;
  VillageData.fromJson(Map<String, dynamic> json) {
    villagECODE = json['villagE_CODE'];
    villagENAME = json['villagE_NAME'];
    isactive = json['isactive'];
    tehsiLCODE = json['tehsiL_CODE'];
    piNCODE = json['piN_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['villagE_CODE'] = villagECODE;
    data['villagE_NAME'] = villagENAME;
    data['isactive'] = isactive;
    data['tehsiL_CODE'] = tehsiLCODE;
    data['piN_CODE'] = piNCODE;
    return data;
  }
}
