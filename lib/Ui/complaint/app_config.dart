class AppConfig {
  static const String _productionUrl =
      'https://smart-system-attendance-production-d4bd.up.railway.app/api/';
  static const String _localIp = '10.98.220.138'; // ← IP خاص بالـ Android Emulator
  static const String _localUrl = 'http://$_localIp:3000/api/';

  static const bool isProduction = true;

  static String get baseUrl => isProduction ? _productionUrl : _localUrl;
}