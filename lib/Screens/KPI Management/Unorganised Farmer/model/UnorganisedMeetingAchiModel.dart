class UnorganisedMeetingAchiModel {
  List<UnorganisedMeetingAchi>? data;

  UnorganisedMeetingAchiModel({this.data});

  UnorganisedMeetingAchiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UnorganisedMeetingAchi>[];
      json['data'].forEach((v) {
        data!.add(UnorganisedMeetingAchi.fromJson(v));
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

class UnorganisedMeetingAchi {
  String? emPCODE;
  String? paydate;
  int? unorganiseDMEETINGACHIEVEMENT;

  UnorganisedMeetingAchi(
      {this.emPCODE, this.paydate, this.unorganiseDMEETINGACHIEVEMENT});

  UnorganisedMeetingAchi.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    unorganiseDMEETINGACHIEVEMENT = json['unorganiseD_MEETING_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['unorganiseD_MEETING_ACHIEVEMENT'] =
        unorganiseDMEETINGACHIEVEMENT;
    return data;
  }
}
