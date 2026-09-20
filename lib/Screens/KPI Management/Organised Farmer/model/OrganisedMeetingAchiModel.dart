class OrganisedMeetingAchiModel {
  List<OrganisedMeetingAchi>? data;

  OrganisedMeetingAchiModel({this.data});

  OrganisedMeetingAchiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OrganisedMeetingAchi>[];
      json['data'].forEach((v) {
        data!.add(OrganisedMeetingAchi.fromJson(v));
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

class OrganisedMeetingAchi {
  String? emPCODE;
  String? paydate;
  int? organiseDMEETINGACHIEVEMENT;

  OrganisedMeetingAchi(
      {this.emPCODE, this.paydate, this.organiseDMEETINGACHIEVEMENT});

  OrganisedMeetingAchi.fromJson(Map<String, dynamic> json) {
    emPCODE = json['emP_CODE'];
    paydate = json['paydate'];
    organiseDMEETINGACHIEVEMENT = json['organiseD_MEETING_ACHIEVEMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emP_CODE'] = emPCODE;
    data['paydate'] = paydate;
    data['organiseD_MEETING_ACHIEVEMENT'] = organiseDMEETINGACHIEVEMENT;
    return data;
  }
}
