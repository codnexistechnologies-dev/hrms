class FieldDaysAchiModel {
  List<FieldDaysAchi>? data;

  FieldDaysAchiModel({this.data});

  FieldDaysAchiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FieldDaysAchi>[];
      json['data'].forEach((v) {
        data!.add(FieldDaysAchi.fromJson(v));
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

class FieldDaysAchi {
  String? emPCODE;
  String? paydate;
  int? fielDDAYSACHIEVEMENT;

  FieldDaysAchi({this.emPCODE, this.paydate, this.fielDDAYSACHIEVEMENT});

  FieldDaysAchi.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    fielDDAYSACHIEVEMENT = json['fielD_DAYS_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['fielD_DAYS_ACHIEVEMENT'] = fielDDAYSACHIEVEMENT;
    return data;
  }
}
