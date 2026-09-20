import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;
  SharedPref._privateConstructor();

  static Future<void> initialize() async =>
      _preferences = await SharedPreferences.getInstance();
  static final SharedPref instance = SharedPref._privateConstructor();

  Future<void> setStringValue(String key, String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  Future<void> setIntegerValue(String key, int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(key, value);
  }

  Future<int> getIntegerValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key) ?? 0;
  }

  Future<void> setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.containsKey(key);
  }

  Future<Future<bool>> removeValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(key);
  }

  Future<Future<bool>> removeAll() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }

// reference keys

  static const String _keyIsLogedin = "isLogedin";
  static const String _keyempcode = "empcode";
  static const String _keyempname = "empname";
  static const String _keyMobileno = "mobileno";
  static const String _keyEmailid = "emailid";
  static const String _keyLoccode = "loccode";
  static const String _keyLongitude = "longitude";
  static const String _keylatitude = "latitude";
  static const String _keyAtdate = "Atdate";
  static const String _keyin_out_flag = "in_out_flag";
  static const String _keyOfficeAddress = "officeAddress";
  static const String _keyAppupdatedate = "appupdatedate";

  static Future<void> setEmpCode(String empCode) async =>
      await _preferences?.setString(_keyempcode, empCode);

  static dynamic getEmpCode() => _preferences?.getString(_keyempcode) ?? "";

  static Future<void> setEmpName(String userName) async =>
      await _preferences?.setString(_keyempname, userName);

  static dynamic getEmpName() => _preferences?.getString(_keyempname);

  static Future<void> setMobileNo(String mobileno) async =>
      await _preferences?.setString(_keyMobileno, mobileno);

  static dynamic getMobileNo() => _preferences?.getString(_keyMobileno);

  static Future<void> setEmailId(String emailid) async =>
      await _preferences?.setString(_keyEmailid, emailid);

  static dynamic getEmailid() => _preferences?.getString(_keyEmailid);

  static Future<void> setLocCode(String loccode) async =>
      await _preferences?.setString(_keyLoccode, loccode);

  static dynamic getLocCode() => _preferences?.getString(_keyLoccode);

  static Future<void> setLongitude(String longitude) async =>
      await _preferences?.setString(_keyLongitude, longitude);

  static dynamic getLongitude() => _preferences?.getString(_keyLongitude);

  static Future<void> setLatitude(String latitude) async =>
      await _preferences?.setString(_keylatitude, latitude);

  static dynamic getLatitude() => _preferences?.getString(_keylatitude);

  static Future<void> setAtdate(String atdate) async =>
      await _preferences?.setString(_keyAtdate, atdate);

  static dynamic getAtdate() => _preferences?.getString(_keyAtdate);

  static Future<void> setAppupdatedate(String appdate) async =>
      await _preferences?.setString(_keyAppupdatedate, appdate);

  static dynamic getAppupdatedate() =>
      _preferences?.getString(_keyAppupdatedate);

  static Future<void> setInoutflag(String inoutflag) async =>
      await _preferences?.setString(_keyin_out_flag, inoutflag);

  static dynamic getInoutflag() => _preferences?.getString(_keyin_out_flag);

  static Future<void> setOfficeAddress(String officeAddress) async =>
      await _preferences?.setString(_keyOfficeAddress, officeAddress);

  static dynamic getOfficeAddress() =>
      _preferences?.getString(_keyOfficeAddress);

  static Future<bool> getvisitingflag() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    bool isflag = myPrefs.getBool(_keyIsLogedin) ?? false;
    return isflag;
  }

  static Future<void> setvisitingflag() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(_keyIsLogedin, true);
  }
}
