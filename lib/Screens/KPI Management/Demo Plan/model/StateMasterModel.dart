class StateMasterModel {
  List<StateData>? data; // Changed the type to use a distinct class name

  StateMasterModel({this.data});

  // Factory constructor to create an instance from JSON
  factory StateMasterModel.fromJson(Map<String, dynamic> json) {
    return StateMasterModel(
      data: json['data'] != null
          ? (json['data'] as List).map((v) => StateData.fromJson(v)).toList()
          : null,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StateData {
  String? statECODE;
  String? statENAME;

  StateData({this.statECODE, this.statENAME});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateData &&
        other.statECODE == statECODE &&
        other.statENAME == statENAME;
  }

  @override
  int get hashCode => statECODE.hashCode ^ statENAME.hashCode;

  // Factory constructor to create an instance from JSON
  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      statECODE: json['statE_CODE'],
      statENAME: json['statE_NAME'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'statE_CODE': statECODE,
      'statE_NAME': statENAME,
    };
  }
}
