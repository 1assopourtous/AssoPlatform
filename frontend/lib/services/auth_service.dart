// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://assopourtous.com/api';

  static Future<String> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );


    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['token'];
    } else {
      throw Exception('Login failed: ${res.body}');
    }
  }

  static Future<String> register(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['token'];
    } else {
      throw Exception('Registration failed: ${res.body}');
    }
  }
}
