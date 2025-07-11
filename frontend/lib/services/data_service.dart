import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  static const _baseUrl = 'https://assopourtous.com/api';

  static Future<Map<String, dynamic>> wallet(String token) async {
    final res = await http.get(Uri.parse('$_baseUrl/wallet'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Wallet error');
  }

  static Future<List<dynamic>> transactions(String token) async {
    final res = await http.get(Uri.parse('$_baseUrl/transactions'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Transactions error');
  }

  static Future<List<dynamic>> notifications(String token) async {
    final res = await http.get(Uri.parse('$_baseUrl/notifications'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Notifications error');
  }

  static Future<void> markRead(String id, String token) async {
    await http.post(Uri.parse('$_baseUrl/notifications/$id/read'), headers: {
      'Authorization': 'Bearer $token',
    });
  }

  static Future<List<dynamic>> adminUsers(String token) async {
    final res = await http.get(Uri.parse('$_baseUrl/admin/users'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Users error');
  }
}
