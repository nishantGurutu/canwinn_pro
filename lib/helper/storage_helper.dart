import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _preferences;

  static Future<void> initialize() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> clear() async {
    await _preferences?.clear();
  }

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
  static const String _type = "type";
  static const String _token = "token";
  static const String _tokenType = "token_type";
  static const String _isSnackbarShown = "isSnackbarShown";
  static const String _onetimeMsg = "onetime_msg";
  static const String _keyUserLocationName = "locationName";
  static const String _keyIsCurrentdate = "isCurrentDate";
  static const String _keyIsAnniversaryVisible = "isAnniversaryVisible";
  static const String _keyIsPunchin = "isPunchin";
  static const String _keyIsPunchinDate = "isPunchinDate";
  static const String _keyDailyMessage = "isDailyMessage";
  static const String _keySosMessage = "isSosMessage";
  static const String _deviceKey = "";
  static const String _assignedDept = "assigned_dept";
  static const String _isHead = "is_head";
  static const String _folder_id = "folder_id";

  // Set methods
  static Future<void> setId(int id) async =>
      await _preferences?.setInt(_keyId, id);
  static Future<void> setFolderId(int folderId) async =>
      await _preferences?.setInt(_folder_id, folderId);
  static Future<void> setIshead(int isHead) async =>
      await _preferences?.setInt(_isHead, isHead);

  static Future<void> setName(String name) async =>
      await _preferences?.setString(_keyName, name);
  static Future<void> setDailyMessage(bool dailyMessage) async =>
      await _preferences?.setBool(_keyDailyMessage, dailyMessage);
  static Future<void> setSosMessage(bool sosMessage) async =>
      await _preferences?.setBool(_keySosMessage, sosMessage);

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
  static Future<void> setType(int type) async =>
      await _preferences?.setInt(_type, type);

  static Future<void> setUserLocationName(String userLocation) async =>
      await _preferences?.setString(_keyUserLocationName, userLocation);

  static Future<void> setRecoveryPassword(String recoveryPassword) async =>
      await _preferences?.setString(_recoveryPassword, recoveryPassword);

  static Future<void> setToken(String token) async =>
      await _preferences?.setString(_token, token);

  static Future<void> setTokenType(String tokenType) async =>
      await _preferences?.setString(_tokenType, tokenType);
  static Future<void> setOnetimeMsg(String onetimeMsg) async =>
      await _preferences?.setString(_onetimeMsg, onetimeMsg);
  static Future<void> setDeviceKey(String deviceKey) async =>
      await _preferences?.setString(_tokenType, deviceKey);
  static Future<void> setAnniversaryVisible(bool anniversaryVisible) async =>
      await _preferences?.setBool(_keyIsAnniversaryVisible, anniversaryVisible);
  static Future<void> setIsSnackbarShown(bool isSnackbarShown) async =>
      await _preferences?.setBool(_isSnackbarShown, isSnackbarShown);
  static Future<void> setIsCurrentDate(String isCurrentdate) async =>
      await _preferences?.setString(_keyIsCurrentdate, isCurrentdate);
  static Future<void> setIsPunchin(String isPunchin) async =>
      await _preferences?.setString(_keyIsPunchin, isPunchin);
  static Future<void> setIsPunchinDate(String isPunchinDate) async =>
      await _preferences?.setString(_keyIsPunchinDate, isPunchinDate);
  static Future<void> setAssignedDept(String asssignedDept) async =>
      await _preferences?.setString(_assignedDept, asssignedDept);

  // Get methods
  static dynamic getId() => _preferences?.getInt(_keyId);
  static dynamic getFolderId() => _preferences?.getInt(_folder_id);
  static dynamic getIsHead() => _preferences?.getInt(_isHead);
  static dynamic getAssignedDept() => _preferences?.getString(_assignedDept);

  static dynamic getIsPunchinDate() =>
      _preferences?.getString(_keyIsPunchinDate);
  static dynamic getName() => _preferences?.getString(_keyName);
  static dynamic getDailyMessage() => _preferences?.getBool(_keyDailyMessage);
  static dynamic getSosMessage() => _preferences?.getBool(_keySosMessage);
  static dynamic getEmail() => _preferences?.getString(_keyEmail);
  static dynamic getPhone() => _preferences?.getString(_keyPhone);
  static dynamic getGender() => _preferences?.getString(_keyGender);
  static dynamic getDob() => _preferences?.getString(_keydob);
  static dynamic getImage() => _preferences?.getString(_keyImage);
  static dynamic getDepartmentId() => _preferences?.getInt(_keyDepartmentId);
  static dynamic getRole() => _preferences?.getInt(_role);
  static dynamic getType() => _preferences?.getInt(_type);
  static dynamic getRecoveryPassword() =>
      _preferences?.getString(_recoveryPassword);
  static dynamic getToken() => _preferences?.getString(_token);
  static dynamic getTokenType() => _preferences?.getString(_tokenType);
  static dynamic getOnetimeMsg() => _preferences?.getString(_onetimeMsg);
  static dynamic getDeviceKey() => _preferences?.getString(_deviceKey);
  static dynamic getIsSnackbarShown() =>
      _preferences?.getBool(_isSnackbarShown);
  static dynamic getUserLocationName() =>
      _preferences?.getString(_keyUserLocationName);

  static dynamic getAnniversaryVisible() =>
      _preferences?.getBool(_keyIsAnniversaryVisible);
  static dynamic getIsCurrentDate() =>
      _preferences?.getString(_keyIsCurrentdate);
  static dynamic getIsPunchin() => _preferences?.getString(_keyIsPunchin);
}
