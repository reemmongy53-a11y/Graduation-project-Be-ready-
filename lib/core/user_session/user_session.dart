import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String token = '';
  static String name = '';
  static String role = '';
  static String email = '';
  static String employeeId = '';
  static String password = '';
  static String employeeNumber = '';

  // ✅ بيبدأ بـ false — هيتحدث بعد load()
  static ValueNotifier<bool> gateStatus   = ValueNotifier(false);
  static ValueNotifier<bool> cameraStatus = ValueNotifier(false);

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('role', role);
    await prefs.setString('email', email);
    await prefs.setString('employeeId', employeeId);
    await prefs.setString('password', password);
    await prefs.setString('employeeNumber', employeeNumber);
  }

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token          = prefs.getString('token')          ?? '';
    name           = prefs.getString('name')           ?? '';
    role           = prefs.getString('role')           ?? '';
    email          = prefs.getString('email')          ?? '';
    employeeId     = prefs.getString('employeeId')     ?? '';
    password       = prefs.getString('password')       ?? '';
    employeeNumber = prefs.getString('employeeNumber') ?? '';

    // ✅ بنحمّل الـ status بعد ما بنحمّل باقي البيانات
    gateStatus.value   = prefs.getBool('gateStatus')   ?? false;
    cameraStatus.value = prefs.getBool('cameraStatus') ?? false;
  }

  // ✅ دالة لحفظ الـ gate status
  static Future<void> saveGateStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gateStatus', value);
    gateStatus.value = value;
  }

  // ✅ دالة لحفظ الـ camera status
  static Future<void> saveCameraStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cameraStatus', value);
    cameraStatus.value = value;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token          = '';
    name           = '';
    role           = '';
    email          = '';
    employeeId     = '';
    password       = '';
    employeeNumber = '';
    // ✅ بنرجع الـ status لـ false عند الـ logout
    gateStatus.value   = false;
    cameraStatus.value = false;
  }
}