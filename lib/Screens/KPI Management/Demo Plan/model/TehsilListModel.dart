class TehsilListModel {
  List<TehsilData>? data;

  TehsilListModel({this.data});

  TehsilListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TehsilData>[];
      json['data'].forEach((v) {
        data!.add(TehsilData.fromJson(v));
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

class TehsilData {
  int? tehsiLCODE;
  String? tehsiLNAME;
  int? isactive;
  String? districTCODE;

  TehsilData(
      {this.tehsiLCODE, this.tehsiLNAME, this.isactive, this.districTCODE});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TehsilData &&
        other.tehsiLCODE == tehsiLCODE &&
        other.tehsiLNAME == tehsiLNAME;
  }

  @override
  int get hashCode => tehsiLCODE.hashCode ^ tehsiLNAME.hashCode;

  TehsilData.fromJson(Map<String, dynamic> json) {
    tehsiLCODE = json['tehsiL_CODE'];
    tehsiLNAME = json['tehsiL_NAME'];
    isactive = json['isactive'];
    districTCODE = json['districT_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tehsiL_CODE'] = tehsiLCODE;
    data['tehsiL_NAME'] = tehsiLNAME;
    data['isactive'] = isactive;
    data['districT_CODE'] = districTCODE;
    return data;
  }
}
