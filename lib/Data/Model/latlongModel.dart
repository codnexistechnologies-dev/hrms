class TContact {
  // ignore: non_constant_identifier_names
  String? _emp_code;
  String? _lat;
  String? _long;

  //TContact(this._lat, this._long);
  TContact(this._emp_code, this._lat, this._long);

  //getters
  // ignore: non_constant_identifier_names
  String get EMP_CODE => _emp_code!;
  String get latitude => _lat!;
  String get longitude => _long!;

  @override
  String toString() {
    return 'Contact: {emp_code: $_emp_code, lat: $_lat, long: $_long}';
  }

  //setters
  set EMP_CODE(String empCode) => _emp_code = empCode;
  set latitude(String lat) => _lat = lat;
  set longitude(String long) => _long = long;

  //convert a Contact object to a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['EMP_CODE'] = _emp_code;
    map['latitude'] = _lat;
    map['longitude'] = _long;

    return map;
  }

  //Extract a Contact Object from a Map object
  TContact.fromMapObject(Map<String, dynamic> map) {
    _emp_code = map['EMP_CODE'];
    _lat = map['latitude'];
    _long = map['longitude'];
  }
}
