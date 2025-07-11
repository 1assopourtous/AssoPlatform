import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});
  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _total = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Map<String,String> _hdr() {
    // TODO: replace with real auth header
    return {'Authorization': 'Bearer demo'};
  }

  Future<void> _load() async {
    final res = await http.get(Uri.parse('/admin/stats'), headers: _hdr());
    setState(() {
      _total = jsonDecode(res.body)['total'] ?? 0;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child:CircularProgressIndicator());
    return Center(
      child: Text('Total users: $_total',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    );
  }
}
