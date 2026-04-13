import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project/Ui/statusService/gateService/device_command.dart';

class DeviceService {
  final String baseUrl;
  final String token;

  DeviceService({required this.baseUrl, required this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ✅ دالة واحدة بدل اتنين متطابقين
  Future<DeviceCommand> sendCommand(String command) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/device/command'),
      headers: _headers,
      body: jsonEncode({'command': command}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DeviceCommand.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to send command');
    }
  }

  // ✅ دالة واحدة بدل اتنين متطابقين
  Future<bool> isCommandDone() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/device/commands/pending'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['command'] == null;
    } else {
      throw Exception('Failed to check command status');
    }
  }
}