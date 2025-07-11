import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String name;
  final String email;
  final int balance;

  User({required this.id, required this.name, required this.email, required this.balance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      balance: json['balance'] ?? 0,
    );
  }
}

class UserService {
  static const String _apiUrl = 'https://assopourtous.com/api';

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
