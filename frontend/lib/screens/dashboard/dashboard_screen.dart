import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  num _balance = 0;
  List _notes = [];

  @override
  void initState() {
    super.initState();
    _loadWallet();
    _loadNotifications();
  }

  Future<void> _loadWallet() async {
    final res = await http
        .get(Uri.parse('/wallet'), headers: _authHeader())
        .then((r) => jsonDecode(r.body));
    if (mounted) setState(() => _balance = res['balance']);
  }

  Future<void> _loadNotifications() async {
    final res = await http
        .get(Uri.parse('/notifications'), headers: _authHeader())
        .then((r) => jsonDecode(r.body));
    if (mounted) setState(() => _notes = res);
  }

  Map<String, String> _authHeader() {
    final jwt = Supabase.instance.client.auth.currentSession?.accessToken ?? '';
    return {'Authorization': 'Bearer $jwt'};
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.dashboardGreeting(email),
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('Balance: $_balance €',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
                child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (_, i) {
                final n = _notes[i];
                return ListTile(
                  leading:
                      n['is_read'] ? const Icon(Icons.check) : const Icon(Icons.circle),
                  title: Text(n['title'] ?? ''),
                  subtitle: Text(n['body'] ?? ''),
                  trailing: Text(DateFormat.yMd().add_Hm()
                      .format(DateTime.parse(n['created_at']))),
                  onTap: n['is_read']
                      ? null
                      : () async {
                          await http.post(
                              Uri.parse('/notifications/${n['id']}/read'),
                              headers: _authHeader());
                          _loadNotifications();
                        },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
