class TankMastModel {
  List<TankMast>? data;

  TankMastModel({this.data});

  TankMastModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TankMast>[];
      json['data'].forEach((v) {
        data!.add(TankMast.fromJson(v));
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

class TankMast {
  int? tanKCODE;
  String? tanKNAME;
  int? isactive;

  TankMast({this.tanKCODE, this.tanKNAME, this.isactive});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TankMast &&
        other.tanKCODE == tanKCODE &&
        other.tanKNAME == tanKNAME;
  }

  @override
  int get hashCode => tanKCODE.hashCode ^ tanKNAME.hashCode;

  TankMast.fromJson(Map<String, dynamic> json) {
    tanKCODE = json['tanK_CODE'];
    tanKNAME = json['tanK_NAME'];
    isactive = json['isactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tanK_CODE'] = tanKCODE;
    data['tanK_NAME'] = tanKNAME;
    data['isactive'] = isactive;
    return data;
  }
}
