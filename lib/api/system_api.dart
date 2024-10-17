import 'package:dio/dio.dart';

class SystemApi {
  final String baseUrl = 'https://api.qline.app/api';
  Dio _dio = Dio();

  Object error = "";

  Future<dynamic> login(
      {required String email, required String password}) async {
    try {
      String endpoint = "$baseUrl/login";
      var params = {
        "email": email,
        "password": password,
      };
      var formData = FormData.fromMap(params);

      final response = await _dio.post(endpoint, data: formData);

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      error = e;
      return null;
    }
  }

  Future<dynamic> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      String endpoint = "$baseUrl/register";

      var params = {
        "name": name,
        "email": email,
        "password": password,
        "confirm_password": password,
      };

      var formData = FormData.fromMap(params);

      final response = await _dio.post(endpoint, data: formData);

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTickets(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('$baseUrl/tickets');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch tickets: $e');
    }
  }

  Future<void> addTicket(String token, String title, String message) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      final data = {
        'title': title,
        'message': message,
        'topic': 'yok',
      };
      print(token);
      await _dio.post('$baseUrl/tickets', data: data);

      print('Ticket added successfully.');
    } catch (e) {
      print('Failed to add ticket: $e');
    }
  }
}
