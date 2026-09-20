class CropMastModel {
  List<CropMast>? data;

  CropMastModel({this.data});

  CropMastModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CropMast>[];
      json['data'].forEach((v) {
        data!.add(CropMast.fromJson(v));
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

class CropMast {
  int? croPCODE;
  String? croPNAME;
  String? isactive;

  CropMast({this.croPCODE, this.croPNAME, this.isactive});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CropMast &&
        other.croPCODE == croPCODE &&
        other.croPNAME == croPNAME;
  }

  @override
  int get hashCode => croPCODE.hashCode ^ croPNAME.hashCode;

  CropMast.fromJson(Map<String, dynamic> json) {
    croPCODE = json['croP_CODE'];
    croPNAME = json['croP_NAME'];
    isactive = json['isactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['croP_CODE'] = croPCODE;
    data['croP_NAME'] = croPNAME;
    data['isactive'] = isactive;
    return data;
  }
}
