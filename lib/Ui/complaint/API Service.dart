import 'package:http/http.dart' as http;
import 'package:new_project/Ui/complaint/app_config.dart';
import 'dart:convert';

import 'package:new_project/core/user_session/user_session.dart';


class ComplaintsService {
  Future<Map<String, dynamic>> submitComplaint({
    required String jobTitle,
    required String reportTitle,
    required String reportDetails,
  }) async {
    try {
      final url = '${AppConfig.baseUrl}complaints';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserSession.token}', // ← ضيف ده
        },
        body: jsonEncode({
          'jobTitle': jobTitle,
          'reportTitle': reportTitle,
          'reportDetails': reportDetails,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'حدث خطأ'};
      }
    } catch (e) {
      return {'success': false, 'message': 'تعذر الاتصال بالسيرفر'};
    }
  }
}