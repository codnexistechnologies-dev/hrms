import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _preferences;

  // Initialize in main function
  static Future<void> initialize() async =>
      _preferences = await SharedPreferences.getInstance();

  // Clear all data stored in shared preferences
  static Future<void> clear() async {
    await _preferences?.clear();
  }

  // Reference keys
  static const String _keyId = "id";
  static const String _keyName = "name";
  static const String _keyEmail = "email";
  static const String _keyPhone = "phone";
  static const String _recoveryPassword = "recovery_password";
  static const String _keyGender = "gender";
  static const String _keydob = "dob";
  static const String _keyImage = "image";
  static const String _keyDepartmentId = "department_id";
  static const String _role = "role";
  static const String _token = "token";
  static const String _tokenType = "token_type";
  static const String _keyUserLocationName = "locationName";
  static const String _deviceKey = "";

  // Set methods
  static Future<void> setId(int id) async =>
      await _preferences?.setInt(_keyId, id);

  static Future<void> setName(String name) async =>
      await _preferences?.setString(_keyName, name);

  static Future<void> setEmail(String email) async =>
      await _preferences?.setString(_keyEmail, email);
  static Future<void> setPhone(String phone) async =>
      await _preferences?.setString(_keyPhone, phone);
  static Future<void> setGender(String gender) async =>
      await _preferences?.setString(_keyGender, gender);
  static Future<void> setDob(String dob) async =>
      await _preferences?.setString(_keydob, dob);
  static Future<void> setImage(String image) async =>
      await _preferences?.setString(_keyImage, image);
  static Future<void> setDepartmentId(int departmentId) async =>
      await _preferences?.setInt(_keyDepartmentId, departmentId);
  static Future<void> setRole(int role) async =>
      await _preferences?.setInt(_role, role);

  static Future<void> setUserLocationName(String userLocation) async =>
      await _preferences?.setString(_keyUserLocationName, userLocation);

  static Future<void> setRecoveryPassword(String recoveryPassword) async =>
      await _preferences?.setString(_recoveryPassword, recoveryPassword);

  static Future<void> setToken(String token) async =>
      await _preferences?.setString(_token, token);

  static Future<void> setTokenType(String tokenType) async =>
      await _preferences?.setString(_tokenType, tokenType);
  static Future<void> setDeviceKey(String deviceKey) async =>
      await _preferences?.setString(_tokenType, deviceKey);

  // Get methods
  static dynamic getId() => _preferences?.getInt(_keyId);

  static dynamic getName() => _preferences?.getString(_keyName);
  static dynamic getEmail() => _preferences?.getString(_keyEmail);
  static dynamic getPhone() => _preferences?.getString(_keyPhone);
  static dynamic getGender() => _preferences?.getString(_keyGender);
  static dynamic getDob() => _preferences?.getString(_keydob);
  static dynamic getImage() => _preferences?.getString(_keyImage);
  static dynamic getDepartmentId() => _preferences?.getInt(_keyDepartmentId);
  static dynamic getRole() => _preferences?.getInt(_role);
  static dynamic getRecoveryPassword() =>
      _preferences?.getString(_recoveryPassword);
  static dynamic getToken() => _preferences?.getString(_token);
  static dynamic getTokenType() => _preferences?.getString(_tokenType);
  static dynamic getDeviceKey() => _preferences?.getString(_deviceKey);
  static dynamic getUserLocationName() =>
      _preferences?.getString(_keyUserLocationName);
}
