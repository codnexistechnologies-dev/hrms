class CompmastModel {
  List<Data>? data;

  CompmastModel({this.data});

  CompmastModel.fromJson(Map<String, dynamic> json) {
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
  dynamic comPCODE;
  dynamic comPNAME;
  dynamic sigNDATE;

  Data({this.comPCODE, this.comPNAME, this.sigNDATE});

  Data.fromJson(Map<String, dynamic> json) {
    comPCODE = json['comP_CODE'];
    comPNAME = json['comP_NAME'];
    sigNDATE = json['sigN_DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comP_CODE'] = comPCODE;
    data['comP_NAME'] = comPNAME;
    data['sigN_DATE'] = sigNDATE;
    return data;
  }
}
