// lib/screens/admin/users_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List _rows = [];
  bool _loading = true;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final headers = await getAuthHeaders();
    final res = await http.get(
      Uri.parse('https://assopourtous.com/admin/users'),
      headers: headers,
    );
    setState(() {
      _rows = jsonDecode(res.body);
      _loading = false;
    });
  }

  Future<void> _updateRole(String id, String role) async {
    final headers = await getAuthHeaders();
    await http.patch(
      Uri.parse('https://assopourtous.com/admin/users/$id'),
      headers: headers,
      body: jsonEncode({'role': role}),
    );
    _fetch();
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить пользователя?'),
        content: const Text('Это действие необратимо.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить')),
        ],
      ),
    );
    if (ok == true) {
      final headers = await getAuthHeaders();
      await http.delete(
        Uri.parse('https://assopourtous.com/admin/users/$id'),
        headers: headers,
      );
      _fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: const Text('Пользователи платформы'),
        columns: const [
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Роль')),
          DataColumn(label: Text('Создан')),
          DataColumn(label: Text('')),
        ],
        source: _UserDS(_rows, _updateRole, _delete),
        rowsPerPage: 10,
      ),
    );
  }
}

class _UserDS extends DataTableSource {
  final List rows;
  final void Function(String id, String role) onRole;
  final void Function(String id) onDelete;
  _UserDS(this.rows, this.onRole, this.onDelete);

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    final u = rows[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(u['email'] ?? '')),
        DataCell(
          DropdownButton<String>(
            value: u['role'],
            underline: const SizedBox.shrink(),
            onChanged: (v) => onRole(u['id'], v!),
            items: const [
              DropdownMenuItem(value: 'member', child: Text('member')),
              DropdownMenuItem(value: 'manager', child: Text('manager')),
              DropdownMenuItem(value: 'admin', child: Text('admin')),
            ],
          ),
        ),
        DataCell(Text(u['created_at'].toString().substring(0, 10))),
        DataCell(IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(u['id']),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => rows.length;
  @override
  int get selectedRowCount => 0;
}
